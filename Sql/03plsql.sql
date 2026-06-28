-- ============================================================
-- RAPIDRIDE TAXI MANAGEMENT SYSTEM
-- FILE 3: PL/SQL Package, Procedures, Functions, Triggers (FIXED)
-- Author: Group Project Team
-- Date: JUN-2026
-- ============================================================

SET SERVEROUTPUT ON;
SET FEEDBACK ON;

-- ============================================================
-- 1. PACKAGE SPECIFICATION
-- ============================================================
CREATE OR REPLACE PACKAGE pkg_ride_management AS
    -- Procedures
    PROCEDURE sp_book_ride (
        p_customer_id       IN NUMBER,
        p_pickup_location   IN VARCHAR2,
        p_dropoff_location  IN VARCHAR2,
        p_vehicle_type_id   IN NUMBER,
        p_distance_km       IN NUMBER,
        p_estimated_fare    OUT NUMBER,
        p_ride_id           OUT NUMBER
    );
    
    PROCEDURE sp_assign_driver (
        p_ride_id       IN NUMBER,
        p_driver_id     IN NUMBER,
        p_success       OUT VARCHAR2
    );
    
    PROCEDURE sp_complete_ride (
        p_ride_id       IN NUMBER,
        p_actual_fare   IN NUMBER,
        p_success       OUT VARCHAR2
    );
    
    PROCEDURE sp_process_payment (
        p_ride_id       IN NUMBER,
        p_amount        IN NUMBER,
        p_method        IN VARCHAR2,
        p_payment_id    OUT NUMBER
    );
    
    PROCEDURE sp_get_driver_rides (
        p_driver_id     IN NUMBER,
        p_rides_data    OUT SYS_REFCURSOR
    );
    
    PROCEDURE sp_update_customer_stats (
        p_customer_id   IN NUMBER
    );
    
    -- Functions
    FUNCTION fn_calculate_fare (
        p_vehicle_type_id   IN NUMBER,
        p_distance_km       IN NUMBER,
        p_promo_code        IN VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER;
    
    FUNCTION fn_get_driver_rating (
        p_driver_id     IN NUMBER
    ) RETURN NUMBER;
    
END pkg_ride_management;
/

-- ============================================================
-- 2. PACKAGE BODY
-- ============================================================
CREATE OR REPLACE PACKAGE BODY pkg_ride_management AS

    -- ============================================================
    -- 2.1 Procedure: Book a Ride
    -- ============================================================
    PROCEDURE sp_book_ride (
        p_customer_id       IN NUMBER,
        p_pickup_location   IN VARCHAR2,
        p_dropoff_location  IN VARCHAR2,
        p_vehicle_type_id   IN NUMBER,
        p_distance_km       IN NUMBER,
        p_estimated_fare    OUT NUMBER,
        p_ride_id           OUT NUMBER
    ) IS
        CURSOR cur_location (p_name VARCHAR2) IS
            SELECT location_id FROM locations WHERE UPPER(location_name) LIKE UPPER('%' || p_name || '%') AND ROWNUM = 1;
        
        rec_customer    customers%ROWTYPE;
        
        TYPE ride_rec IS RECORD (
            ride_id     rides.ride_id%TYPE,
            customer_id rides.customer_id%TYPE,
            distance    rides.distance_km%TYPE,
            est_fare    rides.estimated_fare%TYPE
        );
        v_ride_data     ride_rec;
        
        v_pickup_id     NUMBER;
        v_dropoff_id    NUMBER;
        v_fare          NUMBER;
        v_ride_number   NUMBER;
        
        e_invalid_customer EXCEPTION;
        e_invalid_location EXCEPTION;
        e_duplicate_booking EXCEPTION;
        e_invalid_vehicle EXCEPTION;
        
        TYPE location_list IS TABLE OF locations.location_id%TYPE;
        v_locations     location_list := location_list();
        
        TYPE ride_arr IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(30);
        v_ride_details  ride_arr;
        
    BEGIN
        -- Validate customer
        BEGIN
            SELECT * INTO rec_customer
            FROM customers
            WHERE customer_id = p_customer_id AND status = 'ACTIVE';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE e_invalid_customer;
            WHEN TOO_MANY_ROWS THEN
                RAISE e_invalid_customer;
        END;
        
        -- Find pickup location
        BEGIN
            SELECT location_id INTO v_pickup_id
            FROM locations
            WHERE UPPER(location_name) LIKE UPPER('%' || p_pickup_location || '%')
            AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE e_invalid_location;
        END;
        
        -- Find dropoff location
        BEGIN
            SELECT location_id INTO v_dropoff_id
            FROM locations
            WHERE UPPER(location_name) LIKE UPPER('%' || p_dropoff_location || '%')
            AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE e_invalid_location;
        END;
        
        -- Validate vehicle type
        BEGIN
            SELECT COUNT(*) INTO v_locations(1) 
            FROM vehicle_types 
            WHERE vehicle_type_id = p_vehicle_type_id;
            
            IF v_locations(1) = 0 THEN
                RAISE e_invalid_vehicle;
            END IF;
        END;
        
        -- Check duplicate booking
        BEGIN
            SELECT COUNT(*) INTO v_locations(2)
            FROM rides
            WHERE customer_id = p_customer_id
            AND status IN ('REQUESTED', 'ACCEPTED')
            AND request_time > SYSTIMESTAMP - INTERVAL '5' MINUTE
            AND pickup_location_id = v_pickup_id
            AND dropoff_location_id = v_dropoff_id;
            
            IF v_locations(2) > 0 THEN
                RAISE e_duplicate_booking;
            END IF;
        END;
        
        -- Calculate fare
        v_fare := fn_calculate_fare(p_vehicle_type_id, p_distance_km);
        p_estimated_fare := v_fare;
        
        -- Insert ride
        v_ride_number := seq_ride_id.NEXTVAL;
        INSERT INTO rides (
            ride_id, customer_id, pickup_location_id, dropoff_location_id,
            vehicle_type_id, distance_km, estimated_fare, status, request_time
        ) VALUES (
            v_ride_number, p_customer_id, v_pickup_id, v_dropoff_id,
            p_vehicle_type_id, p_distance_km, v_fare, 'REQUESTED', SYSTIMESTAMP
        ) RETURNING ride_id INTO p_ride_id;
        
        -- Update customer
        UPDATE customers SET total_rides = total_rides + 1
        WHERE customer_id = p_customer_id;
        
        -- Log event
        INSERT INTO ride_events (event_id, ride_id, event_type, event_time, new_status, notes)
        VALUES (seq_ride_id.NEXTVAL, v_ride_number, 'CREATED', SYSTIMESTAMP, 'REQUESTED', 'Ride booked by customer');
        
        -- Populate associative array
        v_ride_details('ride_id') := v_ride_number;
        v_ride_details('customer') := rec_customer.full_name;
        v_ride_details('status') := 'REQUESTED';
        v_ride_details('fare') := TO_CHAR(v_fare);
        
        -- Display using collection methods
        IF v_ride_details.EXISTS('ride_id') THEN
            DBMS_OUTPUT.PUT_LINE('✅ Ride booked successfully!');
            DBMS_OUTPUT.PUT_LINE('   Ride ID: ' || v_ride_details('ride_id'));
        END IF;
        
        COMMIT;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            ROLLBACK;
            p_estimated_fare := -1;
            p_ride_id := -1;
            DBMS_OUTPUT.PUT_LINE('❌ Error: Data not found');
        WHEN TOO_MANY_ROWS THEN
            ROLLBACK;
            p_estimated_fare := -1;
            p_ride_id := -1;
            DBMS_OUTPUT.PUT_LINE('❌ Error: Multiple records found');
        WHEN e_invalid_customer THEN
            ROLLBACK;
            p_estimated_fare := -1;
            p_ride_id := -1;
            DBMS_OUTPUT.PUT_LINE('❌ Error: Customer not found or inactive');
        WHEN e_invalid_location THEN
            ROLLBACK;
            p_estimated_fare := -1;
            p_ride_id := -1;
            DBMS_OUTPUT.PUT_LINE('❌ Error: Location not found');
        WHEN e_invalid_vehicle THEN
            ROLLBACK;
            p_estimated_fare := -1;
            p_ride_id := -1;
            DBMS_OUTPUT.PUT_LINE('❌ Error: Invalid vehicle type');
        WHEN e_duplicate_booking THEN
            ROLLBACK;
            p_estimated_fare := -1;
            p_ride_id := -1;
            DBMS_OUTPUT.PUT_LINE('❌ Error: Duplicate booking detected');
        WHEN OTHERS THEN
            ROLLBACK;
            p_estimated_fare := -1;
            p_ride_id := -1;
            DBMS_OUTPUT.PUT_LINE('❌ Unexpected Error: ' || SQLERRM);
    END sp_book_ride;

    -- ============================================================
    -- 2.2 Procedure: Assign Driver
    -- ============================================================
    PROCEDURE sp_assign_driver (
        p_ride_id       IN NUMBER,
        p_driver_id     IN NUMBER,
        p_success       OUT VARCHAR2
    ) IS
        v_ride      rides%ROWTYPE;
        v_driver    drivers%ROWTYPE;
        
        e_ride_not_found EXCEPTION;
        e_driver_not_found EXCEPTION;
        e_driver_unavailable EXCEPTION;
        e_ride_invalid_status EXCEPTION;
        
        CURSOR cur_driver_rides (p_driver_id NUMBER) IS
            SELECT COUNT(*) FROM rides 
            WHERE driver_id = p_driver_id 
            AND status IN ('ACCEPTED', 'IN_PROGRESS');
            
        v_active_rides  NUMBER;
        
    BEGIN
        -- Validate ride
        BEGIN
            SELECT * INTO v_ride
            FROM rides
            WHERE ride_id = p_ride_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE e_ride_not_found;
        END;
        
        -- Check ride status
        IF v_ride.status NOT IN ('REQUESTED', 'ACCEPTED') THEN
            RAISE e_ride_invalid_status;
        END IF;
        
        -- Validate driver
        BEGIN
            SELECT * INTO v_driver
            FROM drivers
            WHERE driver_id = p_driver_id AND status = 'ACTIVE';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE e_driver_not_found;
        END;
        
        -- Check driver availability
        OPEN cur_driver_rides(p_driver_id);
        FETCH cur_driver_rides INTO v_active_rides;
        CLOSE cur_driver_rides;
        
        IF v_active_rides > 0 THEN
            RAISE e_driver_unavailable;
        END IF;
        
        -- Assign driver
        UPDATE rides
        SET driver_id = p_driver_id,
            status = 'ACCEPTED',
            pickup_time = SYSTIMESTAMP
        WHERE ride_id = p_ride_id;
        
        -- Update driver
        UPDATE drivers SET total_rides = total_rides + 1
        WHERE driver_id = p_driver_id;
        
        -- Log event
        INSERT INTO ride_events (event_id, ride_id, event_type, event_time, old_status, new_status, notes)
        VALUES (seq_ride_id.NEXTVAL, p_ride_id, 'ACCEPTED', SYSTIMESTAMP, v_ride.status, 'ACCEPTED', 'Driver assigned');
        
        p_success := 'Driver assigned successfully!';
        COMMIT;
        
    EXCEPTION
        WHEN e_ride_not_found THEN
            ROLLBACK;
            p_success := 'Error: Ride not found';
        WHEN e_driver_not_found THEN
            ROLLBACK;
            p_success := 'Error: Driver not found or inactive';
        WHEN e_driver_unavailable THEN
            ROLLBACK;
            p_success := 'Error: Driver is currently on another ride';
        WHEN e_ride_invalid_status THEN
            ROLLBACK;
            p_success := 'Error: Ride cannot be assigned';
        WHEN OTHERS THEN
            ROLLBACK;
            p_success := 'Unexpected error: ' || SQLERRM;
    END sp_assign_driver;

    -- ============================================================
    -- 2.3 Procedure: Complete Ride (FIXED)
    -- ============================================================
    PROCEDURE sp_complete_ride (
        p_ride_id       IN NUMBER,
        p_actual_fare   IN NUMBER,
        p_success       OUT VARCHAR2
    ) IS
        v_ride      rides%ROWTYPE;
        v_driver    drivers%ROWTYPE;
        v_customer  customers%ROWTYPE;
        v_payment_id NUMBER;  -- ← ADDED: Local variable for payment ID
        
        e_ride_not_found EXCEPTION;
        e_ride_invalid_status EXCEPTION;
        e_invalid_fare EXCEPTION;
        
        TYPE driver_earnings IS TABLE OF drivers.total_earnings%TYPE;
        v_earnings  driver_earnings := driver_earnings();
        
    BEGIN
        -- Validate ride
        BEGIN
            SELECT * INTO v_ride
            FROM rides
            WHERE ride_id = p_ride_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE e_ride_not_found;
        END;
        
        -- Check status
        IF v_ride.status NOT IN ('ACCEPTED', 'IN_PROGRESS') THEN
            RAISE e_ride_invalid_status;
        END IF;
        
        -- Validate fare
        IF p_actual_fare <= 0 THEN
            RAISE e_invalid_fare;
        END IF;
        
        -- Complete ride
        UPDATE rides
        SET status = 'COMPLETED',
            actual_fare = p_actual_fare,
            completion_time = SYSTIMESTAMP
        WHERE ride_id = p_ride_id;
        
        -- Update driver earnings
        IF v_ride.driver_id IS NOT NULL THEN
            UPDATE drivers 
            SET total_earnings = total_earnings + p_actual_fare
            WHERE driver_id = v_ride.driver_id;
            
            -- Update customer
            UPDATE customers 
            SET total_spent = total_spent + p_actual_fare
            WHERE customer_id = v_ride.customer_id;
        END IF;
        
        -- Log event
        INSERT INTO ride_events (event_id, ride_id, event_type, event_time, old_status, new_status, notes)
        VALUES (seq_ride_id.NEXTVAL, p_ride_id, 'COMPLETED', SYSTIMESTAMP, v_ride.status, 'COMPLETED', 'Ride completed');
        
        -- Process payment (calls another procedure) - FIXED: Using local variable
        sp_process_payment(p_ride_id, p_actual_fare, 'CASH', v_payment_id);  -- ← FIXED: v_payment_id instead of p_ride_id
        
        p_success := 'Ride completed successfully!';
        COMMIT;
        
    EXCEPTION
        WHEN e_ride_not_found THEN
            ROLLBACK;
            p_success := 'Error: Ride not found';
        WHEN e_ride_invalid_status THEN
            ROLLBACK;
            p_success := 'Error: Cannot complete - ride is ' || v_ride.status;
        WHEN e_invalid_fare THEN
            ROLLBACK;
            p_success := 'Error: Invalid fare amount';
        WHEN OTHERS THEN
            ROLLBACK;
            p_success := 'Unexpected error: ' || SQLERRM;
    END sp_complete_ride;

    -- ============================================================
    -- 2.4 Procedure: Process Payment
    -- ============================================================
    PROCEDURE sp_process_payment (
        p_ride_id       IN NUMBER,
        p_amount        IN NUMBER,
        p_method        IN VARCHAR2,
        p_payment_id    OUT NUMBER
    ) IS
        v_ride      rides%ROWTYPE;
        
        e_ride_not_found EXCEPTION;
        e_payment_failed EXCEPTION;
        
    BEGIN
        -- Get ride details
        BEGIN
            SELECT * INTO v_ride
            FROM rides
            WHERE ride_id = p_ride_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE e_ride_not_found;
        END;
        
        -- Validate amount
        IF p_amount < v_ride.estimated_fare * 0.5 OR p_amount > v_ride.estimated_fare * 2 THEN
            RAISE e_payment_failed;
        END IF;
        
        -- Generate payment ID
        p_payment_id := seq_payment_id.NEXTVAL;
        
        -- Insert payment
        INSERT INTO payments (
            payment_id, ride_id, customer_id, driver_id,
            amount, payment_method, payment_status, payment_time
        ) VALUES (
            p_payment_id, p_ride_id, v_ride.customer_id, v_ride.driver_id,
            p_amount, p_method, 'COMPLETED', SYSTIMESTAMP
        );
        
        -- Audit log
        INSERT INTO audit_log (log_id, table_name, action_type, record_id, new_values, user_id)
        VALUES (
            seq_ride_id.NEXTVAL, 'PAYMENTS', 'INSERT', p_payment_id,
            '{"amount":' || p_amount || ',"method":"' || p_method || '"}',
            1
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('✅ Payment processed: $' || p_amount);
        
    EXCEPTION
        WHEN e_ride_not_found THEN
            ROLLBACK;
            p_payment_id := -1;
            DBMS_OUTPUT.PUT_LINE('❌ Error: Ride not found');
        WHEN e_payment_failed THEN
            ROLLBACK;
            p_payment_id := -1;
            DBMS_OUTPUT.PUT_LINE('❌ Error: Payment validation failed');
        WHEN OTHERS THEN
            ROLLBACK;
            p_payment_id := -1;
            DBMS_OUTPUT.PUT_LINE('❌ Payment Error: ' || SQLERRM);
    END sp_process_payment;

    -- ============================================================
    -- 2.5 Function: Calculate Fare
    -- ============================================================
    FUNCTION fn_calculate_fare (
        p_vehicle_type_id   IN NUMBER,
        p_distance_km       IN NUMBER,
        p_promo_code        IN VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER IS
        TYPE vehicle_rec IS RECORD (
            type_id     vehicle_types.vehicle_type_id%TYPE,
            base_fare   vehicle_types.base_fare%TYPE,
            rate_per_km vehicle_types.rate_per_km%TYPE
        );
        v_vehicle   vehicle_rec;
        
        v_total_fare    NUMBER;
        v_discount      NUMBER := 0;
        
        e_vehicle_not_found EXCEPTION;
        
        CURSOR cur_promo (p_code VARCHAR2) IS
            SELECT * FROM promotions
            WHERE UPPER(promo_code) = UPPER(p_code)
            AND status = 'ACTIVE'
            AND valid_from <= SYSDATE
            AND valid_until >= SYSDATE
            AND (usage_limit = 0 OR times_used < usage_limit);
            
        v_promo    promotions%ROWTYPE;
        
    BEGIN
        -- Get vehicle type
        BEGIN
            SELECT vehicle_type_id, base_fare, rate_per_km
            INTO v_vehicle
            FROM vehicle_types
            WHERE vehicle_type_id = p_vehicle_type_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE e_vehicle_not_found;
        END;
        
        -- Calculate base fare
        v_total_fare := v_vehicle.base_fare + (v_vehicle.rate_per_km * p_distance_km);
        
        -- Apply promotion
        IF p_promo_code IS NOT NULL THEN
            OPEN cur_promo(p_promo_code);
            FETCH cur_promo INTO v_promo;
            IF cur_promo%FOUND THEN
                IF v_promo.discount_percent IS NOT NULL THEN
                    v_discount := v_total_fare * (v_promo.discount_percent / 100);
                ELSIF v_promo.discount_amount IS NOT NULL THEN
                    v_discount := v_promo.discount_amount;
                END IF;
                
                IF v_promo.min_fare_required IS NOT NULL AND v_total_fare < v_promo.min_fare_required THEN
                    v_discount := 0;
                END IF;
                
                UPDATE promotions 
                SET times_used = times_used + 1
                WHERE promotion_id = v_promo.promotion_id;
            END IF;
            CLOSE cur_promo;
        END IF;
        
        v_total_fare := ROUND(v_total_fare - v_discount, 2);
        
        IF v_total_fare < 2.00 THEN
            v_total_fare := 2.00;
        END IF;
        
        RETURN v_total_fare;
        
    EXCEPTION
        WHEN e_vehicle_not_found THEN
            DBMS_OUTPUT.PUT_LINE('❌ Vehicle type not found');
            RETURN -1;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Fare Error: ' || SQLERRM);
            RETURN -1;
    END fn_calculate_fare;

    -- ============================================================
    -- 2.6 Function: Get Driver Rating
    -- ============================================================
    FUNCTION fn_get_driver_rating (
        p_driver_id     IN NUMBER
    ) RETURN NUMBER IS
        v_driver    drivers%ROWTYPE;
        v_avg_rating    NUMBER;
        e_driver_not_found EXCEPTION;
        
        CURSOR cur_reviews (p_driver_id NUMBER) IS
            SELECT AVG(rating) AS avg_rating
            FROM reviews
            WHERE driver_id = p_driver_id
            AND is_visible = 'Y';
            
    BEGIN
        BEGIN
            SELECT * INTO v_driver
            FROM drivers
            WHERE driver_id = p_driver_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE e_driver_not_found;
        END;
        
        OPEN cur_reviews(p_driver_id);
        FETCH cur_reviews INTO v_avg_rating;
        CLOSE cur_reviews;
        
        IF v_avg_rating IS NULL THEN
            RETURN ROUND(v_driver.rating, 2);
        END IF;
        
        UPDATE drivers
        SET rating = ROUND(v_avg_rating, 2)
        WHERE driver_id = p_driver_id;
        
        COMMIT;
        RETURN ROUND(v_avg_rating, 2);
        
    EXCEPTION
        WHEN e_driver_not_found THEN
            DBMS_OUTPUT.PUT_LINE('❌ Driver not found');
            RETURN 0;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Rating Error: ' || SQLERRM);
            RETURN 0;
    END fn_get_driver_rating;

    -- ============================================================
    -- 2.7 Procedure: Get Driver Rides
    -- ============================================================
    PROCEDURE sp_get_driver_rides (
        p_driver_id     IN NUMBER,
        p_rides_data    OUT SYS_REFCURSOR
    ) IS
        TYPE driver_rides_rec IS RECORD (
            ride_id         rides.ride_id%TYPE,
            customer_name   VARCHAR2(100),
            pickup          VARCHAR2(100),
            dropoff         VARCHAR2(100),
            status          rides.status%TYPE,
            fare            rides.estimated_fare%TYPE,
            ride_date       TIMESTAMP
        );
        v_ride_data driver_rides_rec;
        
        TYPE ride_summary IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
        v_summary   ride_summary;
        v_idx       PLS_INTEGER := 1;
        
        CURSOR cur_driver_rides (p_driver_id NUMBER) IS
            SELECT 
                r.ride_id,
                c.full_name AS customer_name,
                l1.location_name AS pickup,
                l2.location_name AS dropoff,
                r.status,
                r.estimated_fare AS fare,
                r.request_time AS ride_date
            FROM rides r
            JOIN customers c ON r.customer_id = c.customer_id
            JOIN locations l1 ON r.pickup_location_id = l1.location_id
            JOIN locations l2 ON r.dropoff_location_id = l2.location_id
            WHERE r.driver_id = p_driver_id
            ORDER BY r.request_time DESC;
            
        e_driver_not_found EXCEPTION;
        e_no_rides EXCEPTION;
        
        v_driver_check  NUMBER;
        
    BEGIN
        -- Check driver exists
        SELECT COUNT(*) INTO v_driver_check
        FROM drivers WHERE driver_id = p_driver_id;
        
        IF v_driver_check = 0 THEN
            RAISE e_driver_not_found;
        END IF;
        
        -- Open cursor
        OPEN p_rides_data FOR
            SELECT 
                r.ride_id,
                c.full_name AS customer_name,
                l1.location_name AS pickup,
                l2.location_name AS dropoff,
                r.status,
                r.estimated_fare AS fare,
                r.request_time AS ride_date
            FROM rides r
            JOIN customers c ON r.customer_id = c.customer_id
            JOIN locations l1 ON r.pickup_location_id = l1.location_id
            JOIN locations l2 ON r.dropoff_location_id = l2.location_id
            WHERE r.driver_id = p_driver_id
            ORDER BY r.request_time DESC;
        
        -- Populate associative array using Cursor FOR loop
        v_idx := 1;
        FOR rec IN cur_driver_rides(p_driver_id) LOOP
            v_summary(v_idx) := 'Ride #' || rec.ride_id || 
                                ': ' || rec.customer_name || 
                                ' (' || rec.status || ') - $' || TO_CHAR(rec.fare);
            v_idx := v_idx + 1;
        END LOOP;
        
        -- Display using collection methods
        IF v_summary.COUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('📋 Ride Summary for Driver #' || p_driver_id);
            DBMS_OUTPUT.PUT_LINE('   Total Rides: ' || v_summary.COUNT);
            
            v_idx := v_summary.FIRST;
            WHILE v_idx IS NOT NULL LOOP
                DBMS_OUTPUT.PUT_LINE('   ' || v_idx || ') ' || v_summary(v_idx));
                v_idx := v_summary.NEXT(v_idx);
            END LOOP;
        ELSE
            RAISE e_no_rides;
        END IF;
        
    EXCEPTION
        WHEN e_driver_not_found THEN
            DBMS_OUTPUT.PUT_LINE('❌ Driver not found');
        WHEN e_no_rides THEN
            DBMS_OUTPUT.PUT_LINE('ℹ️ No rides found for this driver');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Error: ' || SQLERRM);
    END sp_get_driver_rides;

    -- ============================================================
    -- 2.8 Procedure: Update Customer Stats
    -- ============================================================
    PROCEDURE sp_update_customer_stats (
        p_customer_id   IN NUMBER
    ) IS
        v_customer  customers%ROWTYPE;
        v_ride_count    NUMBER;
        v_total_spent   NUMBER;
        v_avg_rating    NUMBER;
        
        e_customer_not_found EXCEPTION;
        
        CURSOR cur_customer_stats (p_customer_id NUMBER) IS
            SELECT 
                COUNT(*) AS ride_count,
                NVL(SUM(actual_fare), 0) AS total_spent
            FROM rides
            WHERE customer_id = p_customer_id
            AND status = 'COMPLETED';
            
    BEGIN
        -- Validate customer
        BEGIN
            SELECT * INTO v_customer
            FROM customers
            WHERE customer_id = p_customer_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE e_customer_not_found;
        END;
        
        -- Get stats
        OPEN cur_customer_stats(p_customer_id);
        FETCH cur_customer_stats INTO v_ride_count, v_total_spent;
        CLOSE cur_customer_stats;
        
        -- Update customer
        UPDATE customers
        SET total_rides = v_ride_count,
            total_spent = v_total_spent
        WHERE customer_id = p_customer_id;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('✅ Customer stats updated!');
        DBMS_OUTPUT.PUT_LINE('   Rides: ' || v_ride_count || ' | Spent: $' || v_total_spent);
        
    EXCEPTION
        WHEN e_customer_not_found THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('❌ Customer not found');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('❌ Error: ' || SQLERRM);
    END sp_update_customer_stats;

END pkg_ride_management;
/

-- ============================================================
-- 3. DATABASE TRIGGERS
-- ============================================================

-- 3.1 BEFORE INSERT Trigger on RIDES - Validate booking
CREATE OR REPLACE TRIGGER trg_rides_before_insert
BEFORE INSERT ON rides
FOR EACH ROW
DECLARE
    e_invalid_booking EXCEPTION;
    e_duplicate_ride EXCEPTION;
    
    v_customer_status   customers.status%TYPE;
    v_active_rides      NUMBER;
    
    CURSOR cur_customer (p_customer_id NUMBER) IS
        SELECT status FROM customers WHERE customer_id = p_customer_id;
        
    CURSOR cur_duplicate (p_customer_id NUMBER, p_pickup NUMBER, p_dropoff NUMBER) IS
        SELECT COUNT(*) FROM rides
        WHERE customer_id = p_customer_id
        AND pickup_location_id = p_pickup
        AND dropoff_location_id = p_dropoff
        AND status IN ('REQUESTED', 'ACCEPTED', 'IN_PROGRESS')
        AND request_time > SYSTIMESTAMP - INTERVAL '10' MINUTE;
        
BEGIN
    -- Check customer is active
    OPEN cur_customer(:NEW.customer_id);
    FETCH cur_customer INTO v_customer_status;
    CLOSE cur_customer;
    
    IF v_customer_status != 'ACTIVE' THEN
        RAISE e_invalid_booking;
    END IF;
    
    -- Check pickup and dropoff are different
    IF :NEW.pickup_location_id = :NEW.dropoff_location_id THEN
        RAISE e_invalid_booking;
    END IF;
    
    -- Check duplicate booking
    OPEN cur_duplicate(:NEW.customer_id, :NEW.pickup_location_id, :NEW.dropoff_location_id);
    FETCH cur_duplicate INTO v_active_rides;
    CLOSE cur_duplicate;
    
    IF v_active_rides > 0 THEN
        RAISE e_duplicate_ride;
    END IF;
    
    -- Validate distance
    IF :NEW.distance_km > 100 THEN
        RAISE e_invalid_booking;
    END IF;
    
    -- Set default status
    IF :NEW.status IS NULL THEN
        :NEW.status := 'REQUESTED';
    END IF;
    
EXCEPTION
    WHEN e_invalid_booking THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid booking: Customer inactive or invalid locations');
    WHEN e_duplicate_ride THEN
        RAISE_APPLICATION_ERROR(-20002, 'Duplicate ride: Similar active booking exists');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20999, 'Trigger error: ' || SQLERRM);
END trg_rides_before_insert;
/

-- 3.2 AFTER UPDATE Trigger on RIDES - Audit trail
CREATE OR REPLACE TRIGGER trg_rides_after_update
AFTER UPDATE ON rides
FOR EACH ROW
DECLARE
    v_notes VARCHAR2(500);
    v_user_id   NUMBER;
    
    CURSOR cur_user IS
        SELECT user_id FROM users WHERE role = 'ADMIN' AND ROWNUM = 1;
        
BEGIN
    OPEN cur_user;
    FETCH cur_user INTO v_user_id;
    CLOSE cur_user;
    
    -- Log status changes
    IF :OLD.status != :NEW.status THEN
        v_notes := 'Status changed from ' || :OLD.status || ' to ' || :NEW.status;
        
        INSERT INTO ride_events (
            event_id, ride_id, event_type, event_time,
            old_status, new_status, notes
        ) VALUES (
            seq_ride_id.NEXTVAL, :NEW.ride_id, 'UPDATED', SYSTIMESTAMP,
            :OLD.status, :NEW.status, v_notes
        );
    END IF;
    
    -- Log fare changes
    IF NVL(:OLD.estimated_fare, 0) != NVL(:NEW.estimated_fare, 0) THEN
        INSERT INTO audit_log (
            log_id, table_name, action_type, record_id,
            old_values, new_values, user_id
        ) VALUES (
            seq_ride_id.NEXTVAL, 'RIDES', 'UPDATE', :NEW.ride_id,
            '{"estimated_fare":"' || :OLD.estimated_fare || '"}',
            '{"estimated_fare":"' || :NEW.estimated_fare || '"}',
            v_user_id
        );
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('⚠️ Audit trigger warning: ' || SQLERRM);
END trg_rides_after_update;
/

-- 3.3 BEFORE INSERT Trigger on PAYMENTS - Validate payment
CREATE OR REPLACE TRIGGER trg_payments_before_insert
BEFORE INSERT ON payments
FOR EACH ROW
DECLARE
    e_payment_validation EXCEPTION;
    
    CURSOR cur_ride (p_ride_id NUMBER) IS
        SELECT status, actual_fare, estimated_fare
        FROM rides
        WHERE ride_id = p_ride_id;
        
    v_ride_status       rides.status%TYPE;
    v_ride_actual_fare  rides.actual_fare%TYPE;
    v_ride_est_fare     rides.estimated_fare%TYPE;
    
BEGIN
    -- Check ride exists and is completed
    OPEN cur_ride(:NEW.ride_id);
    FETCH cur_ride INTO v_ride_status, v_ride_actual_fare, v_ride_est_fare;
    
    IF cur_ride%NOTFOUND THEN
        RAISE e_payment_validation;
    END IF;
    CLOSE cur_ride;
    
    -- Validate ride status
    IF v_ride_status != 'COMPLETED' THEN
        RAISE_APPLICATION_ERROR(-20003, 'Payment only allowed for completed rides');
    END IF;
    
    -- Validate amount
    IF :NEW.amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Payment amount must be positive');
    END IF;
    
    -- Set defaults
    IF :NEW.payment_status IS NULL THEN
        :NEW.payment_status := 'PENDING';
    END IF;
    
    IF :NEW.payment_time IS NULL THEN
        :NEW.payment_time := SYSTIMESTAMP;
    END IF;
    
EXCEPTION
    WHEN e_payment_validation THEN
        RAISE_APPLICATION_ERROR(-20006, 'Invalid payment: Ride not found');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20999, 'Payment trigger error: ' || SQLERRM);
END trg_payments_before_insert;
/

-- 3.4 AFTER DELETE Trigger on RIDES - Archive deleted rides
CREATE OR REPLACE TRIGGER trg_rides_after_delete
AFTER DELETE ON rides
FOR EACH ROW
DECLARE
    e_deletion_blocked EXCEPTION;
    
BEGIN
    -- Prevent deletion of completed rides
    IF :OLD.status = 'COMPLETED' THEN
        RAISE_APPLICATION_ERROR(-20007, 'Cannot delete completed rides');
    END IF;
    
    -- Log deletion
    INSERT INTO audit_log (
        log_id, table_name, action_type, record_id,
        old_values, user_id
    ) VALUES (
        seq_ride_id.NEXTVAL, 'RIDES', 'DELETE', :OLD.ride_id,
        '{"status":"' || :OLD.status || '","customer_id":' || :OLD.customer_id || '"}',
        1
    );
    
    -- Log ride event
    INSERT INTO ride_events (
        event_id, ride_id, event_type, event_time, notes
    ) VALUES (
        seq_ride_id.NEXTVAL, :OLD.ride_id, 'CANCELLED', SYSTIMESTAMP,
        'Ride deleted by system'
    );
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20999, 'Delete trigger error: ' || SQLERRM);
END trg_rides_after_delete;
/

PROMPT =========================================
PROMPT PL/SQL PACKAGE AND TRIGGERS CREATED!
PROMPT =========================================
COMMIT;
/
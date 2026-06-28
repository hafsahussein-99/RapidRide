-- ============================================================
-- CLEANUP: Drop all tables and sequences
-- ============================================================
BEGIN
    FOR c IN (SELECT object_name, object_type 
              FROM user_objects 
              WHERE object_type IN ('TABLE', 'SEQUENCE'))
    LOOP
        IF c.object_type = 'TABLE' THEN
            EXECUTE IMMEDIATE 'DROP TABLE ' || c.object_name || ' CASCADE CONSTRAINTS';
        ELSIF c.object_type = 'SEQUENCE' THEN
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || c.object_name;
        END IF;
    END LOOP;
END;
/

-- ============================================================
-- CREATE SEQUENCES
-- ============================================================
CREATE SEQUENCE seq_customer_id START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE seq_driver_id START WITH 500 INCREMENT BY 1;
CREATE SEQUENCE seq_ride_id START WITH 2000 INCREMENT BY 1;
CREATE SEQUENCE seq_payment_id START WITH 3000 INCREMENT BY 1;
CREATE SEQUENCE seq_review_id START WITH 4000 INCREMENT BY 1;
CREATE SEQUENCE seq_vehicle_id START WITH 100 INCREMENT BY 1;

-- ============================================================
-- CREATE TABLES (No Foreign Key Dependencies)
-- ============================================================

-- 1. CUSTOMERS
CREATE TABLE customers (
    customer_id     NUMBER PRIMARY KEY,
    full_name       VARCHAR2(100) NOT NULL,
    phone           VARCHAR2(20) NOT NULL UNIQUE,
    email           VARCHAR2(100) UNIQUE,
    address         VARCHAR2(200),
    registration_date DATE DEFAULT SYSDATE,
    total_rides     NUMBER DEFAULT 0,
    total_spent     NUMBER(10,2) DEFAULT 0,
    status          VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'BLOCKED')),
    CONSTRAINT chk_customer_phone CHECK (LENGTH(phone) >= 10)
);

-- 2. VEHICLE_TYPES
CREATE TABLE vehicle_types (
    vehicle_type_id     NUMBER PRIMARY KEY,
    type_name           VARCHAR2(30) NOT NULL UNIQUE,
    base_fare           NUMBER(8,2) NOT NULL,
    rate_per_km         NUMBER(8,2) NOT NULL,
    seating_capacity    NUMBER DEFAULT 4,
    description         VARCHAR2(200),
    CONSTRAINT chk_vehicle_fare CHECK (base_fare >= 0 AND rate_per_km >= 0)
);

-- 3. DRIVERS
CREATE TABLE drivers (
    driver_id           NUMBER PRIMARY KEY,
    full_name           VARCHAR2(100) NOT NULL,
    phone               VARCHAR2(20) NOT NULL UNIQUE,
    email               VARCHAR2(100) UNIQUE,
    license_number      VARCHAR2(30) NOT NULL UNIQUE,
    license_expiry      DATE NOT NULL,
    hire_date           DATE DEFAULT SYSDATE,
    rating              NUMBER(3,2) DEFAULT 0,
    total_rides         NUMBER DEFAULT 0,
    total_earnings      NUMBER(10,2) DEFAULT 0,
    status              VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'ON_LEAVE', 'SUSPENDED', 'TERMINATED')),
    CONSTRAINT chk_driver_rating CHECK (rating >= 0 AND rating <= 5),
    CONSTRAINT chk_driver_phone CHECK (LENGTH(phone) >= 10)
);

-- 4. LOCATIONS
CREATE TABLE locations (
    location_id         NUMBER PRIMARY KEY,
    location_name       VARCHAR2(100) NOT NULL,
    city                VARCHAR2(50) NOT NULL,
    district            VARCHAR2(50),
    latitude            NUMBER(10,6),
    longitude           NUMBER(10,6),
    is_popular          CHAR(1) DEFAULT 'N' CHECK (is_popular IN ('Y', 'N')),
    CONSTRAINT uk_location_name_city UNIQUE (location_name, city)
);

-- 5. PROMOTIONS
CREATE TABLE promotions (
    promotion_id        NUMBER PRIMARY KEY,
    promo_code          VARCHAR2(20) NOT NULL UNIQUE,
    description         VARCHAR2(200),
    discount_percent    NUMBER(5,2),
    discount_amount     NUMBER(8,2),
    min_fare_required   NUMBER(8,2),
    valid_from          DATE NOT NULL,
    valid_until         DATE NOT NULL,
    usage_limit         NUMBER DEFAULT 0,
    times_used          NUMBER DEFAULT 0,
    status              VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'EXPIRED', 'DISABLED')),
    CONSTRAINT chk_promo_discount CHECK (discount_percent >= 0 AND discount_percent <= 100),
    CONSTRAINT chk_promo_dates CHECK (valid_from <= valid_until)
);

-- 6. USERS
CREATE TABLE users (
    user_id             NUMBER PRIMARY KEY,
    username            VARCHAR2(50) NOT NULL UNIQUE,
    password_hash       VARCHAR2(255) NOT NULL,
    full_name           VARCHAR2(100) NOT NULL,
    email               VARCHAR2(100) NOT NULL UNIQUE,
    role                VARCHAR2(30) NOT NULL CHECK (role IN ('ADMIN', 'MANAGER', 'DRIVER', 'CUSTOMER')),
    last_login          TIMESTAMP,
    status              VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'LOCKED')),
    created_date        DATE DEFAULT SYSDATE
);

-- ============================================================
-- 7. VEHICLES (FIXED - Removed SYSDATE from CHECK)
-- ============================================================
CREATE TABLE vehicles (
    vehicle_id          NUMBER PRIMARY KEY,
    driver_id           NUMBER NOT NULL,
    vehicle_type_id     NUMBER NOT NULL,
    plate_number        VARCHAR2(20) NOT NULL UNIQUE,
    model               VARCHAR2(50) NOT NULL,
    brand               VARCHAR2(50) NOT NULL,
    year                NUMBER(4),
    color               VARCHAR2(30),
    status              VARCHAR2(20) DEFAULT 'AVAILABLE' CHECK (status IN ('AVAILABLE', 'IN_TRIP', 'MAINTENANCE', 'INACTIVE')),
    CONSTRAINT chk_vehicle_year CHECK (year >= 2000 AND year <= 2026)  -- ← FIXED: Used static year
);

-- ============================================================
-- 8. RIDES
-- ============================================================
CREATE TABLE rides (
    ride_id             NUMBER PRIMARY KEY,
    customer_id         NUMBER NOT NULL,
    driver_id           NUMBER,
    pickup_location_id  NUMBER NOT NULL,
    dropoff_location_id NUMBER NOT NULL,
    vehicle_type_id     NUMBER NOT NULL,
    distance_km         NUMBER(8,2) NOT NULL,
    estimated_fare      NUMBER(10,2),
    actual_fare         NUMBER(10,2),
    status              VARCHAR2(30) DEFAULT 'REQUESTED' CHECK (status IN ('REQUESTED', 'ACCEPTED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW')),
    request_time        TIMESTAMP DEFAULT SYSTIMESTAMP,
    pickup_time         TIMESTAMP,
    completion_time     TIMESTAMP,
    cancellation_reason VARCHAR2(200),
    special_requests    VARCHAR2(200),
    CONSTRAINT chk_ride_fare CHECK (estimated_fare >= 0 AND actual_fare >= 0),
    CONSTRAINT chk_ride_distance CHECK (distance_km >= 0)
);

-- ============================================================
-- 8. RIDES
-- ============================================================
CREATE TABLE rides (
    ride_id             NUMBER PRIMARY KEY,
    customer_id         NUMBER NOT NULL,
    driver_id           NUMBER,
    pickup_location_id  NUMBER NOT NULL,
    dropoff_location_id NUMBER NOT NULL,
    vehicle_type_id     NUMBER NOT NULL,
    distance_km         NUMBER(8,2) NOT NULL,
    estimated_fare      NUMBER(10,2),
    actual_fare         NUMBER(10,2),
    status              VARCHAR2(30) DEFAULT 'REQUESTED' CHECK (status IN ('REQUESTED', 'ACCEPTED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW')),
    request_time        TIMESTAMP DEFAULT SYSTIMESTAMP,
    pickup_time         TIMESTAMP,
    completion_time     TIMESTAMP,
    cancellation_reason VARCHAR2(200),
    special_requests    VARCHAR2(200),
    CONSTRAINT chk_ride_fare CHECK (estimated_fare >= 0 AND actual_fare >= 0),
    CONSTRAINT chk_ride_distance CHECK (distance_km >= 0)
);

-- ============================================================
-- 9. REVIEWS (FIXED - Changed 'comment' to 'review_comment')
-- ============================================================
CREATE TABLE reviews (
    review_id           NUMBER PRIMARY KEY,
    ride_id             NUMBER NOT NULL,
    customer_id         NUMBER NOT NULL,
    driver_id           NUMBER,
    rating              NUMBER(2,1) NOT NULL,
    review_comment      VARCHAR2(500),  -- ← FIXED: Changed from 'comment'
    review_time         TIMESTAMP DEFAULT SYSTIMESTAMP,
    is_visible          CHAR(1) DEFAULT 'Y' CHECK (is_visible IN ('Y', 'N')),
    CONSTRAINT chk_review_rating CHECK (rating >= 1 AND rating <= 5)
);

-- ============================================================
-- 10. PAYMENTS
-- ============================================================
CREATE TABLE payments (
    payment_id          NUMBER PRIMARY KEY,
    ride_id             NUMBER NOT NULL,
    customer_id         NUMBER NOT NULL,
    driver_id           NUMBER,
    amount              NUMBER(10,2) NOT NULL,
    payment_method      VARCHAR2(30) NOT NULL CHECK (payment_method IN ('CASH', 'CARD', 'MOBILE_MONEY', 'ONLINE')),
    payment_status      VARCHAR2(20) DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED')),
    payment_time        TIMESTAMP DEFAULT SYSTIMESTAMP,
    transaction_ref     VARCHAR2(50),
    notes               VARCHAR2(200),
    CONSTRAINT chk_payment_amount CHECK (amount >= 0)
);

-- 11. DRIVER_DOCUMENTS
CREATE TABLE driver_documents (
    document_id         NUMBER PRIMARY KEY,
    driver_id           NUMBER NOT NULL,
    document_type       VARCHAR2(30) NOT NULL CHECK (document_type IN ('LICENSE', 'INSURANCE', 'VEHICLE_REG', 'OTHER')),
    document_number     VARCHAR2(50) NOT NULL,
    issue_date          DATE NOT NULL,
    expiry_date         DATE NOT NULL,
    status              VARCHAR2(20) DEFAULT 'VALID' CHECK (status IN ('VALID', 'EXPIRED', 'PENDING', 'REJECTED')),
    file_path           VARCHAR2(200),
    uploaded_date       DATE DEFAULT SYSDATE,
    CONSTRAINT chk_doc_dates CHECK (issue_date <= expiry_date)
);

-- 12. RIDE_EVENTS
CREATE TABLE ride_events (
    event_id            NUMBER PRIMARY KEY,
    ride_id             NUMBER NOT NULL,
    event_type          VARCHAR2(30) NOT NULL CHECK (event_type IN ('CREATED', 'ACCEPTED', 'STARTED', 'COMPLETED', 'CANCELLED', 'UPDATED')),
    event_time          TIMESTAMP DEFAULT SYSTIMESTAMP,
    old_status          VARCHAR2(30),
    new_status          VARCHAR2(30),
    notes               VARCHAR2(200)
);

-- 13. AUDIT_LOG
CREATE TABLE audit_log (
    log_id              NUMBER PRIMARY KEY,
    table_name          VARCHAR2(50) NOT NULL,
    action_type         VARCHAR2(20) NOT NULL CHECK (action_type IN ('INSERT', 'UPDATE', 'DELETE')),
    record_id           VARCHAR2(50) NOT NULL,
    old_values          CLOB,
    new_values          CLOB,
    user_id             NUMBER,
    action_time         TIMESTAMP DEFAULT SYSTIMESTAMP,
    ip_address          VARCHAR2(50)
);

-- ============================================================
-- ADD FOREIGN KEY CONSTRAINTS
-- ============================================================
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicle_driver FOREIGN KEY (driver_id) REFERENCES drivers(driver_id);
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicle_type FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(vehicle_type_id);

ALTER TABLE rides ADD CONSTRAINT fk_ride_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
ALTER TABLE rides ADD CONSTRAINT fk_ride_driver FOREIGN KEY (driver_id) REFERENCES drivers(driver_id);
ALTER TABLE rides ADD CONSTRAINT fk_ride_pickup FOREIGN KEY (pickup_location_id) REFERENCES locations(location_id);
ALTER TABLE rides ADD CONSTRAINT fk_ride_dropoff FOREIGN KEY (dropoff_location_id) REFERENCES locations(location_id);
ALTER TABLE rides ADD CONSTRAINT fk_ride_vehicle_type FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(vehicle_type_id);

ALTER TABLE payments ADD CONSTRAINT fk_payment_ride FOREIGN KEY (ride_id) REFERENCES rides(ride_id);
ALTER TABLE payments ADD CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
ALTER TABLE payments ADD CONSTRAINT fk_payment_driver FOREIGN KEY (driver_id) REFERENCES drivers(driver_id);

ALTER TABLE reviews ADD CONSTRAINT fk_review_ride FOREIGN KEY (ride_id) REFERENCES rides(ride_id);
ALTER TABLE reviews ADD CONSTRAINT fk_review_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
ALTER TABLE reviews ADD CONSTRAINT fk_review_driver FOREIGN KEY (driver_id) REFERENCES drivers(driver_id);

ALTER TABLE driver_documents ADD CONSTRAINT fk_doc_driver FOREIGN KEY (driver_id) REFERENCES drivers(driver_id);
ALTER TABLE ride_events ADD CONSTRAINT fk_event_ride FOREIGN KEY (ride_id) REFERENCES rides(ride_id);
ALTER TABLE audit_log ADD CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(user_id);

-- ============================================================
-- CREATE INDEXES
-- ============================================================
CREATE INDEX idx_rides_customer ON rides(customer_id);
CREATE INDEX idx_rides_driver ON rides(driver_id);
CREATE INDEX idx_rides_status ON rides(status);
CREATE INDEX idx_rides_pickup ON rides(pickup_location_id);
CREATE INDEX idx_rides_request_time ON rides(request_time);
CREATE INDEX idx_payments_ride ON payments(ride_id);
CREATE INDEX idx_payments_customer ON payments(customer_id);
CREATE INDEX idx_reviews_ride ON reviews(ride_id);
CREATE INDEX idx_vehicles_driver ON vehicles(driver_id);
CREATE INDEX idx_vehicles_plate ON vehicles(plate_number);
CREATE INDEX idx_driver_documents_driver ON driver_documents(driver_id);
CREATE INDEX idx_ride_events_ride ON ride_events(ride_id);

-- ============================================================
-- VERIFICATION
-- ============================================================
SELECT table_name FROM user_tables ORDER BY table_name;

SELECT 'CUSTOMERS' AS Table_Name, COUNT(*) AS Row_Count FROM customers
UNION ALL
SELECT 'DRIVERS', COUNT(*) FROM drivers
UNION ALL
SELECT 'VEHICLES', COUNT(*) FROM vehicles
UNION ALL
SELECT 'VEHICLE_TYPES', COUNT(*) FROM vehicle_types
UNION ALL
SELECT 'RIDES', COUNT(*) FROM rides
UNION ALL
SELECT 'PAYMENTS', COUNT(*) FROM payments
UNION ALL
SELECT 'REVIEWS', COUNT(*) FROM reviews
UNION ALL
SELECT 'LOCATIONS', COUNT(*) FROM locations;

-- ============================================================
-- VERIFY ALL 13 TABLES
-- ============================================================
SELECT table_name FROM user_tables ORDER BY table_name;

-- Expected output should show all 13 tables:
-- AUDIT_LOG
-- CUSTOMERS
-- DRIVER_DOCUMENTS
-- DRIVERS
-- LOCATIONS
-- PAYMENTS
-- PROMOTIONS
-- REVIEWS
-- RIDE_EVENTS
-- RIDES
-- USERS
-- VEHICLE_TYPES
-- VEHICLES
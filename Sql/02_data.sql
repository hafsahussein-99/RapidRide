-- ============================================================
-- INSERT SAMPLE DATA (10+ rows per table)
-- ============================================================

SET DEFINE OFF;

-- 1. VEHICLE_TYPES (5 rows)
INSERT INTO vehicle_types VALUES (1, 'Economy', 2.00, 1.50, 4, 'Standard economic ride');
INSERT INTO vehicle_types VALUES (2, 'Premium', 3.50, 2.50, 4, 'Premium comfort ride');
INSERT INTO vehicle_types VALUES (3, 'SUV', 4.00, 3.00, 7, 'Spacious SUV for groups');
INSERT INTO vehicle_types VALUES (4, 'Minivan', 5.00, 3.50, 8, 'Large capacity minivan');
INSERT INTO vehicle_types VALUES (5, 'Luxury', 6.00, 4.50, 4, 'Luxury executive ride');

-- 2. LOCATIONS (12 rows)
INSERT INTO locations VALUES (1, 'Aden Adde International Airport', 'Mogadishu', 'KM4', 2.0144, 45.3046, 'Y');
INSERT INTO locations VALUES (2, 'Hamareweyne', 'Mogadishu', 'Hamareweyne', 2.0358, 45.3413, 'Y');
INSERT INTO locations VALUES (3, 'Shangani', 'Mogadishu', 'Shangani', 2.0392, 45.3341, 'Y');
INSERT INTO locations VALUES (4, 'Hargeisa Market', 'Mogadishu', 'Hodan', 2.0233, 45.3197, 'Y');
INSERT INTO locations VALUES (5, 'Kismayo Port', 'Kismayo', 'Port Area', -0.3585, 42.5453, 'N');
INSERT INTO locations VALUES (6, 'Mogadishu Stadium', 'Mogadishu', 'Yaqshid', 2.0537, 45.3416, 'Y');
INSERT INTO locations VALUES (7, 'Lido Beach', 'Mogadishu', 'Abdulaziz', 2.0116, 45.3549, 'Y');
INSERT INTO locations VALUES (8, 'Bakaara Market', 'Mogadishu', 'Hodan', 2.0295, 45.3251, 'Y');
INSERT INTO locations VALUES (9, 'Hotel Jazeera', 'Mogadishu', 'Hamareweyne', 2.0405, 45.3387, 'Y');
INSERT INTO locations VALUES (10, 'Mogadishu City Center', 'Mogadishu', 'KM4', 2.0185, 45.3098, 'Y');
INSERT INTO locations VALUES (11, 'Daruul Huda Mosque', 'Mogadishu', 'Yaqshid', 2.0489, 45.3452, 'N');
INSERT INTO locations VALUES (12, 'University of Somalia', 'Mogadishu', 'Hamareweyne', 2.0472, 45.3321, 'N');

-- 3. CUSTOMERS (12 rows)
INSERT INTO customers VALUES (seq_customer_id.NEXTVAL, 'Fatima Noor', '0612345699', 'fatima@email.com', 'Hamareweyne, Mogadishu', SYSDATE-30, 12, 156.40, 'ACTIVE');
INSERT INTO customers VALUES (seq_customer_id.NEXTVAL, 'Mohamed Ahmed', '0612345700', 'mohamed@email.com', 'Shangani, Mogadishu', SYSDATE-25, 8, 98.75, 'ACTIVE');
INSERT INTO customers VALUES (seq_customer_id.NEXTVAL, 'Leyla Hassan', '0612345701', 'leyla@email.com', 'KM4, Mogadishu', SYSDATE-20, 15, 210.30, 'ACTIVE');
INSERT INTO customers VALUES (seq_customer_id.NEXTVAL, 'Ali Yusuf', '0612345702', 'ali@email.com', 'Yaqshid, Mogadishu', SYSDATE-18, 5, 64.20, 'ACTIVE');
INSERT INTO customers VALUES (seq_customer_id.NEXTVAL, 'Amina Warsame', '0612345703', 'amina@email.com', 'Hodan, Mogadishu', SYSDATE-15, 20, 285.50, 'ACTIVE');
INSERT INTO customers VALUES (seq_customer_id.NEXTVAL, 'Omar Mohamed', '0612345704', 'omar@email.com', 'Abdulaziz, Mogadishu', SYSDATE-12, 3, 42.00, 'ACTIVE');
INSERT INTO customers VALUES (seq_customer_id.NEXTVAL, 'Safia Abdirahman', '0612345705', 'safia@email.com', 'Hamareweyne, Mogadishu', SYSDATE-10, 7, 89.90, 'ACTIVE');
INSERT INTO customers VALUES (seq_customer_id.NEXTVAL, 'Khadar Osman', '0612345706', 'khadar@email.com', 'Shangani, Mogadishu', SYSDATE-8, 4, 55.00, 'ACTIVE');
INSERT INTO customers VALUES (seq_customer_id.NEXTVAL, 'Nadia Haji', '0612345707', 'nadia@email.com', 'KM4, Mogadishu', SYSDATE-5, 11, 145.80, 'ACTIVE');
INSERT INTO customers VALUES (seq_customer_id.NEXTVAL, 'Abdirahman Isse', '0612345708', 'abdirahman@email.com', 'Yaqshid, Mogadishu', SYSDATE-3, 6, 78.50, 'ACTIVE');
INSERT INTO customers VALUES (seq_customer_id.NEXTVAL, 'Fartun Ali', '0612345709', 'fartun@email.com', 'Hodan, Mogadishu', SYSDATE-2, 2, 28.00, 'ACTIVE');
INSERT INTO customers VALUES (seq_customer_id.NEXTVAL, 'Ismail Hassan', '0612345710', 'ismail@email.com', 'Abdulaziz, Mogadishu', SYSDATE-1, 9, 112.40, 'ACTIVE');

-- 4. DRIVERS (12 rows)
INSERT INTO drivers VALUES (seq_driver_id.NEXTVAL, 'Ahmed Hassan', '0612346000', 'ahmed.driver@email.com', 'DL2024001', DATE '2025-12-31', SYSDATE-60, 4.8, 45, 1250.00, 'ACTIVE');
INSERT INTO drivers VALUES (seq_driver_id.NEXTVAL, 'Amina Ali', '0612346001', 'amina.driver@email.com', 'DL2024002', DATE '2025-11-30', SYSDATE-55, 4.9, 38, 985.50, 'ACTIVE');
INSERT INTO drivers VALUES (seq_driver_id.NEXTVAL, 'Hassan Mohamed', '0612346002', 'hassan.driver@email.com', 'DL2024003', DATE '2026-01-31', SYSDATE-50, 4.7, 52, 1420.00, 'ACTIVE');
INSERT INTO drivers VALUES (seq_driver_id.NEXTVAL, 'Muna Ibrahim', '0612346003', 'muna.driver@email.com', 'DL2024004', DATE '2025-10-31', SYSDATE-45, 4.6, 30, 780.00, 'ACTIVE');
INSERT INTO drivers VALUES (seq_driver_id.NEXTVAL, 'Abdullahi Jimale', '0612346004', 'abdullahi.driver@email.com', 'DL2024005', DATE '2026-02-28', SYSDATE-40, 4.5, 22, 560.00, 'ACTIVE');
INSERT INTO drivers VALUES (seq_driver_id.NEXTVAL, 'Safia Omar', '0612346005', 'safia.driver@email.com', 'DL2024006', DATE '2025-09-30', SYSDATE-35, 4.9, 60, 1650.00, 'ACTIVE');
INSERT INTO drivers VALUES (seq_driver_id.NEXTVAL, 'Mohamed Abdi', '0612346006', 'mohamed.driver@email.com', 'DL2024007', DATE '2026-03-31', SYSDATE-30, 4.4, 18, 460.00, 'ON_LEAVE');
INSERT INTO drivers VALUES (seq_driver_id.NEXTVAL, 'Khadija Noor', '0612346007', 'khadija.driver@email.com', 'DL2024008', DATE '2025-12-31', SYSDATE-25, 4.8, 33, 870.00, 'ACTIVE');
INSERT INTO drivers VALUES (seq_driver_id.NEXTVAL, 'Omar Diriye', '0612346008', 'omar.driver@email.com', 'DL2024009', DATE '2026-04-30', SYSDATE-20, 4.3, 15, 390.00, 'SUSPENDED');
INSERT INTO drivers VALUES (seq_driver_id.NEXTVAL, 'Asha Ismail', '0612346009', 'asha.driver@email.com', 'DL2024010', DATE '2025-08-31', SYSDATE-15, 4.7, 28, 720.00, 'ACTIVE');
INSERT INTO drivers VALUES (seq_driver_id.NEXTVAL, 'Yusuf Ali', '0612346010', 'yusuf.driver@email.com', 'DL2024011', DATE '2026-05-31', SYSDATE-10, 4.6, 25, 650.00, 'ACTIVE');
INSERT INTO drivers VALUES (seq_driver_id.NEXTVAL, 'Halima Aden', '0612346011', 'halima.driver@email.com', 'DL2024012', DATE '2025-07-31', SYSDATE-5, 4.9, 42, 1120.00, 'ACTIVE');

-- 5. VEHICLES (12 rows)
INSERT INTO vehicles VALUES (seq_vehicle_id.NEXTVAL, 500, 1, 'AB1234', 'Corolla', 'Toyota', 2020, 'White', 'AVAILABLE');
INSERT INTO vehicles VALUES (seq_vehicle_id.NEXTVAL, 501, 1, 'AB1235', 'Civic', 'Honda', 2021, 'Silver', 'AVAILABLE');
INSERT INTO vehicles VALUES (seq_vehicle_id.NEXTVAL, 502, 2, 'AB1236', 'Camry', 'Toyota', 2022, 'Black', 'AVAILABLE');
INSERT INTO vehicles VALUES (seq_vehicle_id.NEXTVAL, 503, 1, 'AB1237', 'Accent', 'Hyundai', 2020, 'Blue', 'AVAILABLE');
INSERT INTO vehicles VALUES (seq_vehicle_id.NEXTVAL, 504, 3, 'AB1238', 'CR-V', 'Honda', 2021, 'Red', 'AVAILABLE');
INSERT INTO vehicles VALUES (seq_vehicle_id.NEXTVAL, 505, 4, 'AB1239', 'Odyssey', 'Honda', 2022, 'Silver', 'AVAILABLE');
INSERT INTO vehicles VALUES (seq_vehicle_id.NEXTVAL, 506, 1, 'AB1240', 'Elantra', 'Hyundai', 2020, 'White', 'MAINTENANCE');
INSERT INTO vehicles VALUES (seq_vehicle_id.NEXTVAL, 507, 2, 'AB1241', 'Passat', 'Volkswagen', 2021, 'Black', 'AVAILABLE');
INSERT INTO vehicles VALUES (seq_vehicle_id.NEXTVAL, 508, 5, 'AB1242', 'LS 500', 'Lexus', 2022, 'White', 'AVAILABLE');
INSERT INTO vehicles VALUES (seq_vehicle_id.NEXTVAL, 509, 1, 'AB1243', 'Sentra', 'Nissan', 2020, 'Gray', 'AVAILABLE');
INSERT INTO vehicles VALUES (seq_vehicle_id.NEXTVAL, 510, 3, 'AB1244', 'Explorer', 'Ford', 2021, 'Blue', 'AVAILABLE');
INSERT INTO vehicles VALUES (seq_vehicle_id.NEXTVAL, 511, 2, 'AB1245', 'X3', 'BMW', 2022, 'Silver', 'AVAILABLE');

-- 6. PROMOTIONS (7 rows)
INSERT INTO promotions VALUES (1, 'WELCOME10', 'Welcome discount for new users', 10.00, NULL, 5.00, DATE '2026-01-01', DATE '2026-12-31', 100, 0, 'ACTIVE');
INSERT INTO promotions VALUES (2, 'SUMMER20', 'Summer special discount', 20.00, NULL, 10.00, DATE '2026-06-01', DATE '2026-08-31', 50, 0, 'ACTIVE');
INSERT INTO promotions VALUES (3, 'FIVE5', '5% off on all rides', 5.00, NULL, 3.00, DATE '2026-01-01', DATE '2026-12-31', 1000, 0, 'ACTIVE');
INSERT INTO promotions VALUES (4, 'FREEWEEKEND', 'Free weekend ride', NULL, 10.00, 10.00, DATE '2026-06-01', DATE '2026-06-30', 10, 0, 'ACTIVE');
INSERT INTO promotions VALUES (5, 'EXECUTIVE', 'Executive class discount', 15.00, NULL, 15.00, DATE '2026-01-01', DATE '2026-12-31', 30, 0, 'ACTIVE');
INSERT INTO promotions VALUES (6, 'HALFPRICE', '50% off on first ride', 50.00, NULL, 8.00, DATE '2026-01-01', DATE '2026-12-31', 20, 0, 'ACTIVE');
INSERT INTO promotions VALUES (7, 'GROUP20', 'Group discount 20%', 20.00, NULL, 12.00, DATE '2026-07-01', DATE '2026-09-30', 25, 0, 'EXPIRED');

-- 7. RIDES (20 rows)
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1000, 500, 1, 2, 1, 5.5, 10.25, 12.50, 'COMPLETED', SYSTIMESTAMP - INTERVAL '2' DAY, SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '15' MINUTE, SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '45' MINUTE, NULL, 'Airport pickup');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1001, 501, 3, 4, 1, 7.2, 12.80, 16.90, 'COMPLETED', SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '1' HOUR, SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '1' HOUR + INTERVAL '20' MINUTE, SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '2' HOUR, NULL, 'Market visit');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1002, 502, 5, 6, 3, 15.0, 45.00, 48.50, 'COMPLETED', SYSTIMESTAMP - INTERVAL '1' DAY, SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '30' MINUTE, SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '1' HOUR, NULL, 'Airport transfer');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1003, 503, 7, 8, 1, 4.2, 8.30, 9.00, 'COMPLETED', SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '2' HOUR, SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '2' HOUR + INTERVAL '10' MINUTE, SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '3' HOUR, NULL, 'Beach trip');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1004, 504, 2, 1, 2, 8.5, 17.75, 20.50, 'COMPLETED', SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '5' HOUR, SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '5' HOUR + INTERVAL '25' MINUTE, SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '6' HOUR, NULL, 'Airport drop');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1005, 505, 9, 10, 1, 3.8, 7.70, 8.50, 'COMPLETED', SYSTIMESTAMP - INTERVAL '12' HOUR, SYSTIMESTAMP - INTERVAL '12' HOUR + INTERVAL '10' MINUTE, SYSTIMESTAMP - INTERVAL '12' HOUR + INTERVAL '30' MINUTE, NULL, 'Hotel to city');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1006, 506, 6, 7, 4, 4.5, 10.75, 12.00, 'COMPLETED', SYSTIMESTAMP - INTERVAL '10' HOUR, SYSTIMESTAMP - INTERVAL '10' HOUR + INTERVAL '15' MINUTE, SYSTIMESTAMP - INTERVAL '10' HOUR + INTERVAL '45' MINUTE, NULL, 'Group ride');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1007, 507, 11, 12, 2, 6.0, 13.50, 14.75, 'COMPLETED', SYSTIMESTAMP - INTERVAL '8' HOUR, SYSTIMESTAMP - INTERVAL '8' HOUR + INTERVAL '20' MINUTE, SYSTIMESTAMP - INTERVAL '8' HOUR + INTERVAL '50' MINUTE, NULL, 'University trip');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1008, 508, 4, 2, 5, 3.2, 15.40, 17.00, 'COMPLETED', SYSTIMESTAMP - INTERVAL '6' HOUR, SYSTIMESTAMP - INTERVAL '6' HOUR + INTERVAL '10' MINUTE, SYSTIMESTAMP - INTERVAL '6' HOUR + INTERVAL '25' MINUTE, NULL, 'Luxury ride');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1009, 509, 8, 9, 1, 5.0, 9.50, 10.50, 'COMPLETED', SYSTIMESTAMP - INTERVAL '4' HOUR, SYSTIMESTAMP - INTERVAL '4' HOUR + INTERVAL '15' MINUTE, SYSTIMESTAMP - INTERVAL '4' HOUR + INTERVAL '40' MINUTE, NULL, 'Market to hotel');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1010, 510, 1, 5, 3, 12.5, 37.50, 40.00, 'COMPLETED', SYSTIMESTAMP - INTERVAL '3' HOUR, SYSTIMESTAMP - INTERVAL '3' HOUR + INTERVAL '35' MINUTE, SYSTIMESTAMP - INTERVAL '3' HOUR + INTERVAL '1' HOUR, NULL, 'Long distance');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1011, 511, 3, 6, 1, 6.8, 12.20, 13.80, 'IN_PROGRESS', SYSTIMESTAMP - INTERVAL '1' HOUR, SYSTIMESTAMP - INTERVAL '1' HOUR + INTERVAL '20' MINUTE, NULL, NULL, 'Ongoing ride');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1000, NULL, 2, 4, 2, 4.5, 9.75, NULL, 'REQUESTED', SYSTIMESTAMP - INTERVAL '30' MINUTE, NULL, NULL, NULL, 'Waiting for driver');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1001, 500, 5, 7, 1, 14.0, 21.00, NULL, 'ACCEPTED', SYSTIMESTAMP - INTERVAL '20' MINUTE, NULL, NULL, NULL, 'Driver assigned');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1010, NULL, 10, 11, 1, 3.5, 7.25, NULL, 'REQUESTED', SYSTIMESTAMP - INTERVAL '10' MINUTE, NULL, NULL, NULL, 'New request');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1004, NULL, 12, 8, 3, 8.2, 18.40, NULL, 'CANCELLED', SYSTIMESTAMP - INTERVAL '45' MINUTE, NULL, NULL, 'Customer changed mind', 'Cancelled by customer');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1005, 511, 6, 4, 4, 5.5, 14.25, NULL, 'ACCEPTED', SYSTIMESTAMP - INTERVAL '15' MINUTE, NULL, NULL, NULL, 'Minivan assigned');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1006, NULL, 1, 9, 1, 7.0, 12.50, NULL, 'REQUESTED', SYSTIMESTAMP - INTERVAL '5' MINUTE, NULL, NULL, NULL, 'Airport pickup request');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1002, 503, 3, 5, 2, 9.5, 20.75, NULL, 'ACCEPTED', SYSTIMESTAMP - INTERVAL '25' MINUTE, NULL, NULL, NULL, 'Premium ride accepted');
INSERT INTO rides VALUES (seq_ride_id.NEXTVAL, 1008, NULL, 7, 10, 1, 4.0, 8.00, NULL, 'REQUESTED', SYSTIMESTAMP - INTERVAL '2' MINUTE, NULL, NULL, NULL, 'Quick request');

-- 8. PAYMENTS (11 rows)
INSERT INTO payments VALUES (seq_payment_id.NEXTVAL, 2000, 1000, 500, 12.50, 'CASH', 'COMPLETED', SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '45' MINUTE, 'CASH-001', 'Paid in cash');
INSERT INTO payments VALUES (seq_payment_id.NEXTVAL, 2001, 1001, 501, 16.90, 'CARD', 'COMPLETED', SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '2' HOUR, 'CARD-002', 'Credit card payment');
INSERT INTO payments VALUES (seq_payment_id.NEXTVAL, 2002, 1002, 502, 48.50, 'MOBILE_MONEY', 'COMPLETED', SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '1' HOUR, 'MOMO-003', 'Mobile money transfer');
INSERT INTO payments VALUES (seq_payment_id.NEXTVAL, 2003, 1003, 503, 9.00, 'CASH', 'COMPLETED', SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '3' HOUR, 'CASH-004', 'Cash payment');
INSERT INTO payments VALUES (seq_payment_id.NEXTVAL, 2004, 1004, 504, 20.50, 'CARD', 'COMPLETED', SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '6' HOUR, 'CARD-005', 'Visa payment');
INSERT INTO payments VALUES (seq_payment_id.NEXTVAL, 2005, 1005, 505, 8.50, 'MOBILE_MONEY', 'COMPLETED', SYSTIMESTAMP - INTERVAL '12' HOUR + INTERVAL '30' MINUTE, 'MOMO-006', 'Mobile payment');
INSERT INTO payments VALUES (seq_payment_id.NEXTVAL, 2006, 1006, 506, 12.00, 'CASH', 'COMPLETED', SYSTIMESTAMP - INTERVAL '10' HOUR + INTERVAL '45' MINUTE, 'CASH-007', 'Cash');
INSERT INTO payments VALUES (seq_payment_id.NEXTVAL, 2007, 1007, 507, 14.75, 'CARD', 'COMPLETED', SYSTIMESTAMP - INTERVAL '8' HOUR + INTERVAL '50' MINUTE, 'CARD-008', 'Card payment');
INSERT INTO payments VALUES (seq_payment_id.NEXTVAL, 2008, 1008, 508, 17.00, 'ONLINE', 'COMPLETED', SYSTIMESTAMP - INTERVAL '6' HOUR + INTERVAL '25' MINUTE, 'ON-009', 'Online payment');
INSERT INTO payments VALUES (seq_payment_id.NEXTVAL, 2009, 1009, 509, 10.50, 'CASH', 'COMPLETED', SYSTIMESTAMP - INTERVAL '4' HOUR + INTERVAL '40' MINUTE, 'CASH-010', 'Cash');
INSERT INTO payments VALUES (seq_payment_id.NEXTVAL, 2010, 1010, 510, 40.00, 'MOBILE_MONEY', 'COMPLETED', SYSTIMESTAMP - INTERVAL '3' HOUR + INTERVAL '1' HOUR, 'MOMO-011', 'Mobile money');

-- 9. REVIEWS (11 rows)
INSERT INTO reviews VALUES (seq_review_id.NEXTVAL, 2000, 1000, 500, 4.5, 'Great ride, driver was professional!', SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '1' HOUR, 'Y');
INSERT INTO reviews VALUES (seq_review_id.NEXTVAL, 2001, 1001, 501, 5.0, 'Excellent service, very punctual', SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '3' HOUR, 'Y');
INSERT INTO reviews VALUES (seq_review_id.NEXTVAL, 2002, 1002, 502, 4.0, 'Good ride, a bit expensive', SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '2' HOUR, 'Y');
INSERT INTO reviews VALUES (seq_review_id.NEXTVAL, 2003, 1003, 503, 4.8, 'Very comfortable, highly recommend', SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '4' HOUR, 'Y');
INSERT INTO reviews VALUES (seq_review_id.NEXTVAL, 2004, 1004, 504, 4.2, 'Good driver, clean car', SYSTIMESTAMP - INTERVAL '1' DAY + INTERVAL '7' HOUR, 'Y');
INSERT INTO reviews VALUES (seq_review_id.NEXTVAL, 2005, 1005, 505, 5.0, 'Amazing experience! Will use again', SYSTIMESTAMP - INTERVAL '12' HOUR + INTERVAL '1' HOUR, 'Y');
INSERT INTO reviews VALUES (seq_review_id.NEXTVAL, 2006, 1006, 506, 3.5, 'Driver was late but ride was good', SYSTIMESTAMP - INTERVAL '10' HOUR + INTERVAL '1' HOUR, 'Y');
INSERT INTO reviews VALUES (seq_review_id.NEXTVAL, 2007, 1007, 507, 4.5, 'Very friendly driver, safe driving', SYSTIMESTAMP - INTERVAL '8' HOUR + INTERVAL '1' HOUR, 'Y');
INSERT INTO reviews VALUES (seq_review_id.NEXTVAL, 2008, 1008, 508, 5.0, 'Luxury ride, felt like VIP!', SYSTIMESTAMP - INTERVAL '6' HOUR + INTERVAL '30' MINUTE, 'Y');
INSERT INTO reviews VALUES (seq_review_id.NEXTVAL, 2009, 1009, 509, 4.0, 'Good value for money', SYSTIMESTAMP - INTERVAL '4' HOUR + INTERVAL '1' HOUR, 'Y');
INSERT INTO reviews VALUES (seq_review_id.NEXTVAL, 2010, 1010, 510, 4.7, 'Excellent long-distance ride', SYSTIMESTAMP - INTERVAL '3' HOUR + INTERVAL '1' HOUR, 'Y');


-- 10. USERS (5 rows)
INSERT INTO users VALUES (1, 'admin', 'admin_hash_123', 'System Admin', 'admin@rapidride.com', 'ADMIN', SYSTIMESTAMP, 'ACTIVE', SYSDATE);
INSERT INTO users VALUES (2, 'manager1', 'mgr_hash_123', 'Hassan Manager', 'hassan@rapidride.com', 'MANAGER', SYSTIMESTAMP - INTERVAL '1' DAY, 'ACTIVE', SYSDATE-30);
INSERT INTO users VALUES (3, 'driver500', 'drv_hash_123', 'Ahmed Driver', 'ahmed@rapidride.com', 'DRIVER', SYSTIMESTAMP - INTERVAL '2' DAY, 'ACTIVE', SYSDATE-60);
INSERT INTO users VALUES (4, 'customer1000', 'cust_hash_123', 'Fatima Customer', 'fatima@email.com', 'CUSTOMER', SYSTIMESTAMP - INTERVAL '1' HOUR, 'ACTIVE', SYSDATE-30);
INSERT INTO users VALUES (5, 'manager2', 'mgr_hash_456', 'Amina Manager', 'amina@rapidride.com', 'MANAGER', SYSTIMESTAMP - INTERVAL '12' HOUR, 'ACTIVE', SYSDATE-20);

-- 11. DRIVER_DOCUMENTS (12 rows)
INSERT INTO driver_documents VALUES (1, 500, 'LICENSE', 'DL2024001A', DATE '2024-01-01', DATE '2025-12-31', 'VALID', 'docs/license_500.pdf', SYSDATE-60);
INSERT INTO driver_documents VALUES (2, 500, 'INSURANCE', 'INS500A', DATE '2024-06-01', DATE '2025-05-31', 'VALID', 'docs/insurance_500.pdf', SYSDATE-60);
INSERT INTO driver_documents VALUES (3, 501, 'LICENSE', 'DL2024002A', DATE '2024-01-01', DATE '2025-11-30', 'VALID', 'docs/license_501.pdf', SYSDATE-55);
INSERT INTO driver_documents VALUES (4, 501, 'VEHICLE_REG', 'REG501A', DATE '2024-03-15', DATE '2025-03-14', 'VALID', 'docs/reg_501.pdf', SYSDATE-55);
INSERT INTO driver_documents VALUES (5, 502, 'LICENSE', 'DL2024003A', DATE '2024-01-15', DATE '2026-01-31', 'VALID', 'docs/license_502.pdf', SYSDATE-50);
INSERT INTO driver_documents VALUES (6, 503, 'LICENSE', 'DL2024004A', DATE '2024-02-01', DATE '2025-10-31', 'VALID', 'docs/license_503.pdf', SYSDATE-45);
INSERT INTO driver_documents VALUES (7, 504, 'LICENSE', 'DL2024005A', DATE '2024-02-15', DATE '2026-02-28', 'VALID', 'docs/license_504.pdf', SYSDATE-40);
INSERT INTO driver_documents VALUES (8, 505, 'LICENSE', 'DL2024006A', DATE '2024-03-01', DATE '2025-09-30', 'VALID', 'docs/license_505.pdf', SYSDATE-35);
INSERT INTO driver_documents VALUES (9, 506, 'INSURANCE', 'INS506A', DATE '2024-04-01', DATE '2025-03-31', 'EXPIRED', 'docs/insurance_506.pdf', SYSDATE-30);
INSERT INTO driver_documents VALUES (10, 507, 'LICENSE', 'DL2024008A', DATE '2024-03-15', DATE '2025-12-31', 'VALID', 'docs/license_507.pdf', SYSDATE-25);
INSERT INTO driver_documents VALUES (11, 508, 'LICENSE', 'DL2024009A', DATE '2024-04-01', DATE '2026-04-30', 'VALID', 'docs/license_508.pdf', SYSDATE-20);
INSERT INTO driver_documents VALUES (12, 509, 'VEHICLE_REG', 'REG509A', DATE '2024-05-01', DATE '2025-04-30', 'VALID', 'docs/reg_509.pdf', SYSDATE-15);

-- 12. RIDE_EVENTS (7 rows)
INSERT INTO ride_events VALUES (1, 2000, 'CREATED', SYSTIMESTAMP - INTERVAL '2' DAY, NULL, 'REQUESTED', 'Ride requested by customer');
INSERT INTO ride_events VALUES (2, 2000, 'ACCEPTED', SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '5' MINUTE, 'REQUESTED', 'ACCEPTED', 'Driver accepted the ride');
INSERT INTO ride_events VALUES (3, 2000, 'STARTED', SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '15' MINUTE, 'ACCEPTED', 'IN_PROGRESS', 'Driver started the trip');
INSERT INTO ride_events VALUES (4, 2000, 'COMPLETED', SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '45' MINUTE, 'IN_PROGRESS', 'COMPLETED', 'Ride completed successfully');
INSERT INTO ride_events VALUES (5, 2001, 'CREATED', SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '1' HOUR, NULL, 'REQUESTED', 'Ride requested');
INSERT INTO ride_events VALUES (6, 2001, 'COMPLETED', SYSTIMESTAMP - INTERVAL '2' DAY + INTERVAL '2' HOUR, 'IN_PROGRESS', 'COMPLETED', 'Ride completed');
INSERT INTO ride_events VALUES (7, 2016, 'CANCELLED', SYSTIMESTAMP - INTERVAL '45' MINUTE, 'REQUESTED', 'CANCELLED', 'Customer cancelled the ride');

-- 13. AUDIT_LOG (3 rows)
INSERT INTO audit_log VALUES (1, 'CUSTOMERS', 'INSERT', '1000', NULL, '{"full_name":"Fatima Noor","phone":"0612345699"}', 1, SYSTIMESTAMP - INTERVAL '30' DAY, '192.168.1.1');
INSERT INTO audit_log VALUES (2, 'DRIVERS', 'INSERT', '500', NULL, '{"full_name":"Ahmed Hassan","license":"DL2024001"}', 1, SYSTIMESTAMP - INTERVAL '60' DAY, '192.168.1.1');
INSERT INTO audit_log VALUES (3, 'RIDES', 'UPDATE', '2000', '{"status":"REQUESTED"}', '{"status":"COMPLETED"}', 1, SYSTIMESTAMP - INTERVAL '2' DAY, '192.168.1.1');

PROMPT =========================================
PROMPT SAMPLE DATA INSERTED SUCCESSFULLY!
PROMPT =========================================
COMMIT;
/
-- ============================================================
-- VERIFY DATA COUNTS (FIXED)
-- ============================================================
SELECT 'CUSTOMERS' AS "Table_Name", COUNT(*) AS "Row_Count" FROM customers
UNION ALL
SELECT 'DRIVERS' AS "Table_Name", COUNT(*) FROM drivers
UNION ALL
SELECT 'VEHICLES' AS "Table_Name", COUNT(*) FROM vehicles
UNION ALL
SELECT 'VEHICLE_TYPES' AS "Table_Name", COUNT(*) FROM vehicle_types
UNION ALL
SELECT 'RIDES' AS "Table_Name", COUNT(*) FROM rides
UNION ALL
SELECT 'PAYMENTS' AS "Table_Name", COUNT(*) FROM payments
UNION ALL
SELECT 'REVIEWS' AS "Table_Name", COUNT(*) FROM reviews
UNION ALL
SELECT 'LOCATIONS' AS "Table_Name", COUNT(*) FROM locations
UNION ALL
SELECT 'PROMOTIONS' AS "Table_Name", COUNT(*) FROM promotions
UNION ALL
SELECT 'DRIVER_DOCUMENTS' AS "Table_Name", COUNT(*) FROM driver_documents
UNION ALL
SELECT 'RIDE_EVENTS' AS "Table_Name", COUNT(*) FROM ride_events
UNION ALL
SELECT 'USERS' AS "Table_Name", COUNT(*) FROM users
UNION ALL
SELECT 'AUDIT_LOG' AS "Table_Name", COUNT(*) FROM audit_log
ORDER BY "Table_Name";
-- -------------------------------------------------------------
-- TablePlus 5.6.2(516)
--
-- https://tableplus.com/
--
-- Database: ecommerce
-- Generation Time: 2023-11-29 01:56:44.8160
-- -------------------------------------------------------------

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS distribution_centers_id_seq;

-- Table Definition
CREATE TABLE "public"."distribution_centers" (
    "id" int4 NOT NULL DEFAULT nextval('distribution_centers_id_seq'::regclass),
    "dc_code" varchar(6),
    "district" varchar(200),
    "manager_id" varchar(10),
    "created_at" timestamptz DEFAULT CURRENT_TIMESTAMP,
    "last_updated_at" timestamptz,
    "shipping_fee" float8,
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Table Definition
CREATE TABLE "public"."entity" (
    "entity_id" varchar(10) NOT NULL,
    "country_code" varchar(2),
    "region" varchar(10),
    "is_franchise" bool,
    PRIMARY KEY ("entity_id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Table Definition
CREATE TABLE "public"."payment_fees" (
    "payment_method" varchar(50) NOT NULL,
    "fee" numeric(10,2) NOT NULL,
    PRIMARY KEY ("payment_method")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Table Definition
CREATE TABLE "public"."warehouse_employees" (
    "employee_id" varchar(10) NOT NULL,
    "employee_last_name" varchar(200),
    "employee_first_name" varchar(200),
    PRIMARY KEY ("employee_id")
);

INSERT INTO "public"."distribution_centers" ("id", "dc_code", "district", "manager_id", "created_at", "last_updated_at", "shipping_fee") VALUES
(1, 'SG_DC1', 'Jurong East', 'EX_002', '2023-11-28 17:14:08.77055+00', NULL, 1),
(2, 'SG_DC2', 'Serangoon', 'EX_042', '2023-11-28 17:14:08.77055+00', NULL, 0.5),
(3, 'SG_DC3', 'Potong Pasir', 'EX_115', '2023-11-28 17:14:08.77055+00', NULL, 0.5),
(4, 'MY_DC1', 'Subang Jaya', 'EX_120', '2023-11-28 17:14:08.77055+00', NULL, 0.2),
(5, 'MY_DC2', 'Ipoh', 'EX_109', '2023-11-28 17:14:08.77055+00', NULL, 0.25),
(6, 'PH_DC1', 'Greater Manila', 'EX_140', '2023-11-28 17:14:08.77055+00', NULL, 0.2),
(7, 'PH_DC2', 'Davao', 'EX_170', '2023-11-28 17:14:08.77055+00', NULL, 0.5),
(8, 'TH_DC1', 'Bangkok Metropolitian Area', 'EX_140', '2023-11-28 17:14:08.77055+00', NULL, 0.2),
(9, 'VN_DC1', 'Central Vietnam', 'EX_051', '2023-11-28 17:14:08.77055+00', NULL, 0.5),
(10, 'HK_DC1', 'New Territories', 'EX_217', '2023-11-28 17:14:08.77055+00', NULL, 1),
(11, 'HK_DC2', 'Kowloon', 'EX_217', '2023-11-28 17:14:08.77055+00', NULL, 0.5);

INSERT INTO "public"."entity" ("entity_id", "country_code", "region", "is_franchise") VALUES
('ACME_MY', 'MY', 'SEA', 'f'),
('ACME_PH', 'PH', 'SEA', 'f'),
('ACME_SG', 'SG', 'SEA', 'f'),
('MQLO_HK', 'HK', 'HKCN', 'f'),
('POCO_TH', 'TH', 'SEA', 't'),
('POCO_VN', 'VN', 'SEA', 't');

INSERT INTO "public"."payment_fees" ("payment_method", "fee") VALUES
('ALIPAY', 0.03),
('APPLEPAY', 0.01),
('ATOME', 0.01),
('CASH_ON_DELIVERY', 0.00),
('CREDIT_CARD', 0.05),
('GOOGLE_PAY', 0.02),
('PAYPAL', 0.02);

INSERT INTO "public"."warehouse_employees" ("employee_id", "employee_last_name", "employee_first_name") VALUES
('EX_002', 'Johnson', 'Emma'),
('EX_006', 'Davis', 'Michael'),
('EX_016', 'Martin', 'David'),
('EX_020', 'Turner', 'Jacob'),
('EX_042', 'Brown', 'William'),
('EX_051', 'Jones', 'Sophia'),
('EX_102', 'Anderson', 'Alexander'),
('EX_109', 'Martinez', 'Isabella'),
('EX_111', 'Robinson', 'Sophia'),
('EX_115', 'Moore', 'Emily'),
('EX_118', 'Lee', 'Ethan'),
('EX_120', 'Clark', 'Benjamin'),
('EX_129', 'Hall', 'Chloe'),
('EX_131', 'Thomas', 'Mia'),
('EX_140', 'Hernandez', 'Daniel'),
('EX_170', 'Miller', 'Ava'),
('EX_217', 'White', 'Charlotte'),
('EX_288', 'Garcia', 'James'),
('EX_321', 'Williams', 'Olivia');


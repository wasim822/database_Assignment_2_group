DECLARE k_customer CONSTANT gggs_data_upload.data_type % TYPE := 'CU';

k_vendor CONSTANT gggs_data_upload.data_type % TYPE := 'VE';

k_category CONSTANT gggs_data_upload.data_type % TYPE := 'CA';

k_stock CONSTANT gggs_data_upload.data_type % TYPE := 'ST';

k_new CONSTANT gggs_data_upload.process_type % TYPE := 'N';

k_status CONSTANT gggs_data_upload.process_type % TYPE := 'S';

k_change CONSTANT gggs_data_upload.process_type % TYPE := 'C';

k_active_status CONSTANT gggs_customer.status % TYPE := 'A';

k_data_processed CONSTANT gggs_data_upload.data_processed % TYPE := 'Y';

k_data_unprocessed CONSTANT gggs_data_upload.data_processed % TYPE := 'N';

k_no_change_char CONSTANT CHAR(2) := 'NC';

k_no_change_numb CONSTANT NUMBER := -1;

v_name1 gggs_category.categoryID % TYPE;

v_name2 gggs_vendor.vendorID % TYPE;

v_message gggs_error_log_table.error_message % TYPE;

CURSOR c_gggs IS
SELECT
  *
FROM
  gggs_data_upload
ORDER BY
  loadID;

BEGIN FOR r_gggs IN c_gggs
LOOP
BEGIN
------------------------------------------wasim-------------------
IF (r_gggs.data_type = k_customer) THEN IF (r_gggs.process_type = k_new) THEN
INSERT INTO
  gggs_customer (
    CUSTOMERID,
    NAME,
    PROVINCE,
    FIRST_NAME,
    LAST_NAME,
    CITY,
    PHONE_NUMBER,
    STATUS
  )
VALUES
  (
    gggs_customer_seq.NEXTVAL,
    r_gggs.column1,
    r_gggs.column2,
    r_gggs.column3,
    r_gggs.column4,
    r_gggs.column5,
    r_gggs.column6,
    k_active_status
  );

ELSIF (r_gggs.process_type = k_status) THEN
UPDATE gggs_customer
SET
  status = r_gggs.column2
WHERE
  name = r_gggs.column1;

ELSIF (r_gggs.process_type = k_change) THEN
UPDATE gggs_customer gc
SET
  province = CASE
    WHEN r_gggs.column2 IS NULL
    OR r_gggs.column2 = k_no_change_char THEN gc.province
    ELSE r_gggs.column2
  END,
  first_name = CASE
    WHEN r_gggs.column3 IS NULL
    OR r_gggs.column3 = k_no_change_char THEN gc.first_name
    ELSE r_gggs.column3
  END,
  last_name = CASE
    WHEN r_gggs.column4 IS NULL
    OR r_gggs.column4 = k_no_change_char THEN gc.last_name
    ELSE r_gggs.column4
  END,
  city = CASE
    WHEN r_gggs.column5 IS NULL
    OR r_gggs.column5 = k_no_change_char THEN gc.city
    ELSE r_gggs.column5
  END,
  phone_number = CASE
    WHEN r_gggs.column6 IS NULL
    OR r_gggs.column6 = k_no_change_char THEN gc.phone_number
    ELSE r_gggs.column6
  END
WHERE
  gc.name = r_gggs.column1;

ELSE RAISE_APPLICATION_ERROR (
  -20001,
  r_gggs.process_type || ' is not a valid process request for ' || r_gggs.data_type || ' data'
);

END IF;

------------------------------------------wasim---------------------
------------------------------Aiden------------------------------
ELSIF (r_gggs.data_type = k_vendor) THEN IF (r_gggs.process_type = k_new) THEN
INSERT INTO
  gggs_vendor
VALUES
  (
    gggs_vendor_seq.NEXTVAL,
    r_gggs.column1,
    r_gggs.column2,
    r_gggs.column3,
    r_gggs.column4,
    r_gggs.column6,
    k_status
  );

ELSIF (r_gggs.process_type = k_status) THEN
UPDATE gggs_vendor
SET
  status = r_gggs.column2
WHERE
  name = r_gggs.column1;

ELSIF (r_gggs.process_type = k_change) THEN
UPDATE gggs_vendor
SET
  description = DECODE(
    r_gggs.column2,
    k_no_change_char,
    description,
    r_gggs.column2
  ),
  contact_first_name = DECODE(
    r_gggs.column3,
    k_no_change_char,
    contact_first_name,
    r_gggs.column3
  ),
  contact_last_name = DECODE(
    r_gggs.column4,
    k_no_change_char,
    contact_last_name,
    r_gggs.column4
  ),
  contact_phone_number = NVL2(
    r_gggs.column6,
    r_gggs.column6,
    contact_phone_number
  )
WHERE
  name = r_gggs.column1;

ELSE RAISE_APPLICATION_ERROR (
  -20001,
  r_gggs.process_type || ' is not a valid process request for ' || r_gggs.data_type || ' data'
);

END IF;

------------------------------Aiden------------------------------
------------------------------Sehajbir------------------------------
ELSIF (r_gggs.data_type = k_category) THEN IF (r_gggs.process_type = k_new) THEN
INSERT INTO
  gggs_category (CATEGORYID, NAME, DESCRIPTION, STATUS)
VALUES
  (
    gggs_category_seq.NEXTVAL,
    r_gggs.column1,
    r_gggs.column2,
    k_active_status
  );

ELSIF (r_gggs.process_type = k_status) THEN
UPDATE gggs_category
SET
  status = r_gggs.column2
WHERE
  name = r_gggs.column1;

ELSIF (r_gggs.process_type = k_change) THEN
UPDATE gggs_category
SET
  description = DECODE(
    r_gggs.column2,
    k_no_change_char,
    description,
    r_gggs.column2
  )
WHERE
  name = r_gggs.column1;

ELSE RAISE_APPLICATION_ERROR (
  -20001,
  r_gggs.process_type || ' is not a valid process request for ' || r_gggs.data_type || ' data'
);

END IF;

------------------------------Sehajbir------------------------------
------------------------------Nick------------------------------
ELSIF (r_gggs.data_type = k_stock) THEN IF (r_gggs.process_type = k_new) THEN
SELECT
  categoryID INTO v_name1
FROM
  gggs_category
WHERE
  name = r_gggs.column1;

SELECT
  vendorID INTO v_name2
FROM
  gggs_vendor
WHERE
  name = r_gggs.column3;

INSERT INTO
  gggs_stock
VALUES
  (
    gggs_stock_seq.NEXTVAL,
    v_name1,
    v_name2,
    r_gggs.column2,
    r_gggs.column4,
    r_gggs.column7,
    r_gggs.column8,
    k_active_status
  );

ELSIF (r_gggs.process_type = k_status) THEN
UPDATE gggs_stock
SET
  status = r_gggs.column2
WHERE
  name = r_gggs.column1;

ELSIF (r_gggs.process_type = k_change) THEN
UPDATE gggs_stock
SET
  description = DECODE(
    r_gggs.column4,
    k_no_change_char,
    description,
    r_gggs.column4
  ),
  price = NVL2(r_gggs.column7, r_gggs.column7, price),
  no_in_stock = NVL2(
    r_gggs.column8,
    (no_in_stock - r_gggs.column8),
    no_in_stock
  )
WHERE
  name = r_gggs.column1;

ELSE RAISE_APPLICATION_ERROR (
  -20002,
  r_gggs.process_type || ' is not a valid process request for ' || r_gggs.data_type || ' data'
);

END IF;

ELSE RAISE_APPLICATION_ERROR (
  -20003,
  r_gggs.data_type || ' is not a valid type of data to process'
);

END IF;

UPDATE gggs_data_upload
SET
  data_processed = k_data_processed
WHERE
  loadID = r_gggs.loadID;

COMMIT;

EXCEPTION WHEN OTHERS THEN ROLLBACK;

v_message := SQLERRM;

INSERT INTO
  gggs_error_log_table
VALUES
  (r_gggs.data_type, r_gggs.process_type, v_message);

COMMIT;

END;

END
LOOP;

END;

/
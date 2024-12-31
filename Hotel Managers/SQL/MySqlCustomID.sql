
-- Trigger ID cho bảng Employees
DELIMITER //

CREATE TRIGGER trg_AutoEmployeeID
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
    DECLARE COUNTER INT;

    -- Tính số thứ tự (STT) dựa vào số lượng bản ghi hiện có
    SELECT COUNT(*) + 1 INTO COUNTER FROM Employees;

    -- Định dạng EMPLOYEE_ID
    SET NEW.EMPLOYEE_ID = CONCAT('EMP', LPAD(COUNTER, 3, '0'));
END;
//

DELIMITER ;

-- Trigger cho bảng Customers
DELIMITER //

CREATE TRIGGER trg_AutoCustomerID
BEFORE INSERT ON Customers
FOR EACH ROW
BEGIN
    DECLARE COUNTER INT;
    DECLARE YEAR_OF_BIRTH VARCHAR(2);
    DECLARE ISO VARCHAR(3);

    -- Lấy 2 số cuối năm sinh từ DATE_OF_BIRTH
    SET YEAR_OF_BIRTH = RIGHT(YEAR(NEW.DATE_OF_BIRTH), 2);
    
    -- Lấy mã ISO từ bảng Countries dựa vào tên quốc tịch
    SELECT ISO_Code INTO ISO
    FROM Countries
    WHERE Country_Name = NEW.NATIONALITY;

    -- Kiểm tra xem mã ISO có tồn tại không
    IF ISO IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quốc tịch không hợp lệ hoặc không tìm thấy mã ISO.';
    END IF;

    -- Tính số thứ tự (STT) dựa vào số lượng bản ghi hiện có
    SELECT COUNT(*) + 1 INTO COUNTER FROM Customers;

    -- Định dạng CUSTOMER_ID
    SET NEW.CUSTOMER_ID = CONCAT('KH', YEAR_OF_BIRTH, ISO, LPAD(COUNTER, 3, '0'));
END;
//

DELIMITER ;


-- Trigger cho bảng Hotels
DELIMITER //

CREATE TRIGGER trg_AutoHotelID
BEFORE INSERT ON Hotels
FOR EACH ROW
BEGIN
    DECLARE COUNTER INT;
    DECLARE ISO VARCHAR(3);
    DECLARE AFC VARCHAR(2);
    DECLARE HOTEL_ID VARCHAR(255);

    -- Lấy mã ISO từ bảng Countries dựa vào tên quốc gia
    SELECT ISO_Code INTO ISO
    FROM Countries
    WHERE Country_Name = NEW.COUNTRY;

    -- Kiểm tra nếu mã ISO không tồn tại
    IF ISO IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quốc gia không hợp lệ hoặc không tìm thấy mã ISO.';
    END IF;

    -- Lấy mã thành phố AFC (giả sử mã thành phố là viết tắt 2 ký tự đầu của tên thành phố)
    SET AFC = UPPER(LEFT(NEW.CITY, 2));

    -- Tính số thứ tự (STT) dựa vào số lượng bản ghi hiện có
    SELECT COUNT(*) + 1 INTO COUNTER FROM Hotels;

    -- Định dạng HOTEL_ID
    SET HOTEL_ID = CONCAT(ISO, LPAD(COUNTER, 3, '0'), AFC);
    
    -- Thêm bản ghi mới vào bảng Hotels
    SET NEW.HOTEL_ID = HOTEL_ID;
END;
//

DELIMITER ;


-- Trigger cho bảng Rooms
DELIMITER //

CREATE TRIGGER trg_AutoRoomID
BEFORE INSERT ON Rooms
FOR EACH ROW
BEGIN
    DECLARE COUNTER INT;
    DECLARE TYPE_CHAR CHAR(1);
    DECLARE ROOM_ID VARCHAR(255);

    -- Lấy ký tự đầu tiên của ROOM_TYPE (TYPE)
    SET TYPE_CHAR = UPPER(LEFT(NEW.ROOM_TYPE, 1));

    -- Tính số thứ tự (STT) dựa vào số lượng phòng trên cùng tầng và cùng khách sạn
    SELECT COUNT(*) + 1 INTO COUNTER
    FROM Rooms
    WHERE HOTEL_ID = NEW.HOTEL_ID AND FLOOR = NEW.FLOOR;

    -- Định dạng ROOM_ID
    SET ROOM_ID = CONCAT(TYPE_CHAR, LPAD(NEW.FLOOR, 1, '0'), LPAD(COUNTER, 2, '0'));

    -- Thêm bản ghi mới vào bảng Rooms
    SET NEW.ROOM_ID = ROOM_ID;
END;
//

DELIMITER ;

-- Trigger cho bảng Bookings
DELIMITER //

CREATE TRIGGER trg_AutoBookingRoomID
BEFORE INSERT ON Bookings
FOR EACH ROW
BEGIN
    DECLARE STT INT;
    DECLARE YYMMDD VARCHAR(6);
    DECLARE LAST5_CUSTOMER_ID VARCHAR(5);
    DECLARE BOOKING_ID VARCHAR(255);

    -- Lấy 5 ký tự cuối của mã khách hàng (XXXXX)
    SET LAST5_CUSTOMER_ID = RIGHT(NEW.CUSTOMER_ID, 5);

    -- Tính số thứ tự (STT) dựa vào số lượng bản ghi đã có
    SELECT COUNT(*) + 1 INTO STT FROM Bookings;

    -- Lấy YYMMDD từ BOOKING_DATE
    SET YYMMDD = RIGHT(CONVERT(YEAR(NEW.BOOKING_DATE), CHAR), 2) || 
                  RIGHT(CONCAT('0', CONVERT(MONTH(NEW.BOOKING_DATE), CHAR)), 2) || 
                  RIGHT(CONCAT('0', CONVERT(DAY(NEW.BOOKING_DATE), CHAR)), 2);

    -- Định dạng BOOKING_ID
    SET BOOKING_ID = CONCAT('BK', LPAD(STT, 3, '0'), YYMMDD, LAST5_CUSTOMER_ID);

    -- Gán giá trị cho BOOKING_ID trong bản ghi mới
    SET NEW.BOOKING_ID = BOOKING_ID;
END;
//

DELIMITER ;

-- Trigger cho bảng Payments
DELIMITER //

CREATE TRIGGER trg_AutoPaymentID
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
    DECLARE USER_ID INT;
    DECLARE BOOKING_ID VARCHAR(255);
    DECLARE INVOICE_DATE DATETIME;
    DECLARE DUE_DATE DATETIME;
    DECLARE TOTAL_AMOUNT DECIMAL(16,0);
    DECLARE TAX_AMOUNT DECIMAL(16,0);
    DECLARE AMOUNT_PAID DECIMAL(16,0);
    DECLARE OUTSTANDING_AMOUNT DECIMAL(16,0);
    DECLARE PAYMENT_DATE DATETIME;
    DECLARE PAYMENT_METHOD NVARCHAR(255);
    DECLARE PAYMENT_STATUS NVARCHAR(255);
    DECLARE PAYMENT_ID VARCHAR(255);
    DECLARE YYMMDD VARCHAR(6);
    DECLARE CUSTOMER_ID VARCHAR(255);
    DECLARE EMPLOYEE_ID VARCHAR(255);
    DECLARE LAST5_CUSTOMER_ID VARCHAR(5);
    DECLARE LAST5_EMPLOYEE_ID VARCHAR(5);

    -- Lấy thông tin từ bảng NEW (bản ghi đang chèn)
    SET USER_ID = NEW.USER_ID;
    SET BOOKING_ID = NEW.BOOKING_ID;
    SET INVOICE_DATE = NEW.INVOICE_DATE;
    SET DUE_DATE = NEW.DUE_DATE;
    SET TOTAL_AMOUNT = NEW.TOTAL_AMOUNT;
    SET TAX_AMOUNT = NEW.TAX_AMOUNT;
    SET AMOUNT_PAID = NEW.AMOUNT_PAID;
    SET OUTSTANDING_AMOUNT = NEW.OUTSTANDING_AMOUNT;
    SET PAYMENT_DATE = NEW.PAYMENT_DATE;
    SET PAYMENT_METHOD = NEW.PAYMENT_METHOD;
    SET PAYMENT_STATUS = NEW.PAYMENT_STATUS;

    -- Kiểm tra USER_ID thuộc về Customers hay Employees
    SELECT CUSTOMER_ID INTO CUSTOMER_ID 
    FROM Customers 
    WHERE USER_ID = USER_ID;

    SELECT EMPLOYEE_ID INTO EMPLOYEE_ID 
    FROM Employees 
    WHERE USER_ID = USER_ID;

    -- Nếu là khách hàng, lấy CUSTOMER_ID
    IF CUSTOMER_ID IS NOT NULL THEN
        SET LAST5_CUSTOMER_ID = RIGHT(CUSTOMER_ID, 5);
    -- Nếu là nhân viên, lấy EMPLOYEE_ID
    ELSEIF EMPLOYEE_ID IS NOT NULL THEN
        SET LAST5_EMPLOYEE_ID = RIGHT(EMPLOYEE_ID, 5);
    END IF;

    -- Lấy YYMMDD từ PAYMENT_DATE
    IF PAYMENT_DATE IS NULL THEN
        SET PAYMENT_DATE = NOW();
    END IF;

    SET YYMMDD = RIGHT(CONVERT(YEAR(PAYMENT_DATE), CHAR), 2) || 
                  RIGHT(CONCAT('0', CONVERT(MONTH(PAYMENT_DATE), CHAR)), 2) || 
                  RIGHT(CONCAT('0', CONVERT(DAY(PAYMENT_DATE), CHAR)), 2);

    -- Định dạng PAYMENT_ID
    IF CUSTOMER_ID IS NOT NULL THEN
        SET PAYMENT_ID = CONCAT('P', YYMMDD, LAST5_CUSTOMER_ID);
    ELSEIF EMPLOYEE_ID IS NOT NULL THEN
        SET PAYMENT_ID = CONCAT('P', YYMMDD, LAST5_EMPLOYEE_ID);
    END IF;

    -- Chèn bản ghi mới vào bảng Payments
    SET NEW.PAYMENT_ID = PAYMENT_ID; -- Gán PAYMENT_ID cho bản ghi mới
END;
//

DELIMITER ;

-- Trigger cho bảng Discounts
DELIMITER //

CREATE TRIGGER trg_AutoDiscountID
BEFORE INSERT ON Discounts
FOR EACH ROW
BEGIN
    DECLARE CODE VARCHAR(50);
    DECLARE DESCRIPTION NVARCHAR(500);
    DECLARE DISCOUNT_TYPE NVARCHAR(100);
    DECLARE DISCOUNT_VALUE DECIMAL(16,0);
    DECLARE START_DATE DATETIME;
    DECLARE END_DATE DATETIME;
    DECLARE MIN_BOOKING_VALUE DECIMAL(16,0);
    DECLARE STATUS NVARCHAR(100);
    DECLARE DISCOUNT_ID VARCHAR(255);
    DECLARE YYMMDD VARCHAR(6);
    DECLARE STT INT;
    DECLARE DISCOUNT_TYPE_CODE VARCHAR(10);

    -- Lấy thông tin từ bảng NEW (bản ghi đang chèn)
    SET CODE = NEW.CODE;
    SET DESCRIPTION = NEW.DESCIPTION;
    SET DISCOUNT_TYPE = NEW.DISCOUNT_TYPE;
    SET DISCOUNT_VALUE = NEW.DISCOUNT_VALUE;
    SET START_DATE = NEW.START_DATE;
    SET END_DATE = NEW.END_DATE;
    SET MIN_BOOKING_VALUE = NEW.MIN_BOOKING_VALUE;
    SET STATUS = NEW.STATUS;

    -- Lấy YYMMDD từ START_DATE
    IF START_DATE IS NULL THEN
        SET START_DATE = NOW();
    END IF;

    SET YYMMDD = RIGHT(CONVERT(YEAR(START_DATE), CHAR), 2) || 
                  RIGHT(CONCAT('0', CONVERT(MONTH(START_DATE), CHAR)), 2) || 
                  RIGHT(CONCAT('0', CONVERT(DAY(START_DATE), CHAR)), 2);

    -- Chuyển loại giảm giá (ví dụ: 10% -> 10P, 20% -> 20P, ...)
    SET DISCOUNT_TYPE_CODE = LPAD(CONVERT(DISCOUNT_TYPE, CHAR), 2, '0') || 'P'; -- Các mức lớn hơn thì thêm 'P' vào

    -- Lấy số thứ tự (STT) dựa trên loại giảm giá
    SELECT COUNT(*) + 1 INTO STT FROM Discounts;

    -- Định dạng DISCOUNT_ID
    SET DISCOUNT_ID = CONCAT('DC', DISCOUNT_TYPE_CODE, LPAD(CONVERT(STT, CHAR), 3, '0'), YYMMDD);

    -- Chèn bản ghi mới vào bảng Discounts
    SET NEW.DISCOUNT_ID = DISCOUNT_ID; -- Gán DISCOUNT_ID cho bản ghi mới
END;
//

DELIMITER ;


-- Trigger cho bảng VIPMembers
DELIMITER //

CREATE TRIGGER trg_AutoVIPMembersID
BEFORE INSERT ON VIPMembers
FOR EACH ROW
BEGIN
    DECLARE CUSTOMER_ID VARCHAR(255);
    DECLARE POINTS INT;
    DECLARE TIER NVARCHAR(50);
    DECLARE VIPMembers_ID VARCHAR(255);
    DECLARE YYMMDD VARCHAR(6);
    DECLARE YMD VARCHAR(6);

    -- Lấy thông tin từ bảng NEW (bản ghi đang chèn)
    SET CUSTOMER_ID = NEW.CUSTOMER_ID;
    SET POINTS = NEW.POINTS;
    SET TIER = NEW.TIER;

    -- Lấy YMD từ ngày hiện tại
    SET YMD = RIGHT(CONVERT(DAY(NOW()), CHAR), 2) || 
              RIGHT(CONCAT('0', CONVERT(MONTH(NOW()), CHAR)), 2) || 
              RIGHT(CONVERT(YEAR(NOW()), CHAR), 2);

    -- Định dạng VIPMembers_ID
    SET VIPMembers_ID = CONCAT('VIPMembers', RIGHT(CUSTOMER_ID, LENGTH(CUSTOMER_ID) - 2), YMD); -- Lấy mã khách hàng (CID) mà không có prefix

    -- Chèn bản ghi mới vào bảng VIPMembers
    SET NEW.VIPMembers_ID = VIPMembers_ID; -- Gán VIPMembers_ID cho bản ghi mới
    SET NEW.REG_AT = NOW(); -- Gán thời gian hiện tại cho REG_AT
END;
//

DELIMITER ;

USE QuanLyWebBookingHotel
GO

-- Trigger ID cho bảng Employees
CREATE TRIGGER trg_AutoEmployeeID
ON Employees
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @USER_ID INT,
            @FULL_NAME NVARCHAR(255),
            @POSITION NVARCHAR(255),
            @HIRE_DATE DATETIME,
            @PHONE_NUMBER VARCHAR(20),
            @SALARY DECIMAL(16, 0),
            @STATUS NVARCHAR(50),
            @EMPLOYEE_ID VARCHAR(255),
            @COUNTER INT;

    -- Lấy thông tin từ bảng INSERTED
    SELECT @USER_ID = USER_ID,
           @FULL_NAME = FULL_NAME,
           @POSITION = POSITION,
           @HIRE_DATE = HIRE_DATE,
           @PHONE_NUMBER = PHONE_NUMBER,
           @SALARY = SALARY,
           @STATUS = STATUS
    FROM INSERTED;

    -- Tính số thứ tự (STT) dựa vào số lượng bản ghi hiện có
    SELECT @COUNTER = COUNT(*) + 1 FROM Employees;

    -- Định dạng EMPLOYEE_ID
    SET @EMPLOYEE_ID = 'EMP' + RIGHT('000' + CAST(@COUNTER AS VARCHAR(3)), 3);
    
    -- Thêm bản ghi mới vào bảng Employees
    INSERT INTO Employees (EMPLOYEE_ID, USER_ID, FULL_NAME, POSITION, HIRE_DATE, PHONE_NUMBER, SALARY, STATUS)
    VALUES (@EMPLOYEE_ID, @USER_ID, @FULL_NAME, @POSITION, @HIRE_DATE, @PHONE_NUMBER, @SALARY, @STATUS);
END;
GO

-- Trigger cho bảng Customers
CREATE TRIGGER trg_AutoCustomerID
ON Customers
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @USER_ID INT,
            @FULL_NAME NVARCHAR(255),
            @PHONE_NUMBER VARCHAR(20),
            @ADDRESS NVARCHAR(500),
            @DATE_OF_BIRTH DATETIME,
            @NATIONALITY VARCHAR(100),
            @CUSTOMER_ID VARCHAR(255),
            @YEAR_OF_BIRTH VARCHAR(2),
            @ISO VARCHAR(3),
            @COUNTER INT;

    -- Lấy thông tin từ bảng INSERTED
    SELECT @USER_ID = USER_ID,
           @FULL_NAME = FULL_NAME,
           @PHONE_NUMBER = PHONE_NUMBER,
           @ADDRESS = ADDRESS,
           @DATE_OF_BIRTH = DATE_OF_BIRTH,
           @NATIONALITY = NATIONALITY
    FROM INSERTED;

    -- Lấy 2 số cuối năm sinh từ DATE_OF_BIRTH
    SET @YEAR_OF_BIRTH = RIGHT(CONVERT(VARCHAR(4), YEAR(@DATE_OF_BIRTH)), 2);
    
    -- Lấy mã ISO từ bảng Countries dựa vào tên quốc tịch
    SELECT @ISO = ISO_Code
    FROM Countries
    WHERE Country_Name = @NATIONALITY;

    -- Kiểm tra xem mã ISO có tồn tại không
    IF @ISO IS NULL
    BEGIN
        RAISERROR('Quốc tịch không hợp lệ hoặc không tìm thấy mã ISO.', 16, 1);
        RETURN;
    END

    -- Tính số thứ tự (STT) dựa vào số lượng bản ghi hiện có
    SELECT @COUNTER = COUNT(*) + 1 FROM Customers;
    
    -- Định dạng CUSTOMER_ID
    SET @CUSTOMER_ID = 'KH' + @YEAR_OF_BIRTH + @ISO + RIGHT('000' + CAST(@COUNTER AS VARCHAR(3)), 3);
    
    -- Thêm bản ghi mới vào bảng Customers
    INSERT INTO Customers (CUSTOMER_ID, USER_ID, FULL_NAME, PHONE_NUMBER, ADDRESS, DATE_OF_BIRTH, NATIONALITY, VIPMembers_STATUS)
    VALUES (@CUSTOMER_ID, @USER_ID, @FULL_NAME, @PHONE_NUMBER, @ADDRESS, @DATE_OF_BIRTH, @NATIONALITY, NULL);
END;
GO

-- Trigger cho bảng Hotels
ALTER TRIGGER trg_AutoHotelID
ON Hotels
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @DESTINATION_ID INT,
            @HOTEL_NAME NVARCHAR(255),
            @HOTEL_ADDRESS NVARCHAR(255),
            @CITY NVARCHAR(255),
            @COUNTRY NVARCHAR(255),
            @STAR_RATING FLOAT,
            @PHONE_NUMBER VARCHAR(20),
            @EMAIL VARCHAR(150),
            @WEBSITE VARCHAR(255),
            @NUMBER_OF_ROOMS INT,
            @HOTEL_TYPE VARCHAR(50),
            @LATITUDE FLOAT,
            @LONGITUDE FLOAT,
            @HOTEL_ID VARCHAR(255),
            @ISO VARCHAR(3),
            @AFC NVARCHAR(255),
            @COUNTER INT;

    -- Lấy thông tin từ bảng INSERTED
    SELECT @DESTINATION_ID = DESTINATION_ID,
           @HOTEL_NAME = HOTEL_NAME,
           @HOTEL_ADDRESS = HOTEL_ADDRESS,
           @CITY = CITY,
           @COUNTRY = COUNTRY,
           @STAR_RATING = STAR_RATING,
           @PHONE_NUMBER = PHONE_NUMBER,
           @EMAIL = EMAIL,
           @WEBSITE = WEBSITE,
           @NUMBER_OF_ROOMS = NUMBER_OF_ROOMS,
           @HOTEL_TYPE = HOTEL_TYPE,
           @LATITUDE = LATITUDE,
           @LONGITUDE = LONGITUDE
    FROM INSERTED;

    -- Lấy mã ISO từ bảng Countries dựa vào tên quốc gia
    SELECT @ISO = ISO_Code
    FROM Countries
    WHERE Country_Name = @COUNTRY;

    -- Kiểm tra nếu mã ISO không tồn tại
    IF @ISO IS NULL
    BEGIN
        RAISERROR('Quốc gia không hợp lệ hoặc không tìm thấy mã ISO.', 16, 1);
        RETURN;
    END

    -- Lấy mã thành phố AFC (giả sử mã thành phố là viết tắt 2 ký tự đầu của tên thành phố)
	SET @AFC = UPPER(LEFT(@CITY, 2));

    -- Tính số thứ tự (STT) dựa vào số lượng bản ghi hiện có
    SELECT @COUNTER = COUNT(*) + 1 FROM Hotels;

    -- Định dạng HOTEL_ID
    SET @HOTEL_ID = @ISO + RIGHT('000' + CAST(@COUNTER AS VARCHAR(3)), 3) + @AFC;
    
    -- Thêm bản ghi mới vào bảng Hotels
    INSERT INTO Hotels (HOTEL_ID, DESTINATION_ID, HOTEL_NAME, HOTEL_ADDRESS, CITY, COUNTRY, STAR_RATING, PHONE_NUMBER, EMAIL, WEBSITE, NUMBER_OF_ROOMS, HOTEL_TYPE, LATITUDE, LONGITUDE)
    VALUES (@HOTEL_ID, @DESTINATION_ID, @HOTEL_NAME, @HOTEL_ADDRESS, @CITY, @COUNTRY, @STAR_RATING, @PHONE_NUMBER, @EMAIL, @WEBSITE, @NUMBER_OF_ROOMS, @HOTEL_TYPE, @LATITUDE, @LONGITUDE);
END;
GO

-- Trigger cho bảng Rooms
CREATE TRIGGER trg_AutoRoomID
ON Rooms
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @HOTEL_ID VARCHAR(255),
            @ROOM_TYPE NVARCHAR(255),
            @PRICE_PER_DAY DECIMAL(16,0),
            @MAX_OCCUPANCY INT,
            @ROOM_DESCRIPTION NVARCHAR(255),
            @AVAILABILITY_STATUS NVARCHAR(255),
            @FLOOR INT,
            @ROOM_ID VARCHAR(255),
            @TYPE_CHAR CHAR(1),
            @COUNTER INT;

    -- Lấy thông tin từ bảng INSERTED
    SELECT @HOTEL_ID = HOTEL_ID,
           @ROOM_TYPE = ROOM_TYPE,
           @PRICE_PER_DAY = PRICE_PER_DAY,
           @MAX_OCCUPANCY = MAX_OCCUPANCY,
           @ROOM_DESCRIPTION = ROOM_DESCRIPTION,
           @AVAILABILITY_STATUS = AVAILABILITY_STATUS,
           @FLOOR = FLOOR
    FROM INSERTED;

    -- Lấy ký tự đầu tiên của ROOM_TYPE (TYPE)
    SET @TYPE_CHAR = UPPER(LEFT(@ROOM_TYPE, 1));

    -- Tính số thứ tự (STT) dựa vào số lượng phòng trên cùng tầng và cùng khách sạn
    SELECT @COUNTER = COUNT(*) + 1 
    FROM Rooms 
    WHERE HOTEL_ID = @HOTEL_ID AND FLOOR = @FLOOR;

    -- Định dạng ROOM_ID
    SET @ROOM_ID = @TYPE_CHAR + RIGHT('00' + CAST(@FLOOR AS VARCHAR(3)), 1) + RIGHT('00' + CAST(@COUNTER AS VARCHAR(2)), 2);
    
    -- Thêm bản ghi mới vào bảng Rooms
    INSERT INTO Rooms (ROOM_ID, HOTEL_ID, ROOM_TYPE, PRICE_PER_DAY, MAX_OCCUPANCY, ROOM_DESCRIPTION, AVAILABILITY_STATUS, FLOOR)
    VALUES (@ROOM_ID, @HOTEL_ID, @ROOM_TYPE, @PRICE_PER_DAY, @MAX_OCCUPANCY, @ROOM_DESCRIPTION, @AVAILABILITY_STATUS, @FLOOR);
END;
GO

-- Trigger cho bảng Bookings
CREATE TRIGGER trg_AutoBookingRoomID
ON Bookings
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @CUSTOMER_ID VARCHAR(255),
            @HOTEL_ID VARCHAR(255),
            @ROOM_ID VARCHAR(255),
            @BOOKING_DATE DATETIME,
            @CHECK_IN_DATE DATETIME,
            @CHECK_OUT_DATE DATETIME,
            @PAYMENTS_STATUS VARCHAR(255),
            @TOTAL_AMOUNT DECIMAL(16,0),
            @BOOKING_STATUS NVARCHAR(255),
            @BOOKING_ID VARCHAR(255),
            @STT INT,
            @YYMMDD VARCHAR(6),
            @LAST5_CUSTOMER_ID VARCHAR(5);
    
    -- Lấy thông tin từ bảng INSERTED
    SELECT @CUSTOMER_ID = CUSTOMER_ID,
           @HOTEL_ID = HOTEL_ID,
           @ROOM_ID = ROOM_ID,
           @BOOKING_DATE = BOOKING_DATE,
           @CHECK_IN_DATE = CHECK_IN_DATE,
           @CHECK_OUT_DATE = CHECK_OUT_DATE,
           @PAYMENTS_STATUS = PAYMENTS_STATUS,
           @TOTAL_AMOUNT = TOTAL_AMOUNT,
           @BOOKING_STATUS = BOOKING_STATUS
    FROM INSERTED;

    -- Lấy 5 ký tự cuối của mã khách hàng (XXXXX)
    SET @LAST5_CUSTOMER_ID = RIGHT(@CUSTOMER_ID, 5);

    -- Tính số thứ tự (STT) dựa vào số lượng bản ghi đã có
    SELECT @STT = COUNT(*) + 1 FROM Bookings;

    -- Lấy YYMMDD từ BOOKING_DATE
    SET @YYMMDD = RIGHT(CONVERT(VARCHAR, YEAR(@BOOKING_DATE)), 2) + 
                  RIGHT('0' + CONVERT(VARCHAR, MONTH(@BOOKING_DATE)), 2) + 
                  RIGHT('0' + CONVERT(VARCHAR, DAY(@BOOKING_DATE)), 2);

    -- Định dạng BOOKING_ID
    SET @BOOKING_ID = 'BK' + RIGHT('000' + CAST(@STT AS VARCHAR(3)), 3) + @YYMMDD + @LAST5_CUSTOMER_ID;

    -- Thêm bản ghi mới vào bảng Bookings
    INSERT INTO Bookings (BOOKING_ID, CUSTOMER_ID, HOTEL_ID, ROOM_ID, BOOKING_DATE, CHECK_IN_DATE, CHECK_OUT_DATE, PAYMENTS_STATUS, TOTAL_AMOUNT, BOOKING_STATUS)
    VALUES (@BOOKING_ID, @CUSTOMER_ID, @HOTEL_ID, @ROOM_ID, @BOOKING_DATE, @CHECK_IN_DATE, @CHECK_OUT_DATE, @PAYMENTS_STATUS, @TOTAL_AMOUNT, @BOOKING_STATUS);
END;
GO

-- Trigger cho bảng Payments
ALTER TRIGGER trg_AutoPaymentID
ON Payments
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @USER_ID INT,
            @BOOKING_ID VARCHAR(255),
            @INVOICE_DATE DATETIME,
            @DUE_DATE DATETIME,
            @TOTAL_AMOUNT DECIMAL(16,0),
            @TAX_AMOUNT DECIMAL(16,0),
            @AMOUNT_PAID DECIMAL(16,0),
            @OUTSTANDING_AMOUNT DECIMAL(16,0),
            @PAYMENT_DATE DATETIME,
            @PAYMENT_METHOD NVARCHAR(255),
            @PAYMENT_STATUS NVARCHAR(255),
            @PAYMENT_ID VARCHAR(255),
            @YYMMDD VARCHAR(6),
            @CUSTOMER_ID VARCHAR(255),
            @EMPLOYEE_ID VARCHAR(255),
            @LAST5_CUSTOMER_ID VARCHAR(5),
            @LAST5_EMPLOYEE_ID VARCHAR(5);

    -- Lấy thông tin từ bảng INSERTED
    SELECT @USER_ID = USER_ID,
           @BOOKING_ID = BOOKING_ID,
           @INVOICE_DATE = INVOICE_DATE,
           @DUE_DATE = DUE_DATE,
           @TOTAL_AMOUNT = TOTAL_AMOUNT,
           @TAX_AMOUNT = TAX_AMOUNT,
           @AMOUNT_PAID = AMOUNT_PAID,
           @OUTSTANDING_AMOUNT = OUTSTANDING_AMOUNT,
           @PAYMENT_DATE = PAYMENT_DATE,
           @PAYMENT_METHOD = PAYMENT_METHOD,
           @PAYMENT_STATUS = PAYMENT_STATUS
    FROM INSERTED;

    -- Kiểm tra USER_ID thuộc về Customers hay Employees
    SELECT @CUSTOMER_ID = CUSTOMER_ID 
    FROM Customers 
    WHERE USER_ID = @USER_ID;

    SELECT @EMPLOYEE_ID = EMPLOYEE_ID 
    FROM Employees 
    WHERE USER_ID = @USER_ID;

    -- Nếu là khách hàng, lấy CUSTOMER_ID
    IF @CUSTOMER_ID IS NOT NULL
    BEGIN
        SET @LAST5_CUSTOMER_ID = RIGHT(@CUSTOMER_ID, 5);
    END
    -- Nếu là nhân viên, lấy EMPLOYEE_ID
    ELSE IF @EMPLOYEE_ID IS NOT NULL
    BEGIN
        SET @LAST5_EMPLOYEE_ID = RIGHT(@EMPLOYEE_ID, 5);
    END

    -- Lấy YYMMDD từ PAYMENT_DATE
    IF @PAYMENT_DATE IS NULL
        SET @PAYMENT_DATE = GETDATE();
    
    SET @YYMMDD = RIGHT(CONVERT(VARCHAR, YEAR(@PAYMENT_DATE)), 2) + 
                  RIGHT('0' + CONVERT(VARCHAR, MONTH(@PAYMENT_DATE)), 2) + 
                  RIGHT('0' + CONVERT(VARCHAR, DAY(@PAYMENT_DATE)), 2);

    -- Định dạng PAYMENT_ID
    IF @CUSTOMER_ID IS NOT NULL
    BEGIN
        SET @PAYMENT_ID = 'P' + @YYMMDD + @LAST5_CUSTOMER_ID;
    END
    ELSE IF @EMPLOYEE_ID IS NOT NULL
    BEGIN
        SET @PAYMENT_ID = 'P' + @YYMMDD + @LAST5_EMPLOYEE_ID;
    END

    -- Chèn bản ghi mới vào bảng Payments
    INSERT INTO Payments (PAYMENT_ID, USER_ID, BOOKING_ID, INVOICE_DATE, DUE_DATE, TOTAL_AMOUNT, TAX_AMOUNT, AMOUNT_PAID, OUTSTANDING_AMOUNT, PAYMENT_DATE, PAYMENT_METHOD, PAYMENT_STATUS)
    VALUES (@PAYMENT_ID, @USER_ID, @BOOKING_ID, @INVOICE_DATE, @DUE_DATE, @TOTAL_AMOUNT, @TAX_AMOUNT, @AMOUNT_PAID, @OUTSTANDING_AMOUNT, @PAYMENT_DATE, @PAYMENT_METHOD, @PAYMENT_STATUS);
END;
GO

-- Trigger cho bảng Discounts
ALTER TRIGGER trg_AutoDiscountID
ON Discounts
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @CODE VARCHAR(50),
            @DESCIPTION NVARCHAR(500),
            @DISCOUNT_TYPE NVARCHAR(100),
            @DISCOUNT_VALUE DECIMAL(16,0),
            @START_DATE DATETIME,
            @END_DATE DATETIME,
            @MIN_BOOKING_VALUE DECIMAL(16,0),
            @STATUS NVARCHAR(100),
            @DISCOUNT_ID VARCHAR(255),
            @YYMMDD VARCHAR(6),
            @STT INT,
            @DISCOUNT_TYPE_CODE VARCHAR(10);

    -- Lấy thông tin từ bảng INSERTED
    SELECT @CODE = CODE,
           @DESCIPTION = DESCIPTION,
           @DISCOUNT_TYPE = DISCOUNT_TYPE,
           @DISCOUNT_VALUE = DISCOUNT_VALUE,
           @START_DATE = START_DATE,
           @END_DATE = END_DATE,
           @MIN_BOOKING_VALUE = MIN_BOOKING_VALUE,
           @STATUS = STATUS
    FROM INSERTED;

    -- Lấy YYMMDD từ START_DATE
    IF @START_DATE IS NULL
        SET @START_DATE = GETDATE();
    
    SET @YYMMDD = RIGHT(CONVERT(VARCHAR, YEAR(@START_DATE)), 2) + 
                  RIGHT('0' + CONVERT(VARCHAR, MONTH(@START_DATE)), 2) + 
                  RIGHT('0' + CONVERT(VARCHAR, DAY(@START_DATE)), 2);

    -- Chuyển loại giảm giá (ví dụ: 10% -> 10P, 20% -> 20P, ...)
	SET @DISCOUNT_TYPE_CODE = LEFT('0' + CONVERT(VARCHAR, @DISCOUNT_TYPE), 2) + 'P';  -- Các mức lớn hơn thì thêm 'P' vào

    -- Lấy số thứ tự (STT) dựa trên loại giảm giá
    SELECT @STT = COUNT(*) + 1 FROM Discounts;

    -- Định dạng DISCOUNT_ID
    SET @DISCOUNT_ID = 'DC' + @DISCOUNT_TYPE_CODE + RIGHT('000' + CONVERT(VARCHAR, @STT), 3) + @YYMMDD;

    -- Chèn bản ghi mới vào bảng Discounts
    INSERT INTO Discounts (DISCOUNT_ID, CODE, DESCIPTION, DISCOUNT_TYPE, DISCOUNT_VALUE, START_DATE, END_DATE, MIN_BOOKING_VALUE, STATUS)
    VALUES (@DISCOUNT_ID, @CODE, @DESCIPTION, @DISCOUNT_TYPE, @DISCOUNT_VALUE, @START_DATE, @END_DATE, @MIN_BOOKING_VALUE, @STATUS);
END;
GO

-- Trigger cho bảng VIPMembers
CREATE TRIGGER trg_AutoVIPMembersID
ON VIPMembers
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @CUSTOMER_ID VARCHAR(255),
            @POINTS INT,
            @TIER NVARCHAR(50),
            @VIPMembers_ID VARCHAR(255),
            @YYMMDD VARCHAR(6),
            @YMD VARCHAR(6);

    -- Lấy thông tin từ bảng INSERTED
    SELECT @CUSTOMER_ID = CUSTOMER_ID,
           @POINTS = POINTS,
           @TIER = TIER
    FROM INSERTED;

    -- Lấy YMD từ ngày hiện tại
    SET @YMD = RIGHT(CONVERT(VARCHAR, DAY(GETDATE())), 2) + 
                RIGHT('0' + CONVERT(VARCHAR, MONTH(GETDATE())), 2) + 
                RIGHT(CONVERT(VARCHAR, YEAR(GETDATE())), 2);

    -- Định dạng VIPMembers_ID
    SET @VIPMembers_ID = 'VIPMembers' + RIGHT(@CUSTOMER_ID, LEN(@CUSTOMER_ID) - 2) + @YMD;  -- Lấy mã khách hàng (CID) mà không có prefix

    -- Chèn bản ghi mới vào bảng VIPMembers
    INSERT INTO VIPMembers (VIPMembers_ID, CUSTOMER_ID, POINTS, TIER, REG_AT)
    VALUES (@VIPMembers_ID, @CUSTOMER_ID, @POINTS, @TIER, GETDATE());
END;
GO
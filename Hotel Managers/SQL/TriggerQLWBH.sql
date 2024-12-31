USE QuanLyWebBookingHotel
GO

--Kiểm tra ngày của voucher
CREATE TRIGGER trg_discount_check_dates
ON Discounts
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted
        WHERE END_DATE <= START_DATE
    )
    BEGIN
        RAISERROR ('Ngày kết thúc (END_DATE) phải lớn hơn ngày bắt đầu (START_DATE)', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

--Kiểm tra ngày checkin và checkout
CREATE TRIGGER trg_booking_check_in_out
ON Bookings
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted
        WHERE CHECK_OUT_DATE >= CHECK_IN_DATE
    )
    BEGIN
        RAISERROR ('Ngày check out phải lớn hơn ngày check in', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
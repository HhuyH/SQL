USE QuanLyWebBookingHotel
GO

INSERT INTO TouristDestinations (DESTINATION_NAME, DESCRIPTION, STAR_RATING, LOCATION) VALUES
(N'Nha Trang', N'Thành phố biển nổi tiếng với những bãi biển đẹp.', 4.6, N'Trung Bộ'),
(N'Hội An', N'Phố cổ với kiến trúc lịch sử và văn hóa đa dạng.', 5.0, N'Trung Bộ'),
(N'Phú Quốc', N'Hòn đảo thiên đường với các bãi biển tuyệt đẹp.', 3.9, N'Nam Bộ'),
(N'Sapa', N'Núi rừng hùng vĩ, nơi có văn hóa độc đáo của các dân tộc.', 4.2, N'Vùng núi phía Bắc'),
(N'Vũng Tàu', N'Thành phố biển gần Sài Gòn với các hoạt động vui chơi giải trí.', 4.7, N'Nam Bộ');
GO

INSERT INTO Hotels (DESTINATION_ID, HOTEL_NAME, HOTEL_ADDRESS, CITY, COUNTRY, STAR_RATING, PHONE_NUMBER, EMAIL, WEBSITE, NUMBER_OF_ROOMS, HOTEL_TYPE, LATITUDE, LONGITUDE) VALUES
	(1, N'Royal Hotel', N'Số 12, Đường Hàng Bài', 'Ha Noi', 'VietNam', 4.8, '0123456789', 'contact@royalhotel.vn', 'www.royalhotel.vn', 60, 'Hotel', 21.0285, 105.8542);
GO
INSERT INTO Hotels (DESTINATION_ID, HOTEL_NAME, HOTEL_ADDRESS, CITY, COUNTRY, STAR_RATING, PHONE_NUMBER, EMAIL, WEBSITE, NUMBER_OF_ROOMS, HOTEL_TYPE, LATITUDE, LONGITUDE) VALUES
	(2, N'Hà Nội Grand', N'Số 3, Đường Tràng Tiền', 'Ha Noi', 'VietNam', 5.0, '0987654321', 'info@hanoigrand.vn', 'www.hanoigrand.vn', 120, 'Hotel', 21.0285, 105.8542);
GO
INSERT INTO Hotels (DESTINATION_ID, HOTEL_NAME, HOTEL_ADDRESS, CITY, COUNTRY, STAR_RATING, PHONE_NUMBER, EMAIL, WEBSITE, NUMBER_OF_ROOMS, HOTEL_TYPE, LATITUDE, LONGITUDE) VALUES
	(3, N'Golden Bay Resort', N'Số 7, Đường Nguyễn Tất Thành', 'Da Nang', 'VietNam', 4.5, '0123456789', 'hello@goldenbayresort.vn', 'www.goldenbayresort.vn', 90, 'Resort', 16.0673, 108.2208);
GO
INSERT INTO Hotels (DESTINATION_ID, HOTEL_NAME, HOTEL_ADDRESS, CITY, COUNTRY, STAR_RATING, PHONE_NUMBER, EMAIL, WEBSITE, NUMBER_OF_ROOMS, HOTEL_TYPE, LATITUDE, LONGITUDE) VALUES
	(4, N'Moonlight Hotel', N'Số 15, Đường Phạm Văn Đồng', 'Da Nang', 'VietNam', 4.2, '0987654321', 'contact@moonlighthotel.vn', 'www.moonlighthotel.vn', 70, 'Hotel', 16.0673, 108.2208);
GO
INSERT INTO Hotels (DESTINATION_ID, HOTEL_NAME, HOTEL_ADDRESS, CITY, COUNTRY, STAR_RATING, PHONE_NUMBER, EMAIL, WEBSITE, NUMBER_OF_ROOMS, HOTEL_TYPE, LATITUDE, LONGITUDE) VALUES
	(5, N'Tokyo Hotel', N'Số 4, Đường Lê Lợi', 'Sai Gon', 'VietNam', 4.7, '0123456789', 'info@tokyohotel.vn', 'www.tokyohotel.vn', 110, 'Hotel', 10.7761, 106.6951);
GO

INSERT INTO CancellationPolicy (HOTEL_ID, POLICY_DESCRIPTION, CREATED_AT) VALUES
('VN001HA', N'Miễn phí Hủy.', GETDATE()),
('VN002HA', N'Hủy miễn phí trong vòng 24 giờ trước khi đến.', GETDATE()),
('VN003DA', N'Hủy miễn phí trong vòng 72 giờ trước khi đến.', GETDATE()),
('VN004DA', N'Hủy miễn phí trong vòng 48 giờ trước khi đến.', GETDATE()),
('VN005SA', N'Hủy miễn phí trong vòng 24 giờ trước khi đến.', GETDATE());
GO

INSERT INTO Attractions (DESTINATION_ID, ATTRACTION_NAME, DESCRIPTION, LATITUDE, LONGITUDE, OPENING_HOURS, TICKET_PRICE) VALUES
(1, N'Vinpearl Land', N'Khu vui chơi giải trí lớn với nhiều trò chơi hấp dẫn.', 12.2500, 109.1956, N'8:00 AM - 10:00 PM', 500000.00),
(2, N'Phố cổ Hội An', N'Khu phố cổ được UNESCO công nhận là di sản văn hóa thế giới.', 15.8800, 108.3380, N'6:00 AM - 9:00 PM', 120000.00),
(3, N'Bãi Sao', N'Bãi biển đẹp nhất Phú Quốc với nước biển trong xanh.', 10.2910, 103.9168, N'6:00 AM - 6:00 PM', 0.00),
(4, N'Chợ tình Sa Pa', N'Một trong những nét văn hóa đặc sắc của người dân tộc.', 22.3270, 104.0225, N'8:00 AM - 6:00 PM', 0.00),
(5, N'Tượng đài Chúa Kitô', N'Tượng đài lớn ở Vũng Tàu, điểm check-in nổi tiếng.', 10.3543, 107.0617, N'6:00 AM - 6:00 PM', 0.00);
GO

INSERT INTO Discounts (CODE, DESCIPTION, DISCOUNT_TYPE, DISCOUNT_VALUE, START_DATE, END_DATE, MIN_BOOKING_VALUE, STATUS) VALUES
('DC15', N'Giảm giá 15% cho khách hàng đặt phòng 2 đêm.', N'Tiền', 15, GETDATE(), DATEADD(MONTH, 1, GETDATE()), 2000000, N'Active');
GO
INSERT INTO Discounts (CODE, DESCIPTION, DISCOUNT_TYPE, DISCOUNT_VALUE, START_DATE, END_DATE, MIN_BOOKING_VALUE, STATUS) VALUES
('DC25', N'Giảm giá 25% cho nhóm từ 10 người trở lên.', N'Tiền', 25, GETDATE(), DATEADD(MONTH, 2, GETDATE()), 5000000, N'Active');
GO
INSERT INTO Discounts (CODE, DESCIPTION, DISCOUNT_TYPE, DISCOUNT_VALUE, START_DATE, END_DATE, MIN_BOOKING_VALUE, STATUS) VALUES
('DC30', N'Giảm giá 30% cho khách hàng VIP.', N'Tiền', 30, GETDATE(), DATEADD(MONTH, 3, GETDATE()), 1000000, N'Active');
GO
INSERT INTO Discounts (CODE, DESCIPTION, DISCOUNT_TYPE, DISCOUNT_VALUE, START_DATE, END_DATE, MIN_BOOKING_VALUE, STATUS) VALUES
('DC40', N'Giảm giá 40% cho những ngày cuối tuần.', N'Tiền', 40, GETDATE(), DATEADD(MONTH, 1, GETDATE()), 3000000, N'Active');
GO
INSERT INTO Discounts (CODE, DESCIPTION, DISCOUNT_TYPE, DISCOUNT_VALUE, START_DATE, END_DATE, MIN_BOOKING_VALUE, STATUS) VALUES
('DC50', N'Giảm giá 50% cho lần đặt phòng đầu tiên.', N'Tiền', 50, GETDATE(), DATEADD(MONTH, 1, GETDATE()), 1000000, N'Active');
GO


INSERT INTO Customers (USER_ID, FULL_NAME, PHONE_NUMBER, ADDRESS, DATE_OF_BIRTH, NATIONALITY, VIP_STATUS) VALUES
(1, 'John Doe', '0123456789', '123 Main St, City, Country', '1990-01-01', 'United States', 'Gold'),
(2, 'Jane Smith', '0987654321', '456 Park Ave, City, Country', '1985-05-15', 'France', 'Silver'),
(3, 'Mike Jones', '0112233445', '789 Oak St, City, Country', '1992-10-30', 'Canada', 'Regular');

INSERT INTO Reviews (CUSTOMER_ID, HOTEL_ID, RATING, REVIEW_DATE, COMMENTS) VALUES
('KH90US001', 'H001', 5, DEFAULT, 'Excellent stay, highly recommended!'),
('KH85GB002', 'H002', 4, DEFAULT, 'Very nice hotel, but service could be improved.'),
('KH92CA003', 'H003', 3, DEFAULT, 'Average experience, not what I expected.');

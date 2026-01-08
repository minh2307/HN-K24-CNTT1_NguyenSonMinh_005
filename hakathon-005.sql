-- NHẬP MÔN CSDL MYSQL - Đề 005

create database hakathon;
use hakathon;

-- PHẦN 1

create table creator (
	creator_id varchar(5) not null primary key,
    creator_name varchar(100) not null,
    creator_email varchar(100) not null unique,
    creator_phone varchar(15) not null unique,
    creator_platform varchar(50) not null
);

create table Studio (
	studio_id varchar(5) not null primary key,
	studio_name varchar(100) not null,
    studio_location varchar(100) not null,
	hourly_price decimal(10,2) not null,
	studio_status varchar(20) not null
);

create table LiveSession (
	session_id int auto_increment not null primary key,
    creator_id varchar(5) not null,
    studio_id varchar(5) not null,
    session_date date not null,
    duration_hours int not null,
	foreign key (creator_id) references creator(creator_id),
	foreign key (studio_id) references studio(studio_id)
);

create table payment (
	payment_id int auto_increment not null primary key,
	session_id int not null,
	payment_method varchar(50) not null,
	payment_amount decimal(10,2) not null,
	payment_date date not null,
    foreign key (session_id) references LiveSession(session_id)
);

insert into Creator (creator_id, creator_name, creator_email, creator_phone, creator_platform)
values ('CR01','Nguyen Van A','a@live.com','0901111111','Tiktok'),
		('CR02','Tran Thi B','b@live.com','0902222222','Youtube'),
        ('CR03','Le Minh C','c@live.com','0903333333','Facebook'),
        ('CR04','Pham Thi D','d@live.com','0904444444','Tiktok'),
		('CR05','Vu Hoang E','e@live.com','905555555','Shopee live');
        
insert into Studio (studio_id,studio_name,studio_location,hourly_price,studio_status)
values ('ST01','Studio A','Ha Noi',20.00,'Available'),
		('ST02','Studio B','HCM',25.00,'Available'),
		('ST03','Studio C','Danang',30.00,'Booked'),
		('ST04','Studio D','Ha Noi',22.00,'Available'),
		('ST05','Studio E','Can Tho',18.00,'Maintenance');
        
insert into LiveSession (session_id,creator_id,studio_id,session_date,duration_hours)
values (1,'CR01','ST01','2025-05-01',3),
		(2,'CR02','ST02','2025-05-02',4),
		(3,'CR03','ST03','2025-05-03',2),
		(4,'CR01','ST04','2025-05-04',5),
		(5,'CR05','ST02','2025-05-05',1);
        
insert into Payment (payment_id,session_id,payment_method,payment_amount,payment_date)
values (1,1,'Cash',60.00,'2025-05-01'),
		(2,2,'Credit Card',100.00,'2025-05-02'),
		(3,3,'Bank Transfer',60.00,'2025-05-03'),
		(4,4,'Credit Card',110.00,'2025-05-04'),
		(5,5,'Cash',25.00,'2025-05-05');

-- Cập nhật creator_platform của creator CR03 thành "YouTube"
update Creator 
set creator_platform  = 'YouTube'
where creator_id = 'CR03';

-- Do studio ST05 hoạt động trở lại, cập nhật studio_status = 'Available' và giảm hourly_price 10%
update Studio 
set studio_status  = 'Available'
where studio_id = 'ST05';

update Studio 
set hourly_price = hourly_price * 0.9
where studio_id = 'ST05';

-- Xóa các payment có payment_method = 'Cash' và payment_date trước ngày 2025-05-03
delete from Payment 
where payment_method = 'Cash' and payment_date < '2025-05-03';

-- PHẦN 2

-- Liệt kê studio có studio_status = 'Available' và hourly_price > 20
select * from Studio
where studio_status = 'Available' and hourly_price > 20;

-- Lấy thông tin creator (creator_name, creator_phone) có nền tảng là TikTok
select creator_name, creator_phone from creator
where creator_platform = 'TikTok';

-- Hiển thị danh sách studio gồm studio_id, studio_name, hourly_price sắp xếp theo giá thuê giảm dần
select studio_id, studio_name, hourly_price from studio
order by hourly_price desc;

-- Lấy 3 payment đầu tiên có payment_method = 'Credit Card'
select * from payment
where payment_method = 'Credit Card'
limit 3;

-- Hiển thị danh sách creator gồm creator_id, creator_name bỏ qua 2 bản ghi đầu và lấy 2 bản ghi tiếp theo
select creator_id, creator_name from creator
limit 2 offset 2;

-- PHẦN 3

-- Hiển thị danh sách livestream gồm: session_id, creator_name, studio_name, duration_hours, payment_amount
select l.session_id, c.creator_name, s.studio_name, l.duration_hours, p.payment_amount 
from livesession l
join Creator c on c.creator_id = l.creator_id
join Studio s on s.studio_id = l.studio_id
join Payment p on p.session_id = l.session_id;

-- Liệt kê tất cả studio và số lần được sử dụng (kể cả studio chưa từng được thuê)
select s.studio_name, count(l.studio_id) as total_LiveSession from LiveSession l
right join Studio s on s.studio_id = l.studio_id
group by s.studio_name;

-- Tính tổng doanh thu theo từng payment_method
select payment_method, sum(payment_amount) as total_payment from Payment
group by payment_method;

-- Thống kê số session của mỗi creator chỉ hiển thị creator có từ 2 session trở lên
select c.creator_name, count(l.creator_id) as total_creatorSession from LiveSession l
join Creator c on c.creator_id = l.creator_id 
group by c.creator_name
having count(l.creator_id) >= 2;

-- Lấy studio có hourly_price cao hơn mức trung bình của tất cả studio
select * from Studio
where hourly_price > (select avg(hourly_price) from Studio);

-- Hiển thị creator_name, creator_email của những creator đã từng livestream tại Studio B
select creator_name, creator_email from LiveSession l
join Creator c on c.creator_id = l.creator_id
join Studio s on s.studio_id = l.studio_id
where s.studio_id = 'ST02';

-- Hiển thị báo cáo tổng hợp gồm: session_id, creator_name, studio_name, payment_method, payment_amount
select l.session_id, c.creator_name, s.studio_name, p.payment_method,p.payment_amount 
from livesession l
join Creator c on c.creator_id = l.creator_id
join Studio s on s.studio_id = l.studio_id
join Payment p on p.session_id = l.session_id;

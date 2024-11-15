create database BlogDB

use BlogDB

-- Tables


create table Users (
    Id int identity(1,1) not null primary key,
    Username nvarchar(50) not null unique,
    FullName nvarchar(50) not null,
    Age int null,
    check (Age > 0 and Age < 150)
)

create table Blogs (
    Id int identity(1,1) not null primary key,
    Title nvarchar(50) not null,
    Description nvarchar(500) not null,
    UserId int null foreign key references Users(Id),
    CategoryId int null foreign key references Categories(Id)   
)

create table Categories (
    Id int identity(1,1) not null primary key,
    Name nvarchar(50) not null unique
)

create table BlogTags (
    Id int identity(1,1) not null primary key,
    BlogId int null foreign key references Blogs(Id),
    TagId int null foreign key references Tags(Id)
)

create table Comments (
    Id int identity(1,1) not null primary key,
    Content nvarchar(250) not null,
    UserId int null foreign key references Users(Id),
    BlogsId int null foreign key references Blogs(Id) 
)

create table Tags (
    Id int identity(1,1) not null primary key,
    Name nvarchar(50) not null unique
)

--Insert

-- Insert data into Users
insert into Users values 
('Elvin123', 'Elvin Məmmədov', 25),
('Gunel85', 'Günel Quliyeva', 30),
('Nijat90', 'Nicat Əliyev', 28),
('Leyla_88', 'Leyla İsmayılova', 27),
('Murad_Az', 'Murad Həsənov', 35)

-- Insert data into Categories
insert into Categories 
values 
('Texnologiya'),
('Mədəniyyət'),
('İdman'),
('Təhsil'),
('Səyahət')

-- Insert data into Blogs
insert into Blogs 
values 
('Müasir Texnologiyalar', 'Texnologiyanın inkişafı haqqında maraqlı faktlar.', 1, 1),
('Azərbaycan Xalçaları', 'Mədəniyyətimizin incisi olan xalçalar haqqında.', 2, 2),
('Futbol Çempionatı', 'Futbol üzrə yerli çempionatın nəticələri.', 3, 3),
('Distant Təhsil', 'Onlayn təhsil sisteminin üstünlükləri.', 4, 4),
('Qəbələyə Səyahət', 'Qəbələ bölgəsinin tarixi yerləri haqqında.', 5, 5)

-- Insert data into Tags
insert into Tags 
values 
('İnnovasiya'),
('Ənənə'),
('Komanda'),
('Təlim'),
('Təbiət')

-- Insert data into BlogTags
insert into BlogTags 
values 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)

-- Insert data into Comments
insert into Comments
values 
('Çox maraqlı məqalədir, təşəkkürlər!', 1, 1),
('Xalça sənəti haqqında gözəl məlumat.', 2, 2),
('Komanda oyunları haqqında əla yazıdır.', 3, 3),
('Onlayn dərslər üçün yeni tətbiqlərdən danışa bilərsinizmi?', 4, 4),
('Qəbələyə getməyi planlaşdırıram, faydalı məlumatdır.', 5, 5)





-- Views
create view GetInfoUsersBlogs 
as
select 
    Blogs.Title as BlogTitle, 
    Users.Username as Username, 
    Users.FullName as FullName 
from Users
join Blogs on Users.Id = Blogs.UserId

create view GetBlogsInfo 
as
select 
    Blogs.Title as BlogTitle, 
    Categories.Name as Category 
from Blogs
join Categories on Blogs.CategoryId = Categories.Id

select * from GetInfoUsersBlogs

-- Functions
alter function GetUserBlogs (@Id int) 
returns table 
as 
return (
    select 
        Title as BlogTitle, 
        Description as BlogDescription
    from Blogs
    where UserId = @Id
)

select * from GetUserBlogs(2)


create function GetBlogCountByCategory (@Id int)
returns table
as
return (
    select 
        Categories.Name as Category, 
        count(*) as BlogCounts 
    from Blogs
    join Categories 
        on Blogs.CategoryId = Categories.Id
    where Categories.Id = @Id
    group by Categories.Name
)

select * from GetBlogCountByCategory(2)

create procedure GetUserBlog @Id int 
as
select 
    Users.FullName as FullName, 
    Blogs.Title as BlogTitle 
from Users
join Blogs on Users.Id = Blogs.UserId
where Users.Id = @Id

exec GetUserBlog 4

create procedure GetUserComment @Id int 
as
select 
    Users.FullName as FullName, 
    Comments.Content as Comment 
from Users
join Comments on Users.Id = Comments.UserId
where Users.Id = @Id


exec GetUserComment 5
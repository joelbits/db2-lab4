DROP TABLE IF EXISTS departments;

create table departments (
	id 			int primary key auto_increment,
	department 	varchar(50),
	manager 	int
);

insert into departments (department, manager) values ('Accounting', 333);
insert into departments (department, manager) values ('Business Development', 56);
insert into departments (department, manager) values ('Support', 111);
insert into departments (department, manager) values ('Training', 295);
insert into departments (department, manager) values ('Design', 328);
insert into departments (department, manager) values ('Human Resources', 33);
insert into departments (department, manager) values ('Services', 204);
insert into departments (department, manager) values ('Sales', 307);
insert into departments (department, manager) values ('Research', 293);
insert into departments (department, manager) values ('Legal', 385);
insert into departments (department, manager) values ('Product Management', 415);
insert into departments (department, manager) values ('Engineering', 377);
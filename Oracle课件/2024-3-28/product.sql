prompt PL/SQL Developer import file
prompt Created on 2024年3月29日 by EDY
set feedback off
set define off
prompt Creating CUSTOMER...
create table CUSTOMER
(
  clientno  VARCHAR2(10),
  clientnam VARCHAR2(20),
  area      VARCHAR2(10),
  remark    VARCHAR2(10)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating ORDER1...
create table ORDER1
(
  clientno      VARCHAR2(10),
  clientnam     VARCHAR2(20),
  artno         VARCHAR2(20),
  delivery_time VARCHAR2(10),
  total         NUMBER
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating PRODUCT...
create table PRODUCT
(
  sno       NUMBER,
  artno     VARCHAR2(20),
  unitprice NUMBER,
  reportery NUMBER,
  remark    VARCHAR2(20)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Disabling triggers for CUSTOMER...
alter table CUSTOMER disable all triggers;
prompt Disabling triggers for ORDER1...
alter table ORDER1 disable all triggers;
prompt Disabling triggers for PRODUCT...
alter table PRODUCT disable all triggers;
prompt Deleting PRODUCT...
delete from PRODUCT;
commit;
prompt Deleting ORDER1...
delete from ORDER1;
commit;
prompt Deleting CUSTOMER...
delete from CUSTOMER;
commit;
prompt Loading CUSTOMER...
insert into CUSTOMER (clientno, clientnam, area, remark)
values ('A05', '赵六', '深圳', null);
insert into CUSTOMER (clientno, clientnam, area, remark)
values ('A06', '田七', '杭州', null);
insert into CUSTOMER (clientno, clientnam, area, remark)
values ('A01', '张三', '北京', null);
insert into CUSTOMER (clientno, clientnam, area, remark)
values ('A02', '李四', '上海', null);
insert into CUSTOMER (clientno, clientnam, area, remark)
values ('A03', '王艳', '广州', null);
insert into CUSTOMER (clientno, clientnam, area, remark)
values ('A04', '肖五', '长沙', null);
commit;
prompt 6 records loaded
prompt Loading ORDER1...
insert into ORDER1 (clientno, clientnam, artno, delivery_time, total)
values ('A01', '张三', 'MK2017', '3-10', 300);
insert into ORDER1 (clientno, clientnam, artno, delivery_time, total)
values ('A01', '张三', 'BLU31', '3-10', 400);
insert into ORDER1 (clientno, clientnam, artno, delivery_time, total)
values ('A01', '张三', '4007BW5', '3-10', 260);
insert into ORDER1 (clientno, clientnam, artno, delivery_time, total)
values ('A02', '李四', '4007BW5', '4-10', 230);
insert into ORDER1 (clientno, clientnam, artno, delivery_time, total)
values ('A02', '李四', 'BLU31', '3-10', 110);
insert into ORDER1 (clientno, clientnam, artno, delivery_time, total)
values ('A03', '王艳', 'MK2017', '2-10', 176);
insert into ORDER1 (clientno, clientnam, artno, delivery_time, total)
values ('A03', '王艳', '4007BW5', '2-10', 160);
insert into ORDER1 (clientno, clientnam, artno, delivery_time, total)
values ('A03', '王艳', 'A8001', '2-10', 320);
insert into ORDER1 (clientno, clientnam, artno, delivery_time, total)
values ('A04', '肖五', 'MK2017', '1-10', 230);
insert into ORDER1 (clientno, clientnam, artno, delivery_time, total)
values ('A04', '肖五', 'BLU31', '1-10', 412);
insert into ORDER1 (clientno, clientnam, artno, delivery_time, total)
values ('A04', '肖五', '4007BW5', '1-10', 460);
insert into ORDER1 (clientno, clientnam, artno, delivery_time, total)
values ('A04', '肖五', 'A8001', '1-10', 120);
commit;
prompt 12 records loaded
prompt Loading PRODUCT...
insert into PRODUCT (sno, artno, unitprice, reportery, remark)
values (1, 'MK2017', 120, 400, null);
insert into PRODUCT (sno, artno, unitprice, reportery, remark)
values (2, 'BLU31', 140, 2000, null);
insert into PRODUCT (sno, artno, unitprice, reportery, remark)
values (3, '4007BW5', 125, 100, null);
insert into PRODUCT (sno, artno, unitprice, reportery, remark)
values (4, 'A8001', 168, 330, null);
commit;
prompt 4 records loaded
prompt Enabling triggers for CUSTOMER...
alter table CUSTOMER enable all triggers;
prompt Enabling triggers for ORDER1...
alter table ORDER1 enable all triggers;
prompt Enabling triggers for PRODUCT...
alter table PRODUCT enable all triggers;
set feedback on
set define on
prompt Done.

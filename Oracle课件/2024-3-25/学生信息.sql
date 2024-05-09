prompt PL/SQL Developer import file
prompt Created on 2022年12月3日 by Administrator
set feedback off
set define off
prompt Creating COURSE...
create table COURSE
(
  cno   VARCHAR2(10) not null,
  cname VARCHAR2(20),
  tno   VARCHAR2(20) not null
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
alter table COURSE
  add constraint PK_COURSE primary key (CNO, TNO)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating SC...
create table SC
(
  sno   VARCHAR2(10) not null,
  cno   VARCHAR2(10) not null,
  score NUMBER(4,2)
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
alter table SC
  add constraint PK_SC primary key (SNO, CNO)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating STUDENT...
create table STUDENT
(
  sno   VARCHAR2(10) not null,
  sname VARCHAR2(20),
  sage  NUMBER(2),
  ssex  VARCHAR2(5)
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
alter table STUDENT
  add primary key (SNO)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating TEACHER...
create table TEACHER
(
  tno   VARCHAR2(10) not null,
  tname VARCHAR2(20)
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
alter table TEACHER
  add primary key (TNO)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Disabling triggers for COURSE...
alter table COURSE disable all triggers;
prompt Disabling triggers for SC...
alter table SC disable all triggers;
prompt Disabling triggers for STUDENT...
alter table STUDENT disable all triggers;
prompt Disabling triggers for TEACHER...
alter table TEACHER disable all triggers;
prompt Deleting TEACHER...
delete from TEACHER;
commit;
prompt Deleting STUDENT...
delete from STUDENT;
commit;
prompt Deleting SC...
delete from SC;
commit;
prompt Deleting COURSE...
delete from COURSE;
commit;
prompt Loading COURSE...
insert into COURSE (cno, cname, tno)
values ('c001', 'J2SE', 't002');
insert into COURSE (cno, cname, tno)
values ('c002', 'Java Web', 't002');
insert into COURSE (cno, cname, tno)
values ('c003', 'SSH', 't001');
insert into COURSE (cno, cname, tno)
values ('c004', 'Oracle', 't001');
insert into COURSE (cno, cname, tno)
values ('c005', 'SQL SERVER 2005', 't003');
insert into COURSE (cno, cname, tno)
values ('c006', 'C#', 't003');
insert into COURSE (cno, cname, tno)
values ('c007', 'JavaScript', 't002');
insert into COURSE (cno, cname, tno)
values ('c008', 'DIV+CSS', 't001');
insert into COURSE (cno, cname, tno)
values ('c009', 'PHP', 't003');
insert into COURSE (cno, cname, tno)
values ('c010', 'EJB3.0', 't002');
commit;
prompt 10 records loaded
prompt Loading SC...
insert into SC (sno, cno, score)
values ('s001', 'c001', 78.9);
insert into SC (sno, cno, score)
values ('s002', 'c001', 80.9);
insert into SC (sno, cno, score)
values ('s003', 'c001', 81.9);
insert into SC (sno, cno, score)
values ('s004', 'c001', 60.9);
insert into SC (sno, cno, score)
values ('s001', 'c002', 82.9);
insert into SC (sno, cno, score)
values ('s002', 'c002', 72.9);
insert into SC (sno, cno, score)
values ('s003', 'c002', 81.9);
insert into SC (sno, cno, score)
values ('s001', 'c003', 59);
commit;
prompt 8 records loaded
prompt Loading STUDENT...
insert into STUDENT (sno, sname, sage, ssex)
values ('s001', '张三', 23, '男');
insert into STUDENT (sno, sname, sage, ssex)
values ('s002', '李四', 23, '男');
insert into STUDENT (sno, sname, sage, ssex)
values ('s003', '吴鹏', 25, '男');
insert into STUDENT (sno, sname, sage, ssex)
values ('s004', '琴沁', 20, '女');
insert into STUDENT (sno, sname, sage, ssex)
values ('s005', '王丽', 20, '女');
insert into STUDENT (sno, sname, sage, ssex)
values ('s006', '李波', 21, '男');
insert into STUDENT (sno, sname, sage, ssex)
values ('s007', '刘玉', 21, '男');
insert into STUDENT (sno, sname, sage, ssex)
values ('s008', '萧蓉', 21, '女');
insert into STUDENT (sno, sname, sage, ssex)
values ('s009', '陈萧晓', 23, '女');
insert into STUDENT (sno, sname, sage, ssex)
values ('s010', '陈美', 22, '女');
commit;
prompt 10 records loaded
prompt Loading TEACHER...
insert into TEACHER (tno, tname)
values ('t001', '刘阳');
insert into TEACHER (tno, tname)
values ('t002', '谌燕');
insert into TEACHER (tno, tname)
values ('t003', '胡明星');
commit;
prompt 3 records loaded
prompt Enabling triggers for COURSE...
alter table COURSE enable all triggers;
prompt Enabling triggers for SC...
alter table SC enable all triggers;
prompt Enabling triggers for STUDENT...
alter table STUDENT enable all triggers;
prompt Enabling triggers for TEACHER...
alter table TEACHER enable all triggers;
set feedback on
set define on
prompt Done.

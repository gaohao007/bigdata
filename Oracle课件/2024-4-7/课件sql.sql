--查询员工的工资最高的员工的信息
SELECT * FROM(
SELECT * FROM emp ORDER BY sal DESC) WHERE ROWNUM=1;

--创建一个视图，保存员工工资降序排序后的结果
CREATE OR REPLACE VIEW view_emp_sal
AS
SELECT * FROM  emp ORDER BY sal DESC;
SELECT * FROM view_emp_sal WHERE ROWNUM=1;
SELECT * FROM view_emp_sal WHERE ROWNUM<=3;
--将视图中的7369员工共的工资上调20%
UPDATE view_emp_sal SET sal=sal*1.2 WHERE empno=7369;

--创建一个视图，用来隐藏员工的工资和奖金
CREATE OR REPLACE VIEW View_Emp
AS
SELECT empno,ename,job,mgr,hiredate,deptno FROM emp;

SELECT * FROM View_Emp;


--创建一个视图，计算每一个部门的平均工资
CREATE OR REPLACE VIEW view_sal(dno,avg_sal)
AS
SELECT deptno,AVG(sal) FROM emp GROUP BY deptno;

SELECT * FROM view_sal;
--有聚合函数的视图是不允许修改。
--UPDATE view_sal SET avg_sal=3000 WHERE dno=20


--创建视图，将员工表和部门表进行关联
CREATE OR REPLACE VIEW view_e_d
AS
SELECT e.*,dname,loc FROM emp e JOIN dept d ON e.deptno=d.deptno;

SELECT * FROM view_e_d;

--修改7369员工的工资和奖金
UPDATE view_e_d SET sal=1000,comm=1000 WHERE empno=7369;
--修改7369员工的工资和部门名称（不允许直接修改）
--UPDATE view_e_d SET sal=1000,dname='销售部' WHERE empno=7369;



--创建一个物化视图，用来保存部门表信息
CREATE MATERIALIZED VIEW mv_dept 
AS 
SELECT * FROM dept;

SELECT * FROM mv_dept;
--添加数据
INSERT  INTO dept VALUES(80,'zzz','mmmmmm');
--手动同步数据
BEGIN
  dbms_mview.refresh('mv_dept','C');
END;


--创建一个物化视图，用来保存部门表信息,一开始并不需要同步数据
CREATE MATERIALIZED VIEW mv_dept1 
BUILD DEFERRED 
REFRESH COMPLETE
ON COMMIT
AS 
SELECT * FROM dept;
SELECT * FROM mv_dept1;
--手动同步数据
BEGIN
  dbms_mview.refresh('mv_dept1','F');
END;
--添加数据
INSERT  INTO dept VALUES(81,'dddd','tttttt');
--提交事务
COMMIT;

--创建一个物化视图，用来保存部门表信息,每隔一分钟同步一次数据
CREATE MATERIALIZED VIEW mv_dept2 
REFRESH COMPLETE
START WITH SYSDATE NEXT SYSDATE+1/24/60
AS 
SELECT * FROM dept;
DROP MATERIALIZED VIEW mv_dept2;



SELECT * FROM mv_dept2;
--添加数据
INSERT  INTO dept VALUES(83,'kkkkk','ooooo');
UPDATE dept SET dname='pppppp' WHERE deptno=80;
DELETE FROM dept WHERE deptno=82;


--创建视图日志
CREATE MATERIALIZED VIEW LOG ON dept;
SELECT * FROM mlog$_dept;

DROP MATERIALIZED VIEW LOG ON dept;

DROP MATERIALIZED VIEW mv_dept1;



--创建一个默认序列：
CREATE SEQUENCE seq_2;

--创建一个序列，增量10
CREATE SEQUENCE seq_3
START WITH 10
INCREMENT BY 10
MINVALUE 10
MAXVALUE 100000000000000000000
CACHE 10


--查询当前的序列号
SELECT seq_2.currval FROM dual;

--产生一个数字
SELECT seq_2.nextval FROM dual;

SELECT * FROM good;
INSERT INTO good VALUES(seq_3.nextval,'ww');

--创建一个触发器，监控good表的操作情况，将他的操作写入到一张日志表中
--创建一张日志表
CREATE TABLE good_log(oper_type VARCHAR2(20),oper_date DATE);
--创建触发器
CREATE OR REPLACE TRIGGER tri_good
BEFORE 
INSERT OR UPDATE OR DELETE 
ON good
--声明变量
DECLARE
oper_type VARCHAR2(20);
BEGIN
  --判断当前的操作类型
  IF inserting THEN
    oper_type:='插入';
  ELSIF updating THEN
    oper_type:='更新';
  ELSIF deleting THEN
    oper_type:='删除';
  END IF;
  --将数据添加到日志表
  INSERT INTO good_log VALUES(oper_type,SYSDATE);
END;

SELECT * FROM good;
--删除数据
DELETE FROM good WHERE ID>50;

--删除触发器
DROP TRIGGER tri_good;
SELECT * FROM good_log;


--编写一个用户触发器，用来监控scott用户下面的所有的对象的操作，并且将数据记录到日志表中。
CREATE TABLE user_log1(
 oper_type VARCHAR2(20),
 oper_object VARCHAR2(100),
 oper_event VARCHAR2(20),
 oper_date DATE,
 oper_user VARCHAR2(20)
);
--创建触发器
CREATE OR REPLACE TRIGGER tri_user
AFTER
CREATE OR ALTER OR DROP OR TRUNCATE
ON scott.schema      --schema代表的是用户模式
BEGIN
  --添加数据
  INSERT INTO user_log1 VALUES(
       ora_dict_obj_type,---记录的是操作的对象类型
       ora_dict_obj_name,--记录操作的对象的名称
       ora_sysevent,--记录当前操作的事件
       sysdate,
       ora_login_user  --记录当前登录的用户   
  );
END;

SELECT * FROM user_log1;

--清空
TRUNCATE TABLE good;


--编写一个触发器实现good表中主键自增长的功能
CREATE OR REPLACE TRIGGER tri_insert 
BEFORE 
INSERT
ON good
FOR EACH ROW
  BEGIN
    --生成一个序列添加到新的一行数据的主键位置
    --:new.id:=seq_3.nextval;
    SELECT seq_3.nextval INTO :new.id FROM dual;
END;

--添加数据
INSERT INTO good(NAME) VALUES('qq');
SELECT * FROM good;

--编写一个触发器，监控部门表中删除的每一行数据，将删除的数据打印出来
CREATE  OR REPLACE TRIGGER tri_delete
AFTER 
DELETE
ON dept
FOR EACH ROW
  BEGIN
    dbms_output.put_line('删除的数据：'||:old.deptno||','||:OLD.dname||','||:old.loc);
 END;

SELECT * FROM dept;
DELETE FROM dept WHERE deptno>=80;
DELETE FROM dept WHERE deptno >20 AND deptno<30;

--修改7369员工的工资和部门名称（不允许直接修改）
--UPDATE view_e_d SET sal=1000,dname='销售部' WHERE empno=7369;
--编写一个替换触发器来修改视图中多张基表的数据
CREATE OR REPLACE TRIGGER tri_instead
INSTEAD OF
UPDATE
ON view_e_d
FOR EACH ROW
  BEGIN
    --修改员工表工资
    UPDATE emp SET sal=:new.sal WHERE empno=:new.empno;
    --修改部门表名称
    UPDATE dept SET dname=:new.dname WHERE deptno=:new.deptno;
END;

UPDATE view_e_d SET sal=1000,dname='销售部' WHERE empno=7369;
SELECT * FROM view_e_d ;

--编写一个触发器，将dept表中的修改信息记录下来
CREATE OR REPLACE TRIGGER tri_update
AFTER
UPDATE
ON dept
FOR EACH ROW
  BEGIN
    dbms_output.put_line('修改前：'||:old.dname||',修改后：'||:new.dname);
 END;

SELECT * FROM dept;
UPDATE dept SET dname='销售部' WHERE deptno=11;


SELECT * FROM user_t;
SELECT * FROM user_t1;
TRUNCATE TABLE user_t1;
INSERT INTO user_t1 SELECT * FROM user_t;

--编写一个触发器，在修改user_t表的同时将user_t1表中的对应的数据也修改为最新的数据
CREATE OR REPLACE TRIGGER tri_t
AFTER
UPDATE
ON User_T
FOR EACH ROW
  BEGIN
    UPDATE user_t1 SET NAME=:new.name,age=:new.age,last_date=:new.last_date WHERE ID=:new.id;
 END;

--修改user_t中的数据
UPDATE user_t SET NAME='小白白' WHERE ID=4;

SELECT * FROM rms_olt;

--一、RMS_OLT表发现有ZH_LABEL相同的重复数据，如何只保留一条创建日期（create_date）最新的数据。
DELETE FROM rms_olt r WHERE NOT EXISTS(
SELECT zh_label, MAX(create_date) FROM rms_olt GROUP BY zh_label
HAVING zh_label=r.zh_label AND MAX(create_date)=r.CREATE_date)



--编写一个存储过程
CREATE OR REPLACE PROCEDURE pro_test
IS
--声明一个游标
 CURSOR cur_t IS
  SELECT a.resclassenname,a.dstablename FROM m_resclass a JOIN m_resclassdiagram b ON b.resclassdiagramid=a.classdiagramtype
  WHERE b.resclassdiagramcnname='无线网';
BEGIN
  FOR t IN cur_t LOOP
    --在属性表中添加一行数据：insert into
    --模型表m_resclass
    --专业表m_resclassdiagram
    INSERT INTO m_resattribute VALUES(t.resclassenname,'emos_flag','标志',NULL,'varchar2(20)');
    --在物理表中添加字段：alter table 
    EXECUTE IMMEDIATE 'alter table :tn add (emos_flag varchar2(20))'
    USING t.dstablename;
  END LOOP;
END;
SELECT dbms_random.value FROM dual;

SELECT abs(mod(dbms_random.random,100)) FROM dual;
--从员工表中随机获取一行数据
SELECT * FROM(
SELECT * FROM emp ORDER BY dbms_random.value) WHERE ROWNUM=1;









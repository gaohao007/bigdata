SELECT * FROM emp WHERE sal=3000;

SELECT * FROM student;

UPDATE student SET sno=REPLACE(sno,'s');

SELECT * FROM student WHERE  sno=001;


SELECT * FROM range_table;
--在分区表上创建本地索引
CREATE INDEX local_index ON range_table(NAME) LOCAL;
DROP INDEX local_index;

--在分区表上创建一个全局索引
DROP INDEX global_index;
CREATE INDEX global_index ON range_table(NAME) GLOBAL
PARTITION BY HASH(NAME)
(PARTITION index_p1,
PARTITION index_p2);


--查询入职日期为2023年的员工的信息
--原来方案：导致索引失效
SELECT * FROM emp WHERE to_char(hiredate,'yyyy')=2023;
--创建一个索引
CREATE INDEX hiredate_ind ON emp(hiredate);
--优化之后的方案：索引生效
SELECT *
  FROM EMP
 WHERE HIREDATE BETWEEN TO_DATE('2023-1-1', 'yyyy-mm-dd') AND
       TO_DATE('2023-12-31', 'yyyy-mm-dd');


SELECT * FROM emp WHERE sal=3000-500;
SELECT  * FROM emp WHERE empno>7369;


--SELECT * FROM emp WHERE sal<>3000;

--查询工资大于所在部门的平均工资的员工
SELECT * FROM emp e WHERE sal>(SELECT AVG(sal) FROM emp WHERE deptno=e.deptno)



--生成执行计划
EXPLAIN PLAN 
FOR SELECT * FROM emp WHERE sal=3000-500;
--查看执行计划
SELECT * FROM TABLE(dbms_xplan.display);

SELECT sname,sage FROM student WHERE sname='张三';
SELECT * FROM student WHERE sname='张三';
SELECT COUNT(sname) FROM student;

DROP INDEX index_t;
CREATE INDEX index_name ON student(sname,sage);


SELECT ROWID FROM emp;
SELECT * FROM emp WHERE ROWID='AAAWG7AAEAAAM5/AAA'


SELECT  * FROM emp e JOIN dept d ON e.deptno=d.deptno;

--修改执行计划进行全表扫描   +full(表名)
SELECT /*+full(s)*/ sname,sage FROM student s WHERE sname='张三';
--修改执行计划中使用的索引   +index(表名,索引名,索引名,...)
SELECT /*+index(emp,INDX_NAME_JOB)*/ * FROM emp WHERE ename='SCOTT';

--修改表的连接方式排序合并连接： +use_merge(表名,表名)
SELECT /*+use_merge(e,d)*/  * FROM emp e JOIN dept d ON e.deptno=d.deptno;

--修改表的连接方式为循环嵌套：+use_nl(表名,表名)
SELECT /*+use_nl(e,d)*/  * FROM emp e JOIN dept d ON e.deptno=d.deptno;

--修改使用hash join方式连接：use_hash(表名,表名)
SELECT /*+use_hash(e,d)*/  * FROM emp e JOIN dept d ON e.deptno=d.deptno;


SELECT a.*,LAG(天数,1,0)OVER(ORDER BY sdate) 减去天数 from(
SELECT s.*,LEAD(sdate,1,to_date('2023-3-31','yyyy-mm-dd')) OVER(ORDER BY sdate)-sdate 天数 FROM shiti s)
a;

DECLARE
 --定义游标
  CURSOR cur_t IS
SELECT a.*,LAG(天数,1,0)OVER(ORDER BY sdate) 减去天数 from(
SELECT s.*,LEAD(sdate,1,to_date('2023-3-31','yyyy-mm-dd')) OVER(ORDER BY sdate)-sdate 天数 FROM shiti s)
a;
--定义变量保存累计值
lj NUMBER:=0;
--定义变量保存当日预估值
yg NUMBER:=0;
--保存累计的天数
ljts NUMBER:=0;
BEGIN
  FOR t IN cur_t LOOP
    ljts:=t.减去天数+ljts;
    --计算当日预估
    yg:=(t.ys-lj)/(31-ljts);
    --循环天数
    FOR i IN 1..t.天数 LOOP
      --累计值
      lj:=lj+yg;
      dbms_output.put_line(to_char((t.sdate+i),'yyyymmdd')||',当日预估：'||round(yg,8)||',当月预估：'||round(lj,8));
    END LOOP;
  END LOOP;
END;


/*
作业1.：创建一个程序包，然后封装一下存储过程和函数。
1.存储过程：以部门编号为参数，输出入职日期最早的3个员工的姓名，编号和职位
2.函数：以员工号为参数，返回该员工所在的部门的平均工资。
3.存储过程，以员工号和部门号作为参数，修改员工所在的部门为所输入的部门号。
如果修改成功，则显示“员工由……号部门调入调入……号部门”；如果不存在该员工，
则显示“员工号不存在，请输入正确的员工号。”；如果不存在该部门，
则显示“该部门不存在，请输入正确的部门号。”。
4.存储过程：以一个整数为参数，输入工资最高的前几个（参数值）员工的信息。
然后对以上的存储过程和函数进行调用测试。
*/

--定义规范
CREATE OR REPLACE PACKAGE pack_zy
IS
--声明一个游标类型
TYPE type_cursor IS REF CURSOR;
--声明存储过程
PROCEDURE pro_top3(dno IN NUMBER,emp_r OUT type_cursor);
--声明函数
FUNCTION fun_avg_sal(eno NUMBER) RETURN NUMBER;
--声明存储过程
PROCEDURE pro_update(eno NUMBER,dno NUMBER);
--声明存储过程
PROCEDURE pro_topn(n NUMBER,topn_emp OUT type_cursor);
END;


--创建主体
CREATE OR REPLACE PACKAGE body pack_zy
IS
--存储过程
PROCEDURE pro_top3(dno IN NUMBER,emp_r OUT type_cursor)
  IS
  BEGIN
    OPEN emp_r FOR SELECT * FROM(
    SELECT * FROM emp WHERE deptno=dno ORDER BY hiredate) WHERE ROWNUM<=3;
 END  pro_top3;
--函数
FUNCTION fun_avg_sal(eno NUMBER) RETURN NUMBER
  IS
  avg_sal NUMBER;
  BEGIN
  SELECT AVG(sal) INTO avg_sal FROM emp WHERE deptno=(SELECT deptno FROM emp WHERE empno=eno);
  --返回数据
  RETURN avg_sal;
END fun_avg_sal;
  
--存储过程
PROCEDURE pro_update(eno NUMBER,dno NUMBER)
  IS
  --定义变量
  cou NUMBER;
  d_no NUMBER;
  BEGIN
    SELECT COUNT(*) INTO cou FROM emp WHERE empno=eno;
    IF cou!=0 THEN
      --判断部门是否存在
      SELECT COUNT(*) INTO cou FROM dept WHERE deptno=dno;
      IF cou!=0 THEN
        --查询原来的部门号
        SELECT deptno INTO d_no FROM emp WHERE empno=eno;
        --都存在，执行更新操作
        UPDATE emp SET deptno=dno WHERE empno=eno;
        --打印数据
        dbms_output.put_line('员工从'||d_no||'部门调入到了'||dno||'部门！');
      ELSE
        dbms_output.put_line('该部门不存在');
      END IF;
    ELSE
      dbms_output.put_line('该员工不存在');
    END IF;
END pro_update;

--存储过程
PROCEDURE pro_topn(n NUMBER,topn_emp OUT type_cursor)
  IS
  BEGIN
  OPEN topn_emp FOR SELECT * FROM ( 
  SELECT * FROM emp ORDER BY sal DESC) WHERE ROWNUM<=n;
END pro_topn;
END;

--调用：
SELECT pack_zy.fun_avg_sal(7369) FROM dual;


DECLARE 
 --声明应用游标类型变量
 emps pack_zy.type_cursor;
 e emp%ROWTYPE;
 BEGIN
   pack_zy.pro_top3(20,emps);
   LOOP
     FETCH emps INTO e;
    EXIT WHEN emps%NOTFOUND;
    dbms_output.put_line(e.ename);
    END LOOP;
 END;
 
BEGIN
  pack_zy.pro_update(7369,99);
END;

DECLARE 
 --声明应用游标类型变量
 emps pack_zy.type_cursor;
 e emp%ROWTYPE;
 BEGIN
   pack_zy.pro_topn(5,emps);
   LOOP
     FETCH emps INTO e;
    EXIT WHEN emps%NOTFOUND;
    dbms_output.put_line(e.ename);
    END LOOP;
 END;





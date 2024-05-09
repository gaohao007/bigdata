--编写一个PL/SQL块来实现两个数字的商
--声明变量
DECLARE
  --声明变量a=10
  a NUMBER:=10;
  --声明变量b=20
  b number:=10;
  --声明一个变量c用来保存计算的商
  c NUMBER;
  --定义了一个字符串变量
  str VARCHAR2(20):='hello';
  --定义一个常量
  PI CONSTANT NUMBER:=3.14;
  --执行部分
  BEGIN
   -- PI:=4.14;   常量不允许修改
    a:=20;
    --20:=a    语法错误
    --计算商
    c:=a/b;
    --输出c
    dbms_output.put_line(c);
    --异常处理
    EXCEPTION
      WHEN zero_divide THEN
        dbms_output.put_line('除数不能为0');
  END;
  
 
--请用户输入一个半径，来计算圆形面积
--声明变量
DECLARE
 --声明变量保存用户输入的半径
 r NUMBER:=&r;
 --声明一个常量
 PI CONSTANT NUMBER:=3.14;
 --声明变量保存面积
 area NUMBER;
 BEGIN
   --计算
   area:=PI*POWER(r,2);
   --输出结果
   dbms_output.put_line('圆形的面积为:'||area);
 END;



--查询员工表中工号7369的员工的姓名和职位
DECLARE
 --声明变量
 e_name VARCHAR2(20);
 e_job VARCHAR2(20);
 BEGIN
   SELECT ename,job INTO e_name,e_job  FROM emp WHERE empno=7369;
   --输出
   dbms_output.put_line(e_name||','||e_job);
   --清除dept表中的数据
   --TRUNCATE TABLE dept;
END;
   
--使用%type类型
--查询员工表中工号7369的员工的姓名和职位
DECLARE
 --声明变量
 e_name emp.ename%TYPE;
 e_job emp.job%TYPE;
 BEGIN
   SELECT ename,job INTO e_name,e_job  FROM emp WHERE empno=7369;
   --输出
   dbms_output.put_line(e_name||','||e_job);
   --清除dept表中的数据
   --TRUNCATE TABLE dept;
END;

SELECT * FROM emp;

--查询7369员工的所有的信息
DECLARE
 --声明一个rowtype类型的变量
 r_emp emp%ROWTYPE;
 BEGIN
   SELECT * INTO r_emp FROM emp WHERE empno=7369;
   --输出数据
   dbms_output.put_line(r_emp.ename||','||r_emp.job||','||r_emp.sal);
END;


--查询员工表中工资最高的员工的信息

DECLARE
 --声明一个rowtype类型的变量
 r_emp emp%ROWTYPE;
 BEGIN
   SELECT empno,ename,job,mgr,hiredate,sal,comm,deptno INTO r_emp FROM (
   SELECT e.*,row_number()OVER(ORDER BY sal DESC) rn FROM emp e) WHERE rn=1;
   --输出数据
   dbms_output.put_line(r_emp.ename||','||r_emp.job||','||r_emp.sal);
END;
 

--查询员工表中7369的员工的姓名，职位，工资以及他所在部门的平均工资
DECLARE
  --定义一个记录类型
  TYPE type_emp IS RECORD(
   e_name emp.ename%TYPE,
   e_job emp.job%TYPE,
   e_sal emp.sal%TYPE,
   avg_sal NUMBER
  );
 --定义记录类型变量
  r_emp type_emp;
 BEGIN
   --SELECT ename,job,sal,(SELECT AVG(sal) FROM emp WHERE deptno=e.deptno) 平均工资 FROM emp e WHERE empno=7369;
   SELECT ename,job,sal,avg_sal INTO r_emp FROM(
   SELECT e.*,AVG(sal)OVER(PARTITION BY deptno) avg_sal FROM emp e)  WHERE empno=7369;
     --输出数据
   dbms_output.put_line(r_emp.e_name||','||r_emp.e_job||','||r_emp.e_sal||','||r_emp.avg_sal);
END;
  

SELECT * FROM emp;

--查询7369员工的职位，如果职位"PRESIDENT"则输出总裁，否则输出：员工
DECLARE
 e_job emp.job%TYPE;
 BEGIN
   SELECT job INTO e_job FROM emp WHERE empno=7839;
   --判断
   IF e_job='PRESIDENT' THEN
     dbms_output.put_line('总裁');
   ELSE
     dbms_output.put_line('员工');
   END IF;
END;


--输入一个员工的编号，查询出员工的职位，将职位显示为中文
DECLARE
  e_job emp.job%TYPE;
  BEGIN
    --查询数据
    SELECT job INTO e_job FROM emp WHERE empno=&eno;
    --判断职位
    IF e_job='SALESMAN' THEN
      dbms_output.put_line('销售员');
    ELSIF e_job='CLERK' THEN
      dbms_output.put_line('办事员');
      ELSIF e_job='MANAGER' THEN
      dbms_output.put_line('经理');
      ELSIF e_job='ANALYST' THEN
      dbms_output.put_line('分析员');
      ELSE
        dbms_output.put_line('总裁');
      END IF;
END;

--输入一个学生的成绩，判断成绩等级
DECLARE
 score NUMBER:=&s;
 BEGIN
   IF score >100 OR score<0 THEN
     dbms_output.put_line('成绩无效');
   ELSIF score>=90 THEN
     dbms_output.put_line('优秀');
   ELSIF score>=80 THEN
     dbms_output.put_line('良好');
     ELSIF score>=60 THEN
     dbms_output.put_line('及格'); 
    ELSE 
     dbms_output.put_line('不及格'); 
  END IF;
END;


--输入一个员工的编号，查询出员工的职位，将职位显示为中文
DECLARE
  e_job emp.job%TYPE;
  BEGIN
    --查询数据
    SELECT job INTO e_job FROM emp WHERE empno=&eno;
    --判断职位
    CASE e_job  WHEN 'SALESMAN' THEN
                      dbms_output.put_line('销售员');
                WHEN 'CLERK' THEN
                     dbms_output.put_line('办事员');
                WHEN 'MANAGER' THEN
                     dbms_output.put_line('经理');
                WHEN 'ANALYST' THEN
                     dbms_output.put_line('分析员');
                ELSE
                     dbms_output.put_line('总裁');
        END CASE;
END;

--输入一个学生的成绩，判断成绩等级
DECLARE
 score NUMBER:=&s;
 BEGIN
   CASE WHEN score >100 OR score<0 THEN
     dbms_output.put_line('成绩无效');
   WHEN score>=90 THEN
     dbms_output.put_line('优秀');
   WHEN score>=80 THEN
     dbms_output.put_line('良好');
     WHEN score>=60 THEN
     dbms_output.put_line('及格'); 
    ELSE 
     dbms_output.put_line('不及格'); 
  END CASE;
END;



--输入一个年份，判断是否是闰年
--闰年条件：能被4整除但是不能被100整除，或者能被400整除
DECLARE
  YEAR NUMBER:=&YEAR;
  BEGIN
    --判断是否是闰年
    IF MOD(YEAR,4)=0 AND MOD(YEAR,100)<>0 OR MOD(YEAR,400)=0 THEN
      dbms_output.put_line('是闰年');
    ELSE
      dbms_output.put_line('不是闰年');
    END IF;
END;

DECLARE
 i NUMBER:=1;
BEGIN
  dbms_output.put_line(i);
  i:=i+1;
  dbms_output.put_line(i);
  i:=i+1;
  dbms_output.put_line(i);
  i:=i+1;
  dbms_output.put_line(i);
  i:=i+1;
  dbms_output.put_line(i);
  i:=i+1;
END;
--使用循环来打印1-5
DECLARE
  i NUMBER:=1;
  BEGIN
    --循环
    LOOP
        dbms_output.put_line(i);
        i:=i+1;
     EXIT WHEN i>10;
     END LOOP;
 END;

--计算1-100的和
--1+2+3+4......+100
/*
sum1=0
i=1;
sum1+i=1;
i:=i+1;
sum1+i=3;
i:=i+1;
sum1+i=6;
i:=i+1;
sum1+i=10;
i:=i+1;
......
sum1+i=5050;

循环变量：i=1
循环条件：i<=100
循环体：sum1:=sum1+i
         i:=i+1;
*/

DECLARE
 sum1 NUMBER:=0;
 i NUMBER:=1;
 BEGIN
   LOOP
     sum1:=sum1+i;
     i:=i+1;
   EXIT WHEN i>100;
   END LOOP;
   --输出结果
   dbms_output.put_line('1-100的和为：'||sum1);
END;



--打印1-10
DECLARE
 --声明循环变量
 i NUMBER:=1;
 BEGIN
   WHILE i<=10 LOOP
     dbms_output.put_line(i);
     --循环变量递增
     i:=i+1;
   END LOOP;
END;

--计算1-100的和
DECLARE
 sum1 NUMBER :=0;
 i NUMBER:=1;
 BEGIN
   WHILE i<=100 LOOP
     sum1:=sum1+i;
     --递增
     i:=i+1;
   END LOOP;
      --输出结果
   dbms_output.put_line('1-100的和为：'||sum1);
END;

--使用for循环打印1-10
BEGIN
  FOR i IN 1..10 LOOP
    dbms_output.put_line(i);
  END LOOP;
END;

--打印10-1
BEGIN
  FOR i IN REVERSE 1..10 LOOP
    dbms_output.put_line(i);
  END LOOP;
END;

--打印10-1
DECLARE
 --声明循环变量
 i NUMBER:=10;
 BEGIN
   WHILE i>0 LOOP
     dbms_output.put_line(i);
     --循环变量递增
     i:=i-1;
   END LOOP;
END;



--使用for循环计算1-100的和
DECLARE
 sum1 NUMBER:=0;
 BEGIN
   FOR i IN 1..100 LOOP
     sum1:=sum1+i;
   END LOOP;
         --输出结果
   dbms_output.put_line('1-100的和为：'||sum1);
END;


--打印1-10
DECLARE
 i NUMBER:=1;
 BEGIN
   WHILE TRUE LOOP
     --如果i大于10则结束循环
     IF i>10 THEN
       EXIT;
     END IF;
     dbms_output.put_line(i);
     i:=i+1;
   END LOOP;
 END;


--打印出第二个能被17整除的数字
DECLARE
 --定义循环变量
 i NUMBER:=1;
 --定义变量，用来记录被整除的次数
 n NUMBER:=0;
 BEGIN
   WHILE TRUE LOOP
     IF n>=2 THEN
       EXIT;
     END IF;
     IF MOD(i,17)=0 THEN
       dbms_output.put_line(i);
       n:=n+1;
     END IF;
     --循环变量要递增
     i:=i+1;
    END LOOP;
 END;    


--打印1-10中除了3之外的数字
BEGIN
  FOR i IN 1..10 LOOP
    IF i=3 THEN
      CONTINUE;
    END IF;
    dbms_output.put_line(i);
  END LOOP;         
 END;






--查询20号部门的员工的姓名，职位，工资
DECLARE
  --声明一个表类型
  TYPE table_emp IS TABLE OF emp%ROWTYPE;
  --声明一个表类型的变量
  t_emp table_emp;
BEGIN
  SELECT * BULK COLLECT INTO t_emp FROM emp WHERE deptno=20;
  --循环获取表类型中保存的数据
  FOR i IN t_emp.first..t_emp.last LOOP
    dbms_output.put_line(t_emp(i).ename||','||t_emp(i).job);
  END LOOP;
END;


SELECT * FROM emp WHERE deptno=20;


SELECT * FROM T_STU ;
SELECT * FROM t_s_c;
SELECT * FROM t_course;

--需求为达到以下效果：将学生选修的课程名称显示在一列中，需要按照成绩排名显示，并显示最高成绩的课程名
--方式一：
WITH TMP AS
 (SELECT S.ID,
         NAME,
         COURSE,
         CID,
         COURSENAME
    FROM T_STU S
    JOIN T_S_C SC
      ON S.ID = SC.SID
    JOIN T_COURSE C
      ON SC.CID = C.ID)
      SELECT NAME,lv,'/'||text,substr(text||'/',1,INSTR(text||'/','/')-1) root FROM(
SELECT ID,
       NAME,
       COUNT(*) LV,
       LISTAGG(COURSENAME, '/') WITHIN GROUP(ORDER BY COURSE DESC) text
  FROM TMP
 GROUP BY ID, NAME) a;
 
--方式二：
 
 WITH TMP AS
  (SELECT S.ID,
          NAME,
          COURSE,
          CID,
          COURSENAME,
          ROW_NUMBER() OVER(PARTITION BY S.ID, NAME ORDER BY COURSE DESC) 名次
     FROM T_STU S
     JOIN T_S_C SC
       ON S.ID = SC.SID
     JOIN T_COURSE C
       ON SC.CID = C.ID)
 SELECT NAME,
        LEVEL LV,
        SYS_CONNECT_BY_PATH(COURSENAME, '/') TEXT,
        CONNECT_BY_ROOT COURSENAME ROOT
   FROM TMP T
  WHERE CONNECT_BY_ISLEAF = 1
  START WITH 名次 = 1
 CONNECT BY ID = PRIOR ID
        AND PRIOR 名次 = 名次 - 1;


-- 第五题：有下面一张人员地址表，结构如下，其中地址列中存储的格式为省-市-县（区）
/*
create table addr_table(
       a_name varchar(20),
       a_addr varchar(50)
);

insert into addr_table values('张三','湖北-宜昌-五峰');
insert into addr_table values('李四','内蒙古-呼和浩特-清水河');
insert into addr_table values('小明','广东-深圳-宝安');
*/
  
SELECT DISTINCT a_name,regexp_substr(a_addr,'[^-]+',1,LEVEL) addr,
DECODE(LEVEL,1,'省',2,'市',3,'县/区')
 FROM addr_table CONNECT BY LEVEL<=regexp_count(a_addr,'-')+1;
  
 

/*
第六题表
*/
CREATE TABLE AMOUNT(
       YEAR VARCHAR2(5),
       USER_ID VARCHAR2(5),
       VALUE NUMBER
);
INSERT INTO AMOUNT VALUES('2022', 'A', 30);
INSERT INTO AMOUNT VALUES('2022', 'B', 10);
INSERT INTO AMOUNT VALUES('2022', 'C', 20);
INSERT INTO AMOUNT VALUES('2023', 'A', 40);
INSERT INTO AMOUNT VALUES('2023', 'B', 50);
INSERT INTO AMOUNT VALUES('2023', 'C', 20);
INSERT INTO AMOUNT VALUES('2023', 'D', 30);

SELECT * FROM AMOUNT;
COMMIT;

--请写一段SQL，按year分组取value前两小和前两大时对应的user_id字段，注意：需保持value最小、最大的user_id排首位

/*
第七题表
*/
CREATE TABLE TABLE_COURSE_GRADE(
       COURSE_ID NUMBER PRIMARY KEY,
       COURSE_NAME VARCHAR2(100),
       STUDENT_ID NUMBER,
       STUDENT_NAME VARCHAR2(100),
       COURSE_GRADE NUMBER
);

CREATE TABLE TABLE_CLASS_STUDENT(
       CLASS_ID NUMBER,
       CLASS_NAME VARCHAR2(100),
       STUDENT_ID NUMBER PRIMARY KEY,
       STUDENT_NAME VARCHAR2(100)
);

/*
第八题表
*/
CREATE TABLE T12(
       A VARCHAR2(50),
       B VARCHAR2(50),
       C VARCHAR2(50)
);

INSERT INTO T12 VALUES('001', 'A/B', '/1/3/5');
INSERT INTO T12 VALUES('002', 'B/C/D', '4/5');

SELECT * FROM T12;
COMMIT;

/*
第九题表
*/
CREATE TABLE OPSTATION(
       CUST_NO VARCHAR2(50),
       OPSTATION VARCHAR2(100)
);

INSERT INTO OPSTATION VALUES('208001139', 'E@183.135.107.156@15867854587@07396666555');
INSERT INTO OPSTATION VALUES('200000798', 'E@39.188.105.52@13906842974@0201111555');
INSERT INTO OPSTATION VALUES('200000397', '3@54E1ADE44071@125116208030@6666666');
INSERT INTO OPSTATION VALUES('200001028', 'E@39.189.28.240@13738427859@02588886666');
INSERT INTO OPSTATION VALUES('200000723', '3@1418C3E24163@816231062182@888522222');
INSERT INTO OPSTATION VALUES('200000176', '3@F01FAF22C8B3@03918106070@555555');
INSERT INTO OPSTATION VALUES('200000791', '3@13921401751@117136045141');
INSERT INTO OPSTATION VALUES('200000015', 'E@218.205.55.79@13906616773');
INSERT INTO OPSTATION VALUES('208001383', 'E@223.104.161.221@13884412998');
INSERT INTO OPSTATION VALUES('208000301', 'E@223.104.161.62@13819823379');
INSERT INTO OPSTATION VALUE
  
  

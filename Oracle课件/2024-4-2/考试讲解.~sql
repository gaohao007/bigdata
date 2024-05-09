/*create table T_prod(
CUST_ID number,
PROD varchar2(20),
ATM number,
CNT number);

insert into T_prod values(1000100001,'A',100,2);
insert into T_prod values(1000100001,'B',200,1);
insert into T_prod values(1000100002,'B',200,3);
insert into T_prod values(1000100003,'A',100,1);
insert into T_prod values(1000100003,'B',200,2);
*/
SELECT * FROM T_prod;

--1)通过SQL代码实现，查询出同事持有A产品和B产品的客户
--方式一:
SELECT cust_id,COUNT(*) FROM t_prod WHERE prod IN('A','B') GROUP BY cust_id HAVING COUNT(DISTINCT prod)>1;
--方式二：交集
SELECT cust_id FROM t_prod WHERE prod='A'
INTERSECT
SELECT cust_id FROM t_prod WHERE prod='B'
--方式三：子查询
SELECT * FROM t_prod p WHERE prod='A' AND EXISTS(SELECT * FROM t_prod WHERE prod='B' AND p.cust_id=cust_id)
SELECT * FROM t_prod p WHERE prod='A' AND cust_id IN (SELECT cust_id FROM t_prod WHERE prod='B')

--2）通过SQL代码实现，查询出只持有B产品的客户
--方式一：
SELECT cust_id FROM t_prod WHERE prod IN('A','B')
MINUS
SELECT cust_id FROM t_prod WHERE prod='A';
--方式二：子查询
SELECT * FROM t_prod p WHERE prod='B' AND not EXISTS(SELECT * FROM t_prod WHERE prod='A' AND p.cust_id=cust_id)

--3)
SELECT  * FROM(
SELECT cust_id,prod,amt*cnt amt FROM t_prod) PIVOT(MAX(amt) FOR prod IN('A' A,'B' B));


-- 客户信息表
create table pty_info(
pty_id  varchar2(100) primary key,
pty_name varchar2(100),
ORG_ID number);
insert into pty_info values('cust001','AAA',741);
insert into pty_info values('cust002','BBB',852);
insert into pty_info values('cust003','CCC',741);
insert into pty_info values('cust004','DDD',852);

-- 交易表
create table deli(
busi_date varchar2(100),
exch_time varchar2(100),
pty_Id varchar2(100),
exch_type varchar2(100),
prd_no number,
del_atm number,
constraint deil_ptyinfo_pty foreign key(pty_id) references pty_info(pty_id));
select * from deli;
TRUNCATE TABLE deli;
insert into deli values(
'20221204','09:28:55.1800','cust001','买入股票',300125,6000);
insert into deli values(
'20221204','20:18:55.4400','cust002','卖出股票',000713,6000);
insert into deli values(
'20230104','14:12:13.8116','cust001','卖出股票',000262,14500);
insert into deli values(
'20221202','14:24:13.8116','cust002','买入股票',000713,8000);
insert into deli values(
'20221201','09:21:16.8116','cust001','买入股票',300801,10000);

SELECT * FROM pty_info;
SELECT * FROM deli;

--（1）提取2022年12月至2023年1月，每个月做过【买入股票】交易的客户名单
-- 展示字段：月份、客户编号（每个月同一个客户只显示一次）

SELECT to_char(busi_date,'yyyymm') 月份,pty_id 客户编号 FROM deli WHERE to_char(busi_date,'yyyymm')IN('202212','202301') AND exch_type='买入股票'
GROUP BY to_char(busi_date,'yyyymm'),pty_id;

--(2)计算2022年12月每个营业部所有客户[买入股票]的交易金额之和:展示字段:营业部编号，交易金额
 SELECT orgid 营业部编号,SUM(del_amt)交易金额 FROM pty_info p JOIN deli d ON p.pty_id=d.pty_id WHERE to_char(busi_date,'yyyymm')='202212'
 AND exch_type='买入股票' 
 GROUP BY orgid;

--(3)计算在2022年12月每日第一个交易客户和最后一个交易客户的时间信息，如当天无交易则不计算;
--展示字段:日期、第一个交易时间、第一个交易客户编号、最后交易时间、最后交易客户编号
WITH tmp1 AS(
SELECT busi_date,exch_time,pty_id FROM(
SELECT d.*,
 row_number()OVER(PARTITION BY busi_date ORDER BY exch_time) rn
 FROM deli d WHERE to_char(busi_date,'yyyymm')='202212') WHERE rn=1),
tmp2 AS(
SELECT busi_date,exch_time,pty_id FROM(
SELECT d.*,
 row_number()OVER(PARTITION BY busi_date ORDER BY exch_time DESC) rn
 FROM deli d WHERE to_char(busi_date,'yyyymm')='202212') WHERE rn=1)
 SELECT t1.busi_date 日期,t1.exch_time 第一个交易时间,t1.pty_id 第一个交易客户编号,
 t2.exch_time 最后一个交易时间,t2.pty_id 最后一个交易客户编号
  FROM tmp1 t1 JOIN tmp2 t2 ON t1.busi_date=t2.busi_date;

--(4)提取出2022年12月每日交易金额前10的产品信息:展示字段:日期、产品代码、交易量、排名
SELECT * from(
SELECT busi_date,del_amt,prd_no,row_number()OVER(PARTITION BY busi_date ORDER BY del_amt DESC) 排名 
FROM deli WHERE to_char(busi_date,'yyyymm')='202212') WHERE 排名<=10;

--(5)有一份手工更新的客户信息，存放在表3,	请用表3更新表2信息，更新逻辑如下:
--如客户表2表3都有，营业部编号以表3为准，客户名称以表3为准:如客户表2有表3无，
--以表2信息为准:如客户表2无表3有，以表3信息为准:

CREATE TABLE PTY_INFO_TMP(
       PTY_ID VARCHAR2(20),
       PTY_NAME VARCHAR2(20),
       ORG_ID VARCHAR2(20)
);
INSERT INTO PTY_INFO_TMP VALUES('cust002', 'BBB', '123');
INSERT INTO PTY_INFO_TMP VALUES('cust003', 'DDD', '456');
SELECT * FROM PTY_INFO_TMP;

SELECT * FROM PTY_INFO_TMP;

--更新
MERGE INTO pty_info t USING PTY_INFO_TMP s ON (t.pty_id=s.pty_id)
WHEN MATCHED THEN
  UPDATE SET t.pty_name=s.pty_name,t.orgid=s.orgid
WHEN NOT MATCHED THEN 
  INSERT VALUES(s.pty_id,s.pty_name,s.orgid);




--通过SQL语句计算2012年一年内，客户每月的消费总金额，请写出实现的SQL语句，查询结果格式如下（8分）
SELECT cust_id,to_char(txn_dt,'yyyymm') 月份,SUM(amt) 消费总金额 FROM t03_card_trade_detail WHERE to_char(txn_dt,'yyyy')='2012'
GROUP BY cust_id,to_char(txn_dt,'yyyymm');


CREATE TABLE T03_ACCT_TRADE_DETAIL(
       CUST_ID VARCHAR2(20),
       ACCT_NO VARCHAR2(20),
       ORG_NAME VARCHAR2(20),
       AMT NUMBER,
       TXN_DT VARCHAR2(20),
       CURRENT_BAL NUMBER
);
INSERT INTO T03_ACCT_TRADE_DETAIL VALUES('6000121', '9000000001', '上海分行', 100.00, '20120701', 20000);
INSERT INTO T03_ACCT_TRADE_DETAIL VALUES('6000122', '9000000002', '宁波分行', 200.00, '20120701', 30000);
INSERT INTO T03_ACCT_TRADE_DETAIL VALUES('6000122', '9000000003', '宁波分行', 200.00, '20120701', 30000);
INSERT INTO T03_ACCT_TRADE_DETAIL VALUES('6000122', '9000000004', '宁波分行', 200.00, '20120701', 30000);
INSERT INTO T03_ACCT_TRADE_DETAIL VALUES('6000123', '9000000005', '宁波分行', 200.00, '20120701', 30000);
INSERT INTO T03_ACCT_TRADE_DETAIL VALUES('6000123', '9000000006', '宁波分行', 200.00, '20120701', 30000);
INSERT INTO T03_ACCT_TRADE_DETAIL VALUES('6000123', '9000000007', '宁波分行', 200.00, '20120701', 30000);
SELECT * FROM T03_ACCT_TRADE_DETAIL;

SELECT * FROM T03_ACCT_TRADE_DETAIL;
--1）统计全行2012年7月累计的交易发生额和全行2012年7月末的账户余额（15分）

SELECT SUM(amt) FROM T03_ACCT_TRADE_DETAIL WHERE SUBSTR(txn_dt,1,6)='201207'; 


SELECT 交易金额, SUM(CURRENT_BAL) 账户余额
  FROM (SELECT T.*,
               SUM(AMT) OVER() 交易金额,
               ROW_NUMBER() OVER(PARTITION BY ACCT_NO ORDER BY TXN_DT DESC) RN
          FROM T03_ACCT_TRADE_DETAIL T
         WHERE SUBSTR(TXN_DT, 1, 6) = '201207')
 WHERE RN = 1
 GROUP BY 交易金额;




--2）查询结果显示格式，请写出实现的SQL语句（10分）
--Rank_cd(排名)	Org_name(所属分行)	Cust_id(客户行)	Current_bal(当前余额)


WITH TMP AS
 (SELECT *
    FROM (SELECT T.*,
                 SUM(AMT) OVER() 交易金额,
                 ROW_NUMBER() OVER(PARTITION BY ACCT_NO ORDER BY TXN_DT DESC) RN
            FROM T03_ACCT_TRADE_DETAIL T)
   WHERE RN = 1)
   SELECT RANK()OVER(ORDER BY 当前余额 desc) 排名,a.* FROM(
SELECT ORG_NAME, CUST_ID, SUM(CURRENT_BAL) 当前余额
  FROM TMP
 GROUP BY ORG_NAME, CUST_ID
 ORDER BY 当前余额 DESC) a;

--3）查询宁波分行每个客户在2012年6月累计发生额比2012年12月多10000的客户清单，输出格式如下（10分）
--方式一：
WITH tmp6 AS(
SELECT cust_id,org_name,SUM(amt) mon6 FROM T03_ACCT_TRADE_DETAIL WHERE org_name='宁波分行' AND SUBSTR(txn_dt,1,6)='201206'
GROUP BY cust_id,org_name),
tmp12 AS(
SELECT cust_id,org_name,SUM(amt) mon12 FROM T03_ACCT_TRADE_DETAIL WHERE org_name='宁波分行' AND SUBSTR(txn_dt,1,6)='201212'
GROUP BY cust_id,org_name)
SELECT t6.cust_id,t6.org_name,mon6,mon12 FROM tmp6 t6 JOIN tmp12 t12 ON t6.cust_id=t12.cust_id WHERE (mon6-mon12)>10000;

--方式二：
SELECT * FROM(
SELECT cust_id,org_name,
SUM(CASE WHEN SUBSTR(txn_dt,1,6)='201206' THEN amt ELSE 0 END) mon6,
SUM(CASE WHEN SUBSTR(txn_dt,1,6)='201212' THEN amt ELSE 0 END) mon12
 FROM T03_ACCT_TRADE_DETAIL WHERE org_name='宁波分行' AND SUBSTR(txn_dt,1,6) in('201206','201212')
GROUP BY cust_id,org_name) WHERE mon6-mon12>10000;


--如何用一条sql语句查询出每位学生前一名及后一名学生的姓名
SELECT s.*,LEAD(NAME,1)OVER(ORDER BY 排名),LAG(NAME,1) over(ORDER BY 排名) FROM stu s;


create table t02_ClassA(sname VARCHAR(10),gender VARCHAR(10),stuNum VARCHAR(10));
create table t02_ClassB(sname VARCHAR(10),gender VARCHAR(10),stuNum VARCHAR(10));
INSERT INTO t02_ClassA VALUES('李犇牪 ','男','C20160001');
INSERT INTO t02_ClassA VALUES('张叒㕛 ','男','C20160002');
INSERT INTO t02_ClassA VALUES('王森林 ','男','C20160003');
INSERT INTO t02_ClassA VALUES('杜歘欻 ','男','C20160004');
INSERT INTO t02_ClassA VALUES('刘歮歧 ','男','C20160005');
INSERT INTO t02_ClassA VALUES('秦㸚爻 ','男','C20160006');
INSERT INTO t02_ClassA VALUES('冯㕕厽 ','男','C20160007');
INSERT INTO t02_ClassA VALUES('聂巜巛 ','男','C20160008');
INSERT INTO t02_ClassA VALUES('金椽㓯 ','男','C20160009');
INSERT INTO t02_ClassA VALUES('鲁怭惢 ','男','C20160010');
INSERT INTO t02_ClassA VALUES('胡昍晶 ','男','C20160011');
INSERT INTO t02_ClassA VALUES('李蕾 ','女','C20160012');
INSERT INTO t02_ClassB VALUES('詹叁 ','女','C20160018');
INSERT INTO t02_ClassB VALUES('礼肆 ','女','C20160019');


SELECT * FROM t02_ClassA;
SELECT * FROM t02_ClassB;
--将A表中的男生迁移到B表中
--merge into
MERGE INTO t02_ClassB t USING (SELECT * FROM t02_ClassA WHERE gender='男') s
ON (t.stunum=s.stunum)
WHEN NOT MATCHED THEN
  INSERT VALUES(s.sname,s.gender,s.stunum);

--union all
SELECT * FROM t02_ClassB
UNION ALL
SELECT * FROM t02_ClassA WHERE gender='男'


create table t04_phone_record(r_date varchar(10),pname varchar(10),record varchar(20));
INSERT INTO t04_phone_record VALUES('2015/07/23','张三','0755-8888888');
INSERT INTO t04_phone_record VALUES('2015/07/23','张三','0755-5555555');
INSERT INTO t04_phone_record VALUES('2015/07/22','张三','0755-6666666');
INSERT INTO t04_phone_record VALUES('2015/07/24','李四','010-7777777');
INSERT INTO t04_phone_record VALUES('2015/07/23','王五','020-8888888');
SELECT * FROM(
SELECT a.*,row_number()OVER(PARTITION BY pname ORDER BY r_date DESC)rn FROM t04_phone_record a)
WHERE rn=1;

--找出重复的数据
SELECT 列名 FROM biao GROUP BY 列名 HAVING count(*)>1

--找出不带J的
SELECT * FROM emp WHERE ename NOT LIKE '%J%';
SELECT * from emp WHERE regexp_like(ename,'^[^J]*$');

SELECT c_class,COUNT(*),MAX(score),MIN(score),AVG(score) 平均分 FROM tscore GROUP BY c_class
ORDER BY 平均分 desc;

SELECT s.*,LAG(sell,12) OVER(ORDER BY MONTHS) lastyear,
LAG(sell,1) OVER(ORDER BY MONTHS) lastmonth FROM sales s;

SELECT TO_CHAR(M, 'yyyy') || CASE
         WHEN TO_CHAR(M, 'mm') = 01 THEN
          'Q1'
         WHEN TO_CHAR(M, 'mm') = 04 THEN
          'Q2'
         WHEN TO_CHAR(M, 'mm') = 07 THEN
          'Q3'
         WHEN TO_CHAR(M, 'mm') = 10 THEN
          'Q4'
       END season,
       SELLS
  FROM (SELECT TRUNC(TO_DATE(MONTHS, 'yyyymm'), 'Q') M, SUM(SELL) SELLS
          FROM SALES
         GROUP BY TRUNC(TO_DATE(MONTHS, 'yyyymm'), 'Q'));


SELECT * FROM user_t;

UPDATE user_t SET NAME=NAME||age;

WITH tmp AS(
SELECT 'aa df dsf' str FROM dual
)
SELECT REPLACE(str,' ') FROM tmp;

UPDATE tmp SET str=REPLACE(str,' ');

CREATE OR REPLACE FUNCTION fun_max( n1 NUMBER,n2 NUMBER) RETURN NUMBER
IS
BEGIN
  IF n1>n2 THEN
    RETURN n1;
   ELSE
     RETURN n2;
   END IF;
END;

SELECT fun_max(34,23) FROM dual;

--编写PL/SQL块
DECLARE
 --声明一个游标
 CURSOR cur_cust IS
 SELECT * FROM t_custmobile WHERE regexp_like(mobileno,'^1[358]\d{9}$');
 
 --声明一个表类型
 TYPE cust_type IS TABLE OF t_custmobile%ROWTYPE;
 --声明表类型的变量
 t_cust cust_type;
 BEGIN
   --打开游标
   OPEN cur_cust;
   LOOP
     --批量读取游标
     FETCH cur_cust BULK COLLECT INTO t_cust LIMIT 5;
     --判断是否读取到数据
     EXIT WHEN t_cust.count=0;
     --循环表类型变量获取数据添加到目标表中并进行提交
     FOR  i IN t_cust.first..t_cust.last LOOP
       dbms_output.put_line(t_cust(i).custno);
       --添加数据
       INSERT  INTO t_tempcust VALUES(t_cust(i).custno);
     END LOOP;
     --提交事务
     COMMIT;
   END LOOP;
    --关闭游标
    CLOSE cur_cust;
 END;
 
 TRUNCATE TABLE t_tempcust;
 
 --编写PL/SQL块
DECLARE
 --声明一个游标
 CURSOR cur_cust IS
 SELECT * FROM t_custmobile;
 
 --声明一个表类型
 TYPE cust_type IS TABLE OF t_custmobile%ROWTYPE;
 --声明表类型的变量
 t_cust cust_type;
 BEGIN
   --打开游标
   OPEN cur_cust;
   LOOP
     --批量读取游标
     FETCH cur_cust BULK COLLECT INTO t_cust LIMIT 5;
     --判断是否读取到数据
     EXIT WHEN t_cust.count=0;
     --循环表类型变量获取数据添加到目标表中并进行提交
     FOR  i IN t_cust.first..t_cust.last LOOP
       dbms_output.put_line(t_cust(i).custno);
       --判断手机号是否合法，如果合法则再将数据添加
       IF regexp_like(t_cust(i).mobileno,'^1[358]\d{9}$') THEN
         --添加数据
         INSERT  INTO t_tempcust VALUES(t_cust(i).custno);
       END IF;
     END LOOP;
     --提交事务
     COMMIT;
   END LOOP;
    --关闭游标
    CLOSE cur_cust;
 END;
 

SELECT * FROM t_tempcust;
SELECT * FROM t_custmobile;



DECLARE
 CURSOR cur_emp IS
 SELECT * FROM emp;
 i NUMBER;
 BEGIN
   --打开游标
   --OPEN cur_emp;
    FOR e IN cur_emp LOOP
     i:=cur_emp%ROWCOUNT;
    END LOOP;
   --输出游标的条数
   dbms_output.put_line(i);
   --关闭游标
   --CLOSE cur_emp;
END;



--1--编写一个PL/SQL块来实现：查询员工表中的工资最高的员工的姓名，工资，职位以及入职日期。
DECLARE
  E_NAME     EMP.ENAME%TYPE;
  E_JOB      EMP.JOB%TYPE;
  E_SAL      EMP.SAL%TYPE;
  E_HIREDATE EMP.HIREDATE%TYPE;
BEGIN
  SELECT ENAME, JOB, SAL, HIREDATE
    INTO E_NAME, E_JOB, E_SAL, E_HIREDATE
    FROM (SELECT * FROM EMP ORDER BY SAL DESC)
   WHERE ROWNUM = 1;
  DBMS_OUTPUT.PUT_LINE(E_NAME || ',' || E_SAL || ',' || E_JOB || ',' ||
                       E_HIREDATE);
END;


--2--编写一个PL/SQL块来实现：查询部门中的平均工资最高的部门的名称以及部门号以及平均工资。
DECLARE
  D_NAME  DEPT.DNAME%TYPE;
  D_NO    DEPT.DEPTNO%TYPE;
  AVG_SAL NUMBER;
BEGIN
  SELECT *
    INTO D_NO, D_NAME, AVG_SAL
    FROM (SELECT E.DEPTNO, D.DNAME, AVG(SAL) 平均工资
            FROM EMP E
            JOIN DEPT D
              ON E.DEPTNO = D.DEPTNO
           GROUP BY E.DEPTNO, D.DNAME
           ORDER BY 平均工资 DESC)
   WHERE ROWNUM = 1;
  DBMS_OUTPUT.PUT_LINE(D_NAME || ',' || D_NO || ',' || AVG_SAL);
END;



--3--编写一个PL/SQL块，将所有的员工的信息以及部门信息输出到另外的一张表中。
--注意：提前创建好另外一张表,在导入之前先要删除另外一张表中原来的数据。
--4编写一个PL/SQL块：在控制台上输出emp中编号为7369的姓名，工资，入职日期和职位，要求在定义变量的时候使用record类型定义。
DECLARE
 TYPE emp_type IS RECORD(
  E_NAME     EMP.ENAME%TYPE,
  E_JOB      EMP.JOB%TYPE,
  E_SAL      EMP.SAL%TYPE,
  E_HIREDATE EMP.HIREDATE%TYPE);
  --声明变量
  emps emp_type;
BEGIN
  SELECT ENAME, JOB, SAL, HIREDATE
    INTO emps
    FROM emp
   WHERE empno=7369;
  DBMS_OUTPUT.PUT_LINE(emps.e_name || ',' || emps.E_sal || ',' || emps.e_job || ',' ||
                       emps.e_hiredate);
END;


--5.编写一个PL/SQL块：定义两个变量，然后分别输出这两个数的和，差，商，积；
--6.编写一个PL/SQL块：输入一个员工的姓名，如果该员工不存在则输出员工不存在，
--如果员工存在，则输出该员工所在部门的平均工资以及该部门的人数。 
DECLARE
  N       NUMBER;
  AVG_SAL NUMBER;
  NUM_E   NUMBER;
  E_NAME  VARCHAR2(20) := '&name';
BEGIN
  SELECT COUNT(*) INTO N FROM EMP WHERE ENAME = E_NAME;
  --判断n是否为0
  IF N = 0 THEN
    DBMS_OUTPUT.PUT_LINE('该员工不存在');
  ELSE
    SELECT AVG(SAL), COUNT(*)
      INTO AVG_SAL, NUM_E
      FROM EMP
     WHERE DEPTNO = (SELECT DEPTNO FROM EMP WHERE ENAME = E_NAME);
    DBMS_OUTPUT.PUT_LINE(AVG_SAL || ',' || NUM_E);
  END IF;
END;


DECLARE
  AVG_SAL NUMBER;
  NUM_E   NUMBER;
  E_NAME  VARCHAR2(20) := '&name';
  D_NO    NUMBER;
BEGIN
  --查询该员工所在的部门号
  SELECT DEPTNO INTO D_NO FROM EMP WHERE ENAME = E_NAME;
  --查询该部门的平局工资和人数
  SELECT AVG(SAL), COUNT(*)
    INTO AVG_SAL, NUM_E
    FROM EMP
   WHERE DEPTNO = D_NO;
  DBMS_OUTPUT.PUT_LINE(AVG_SAL || ',' || NUM_E);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('该员工不存在');
END;



--1.编写一个PL/SQL块，计算1-100的和，但是7的倍数以及以7结尾的数字除外。 
DECLARE
 sum_1 NUMBER:=0;
 BEGIN 
   FOR i IN 1..100 LOOP
     --判断
     IF MOD(i,7)=0 OR MOD(i,10)=7 THEN
       CONTINUE;
     END IF;
     sum_1:=sum_1+i;
   END LOOP;
   dbms_output.put_line(sum_1);
END;
     

 
--2.输入一个年，月，日，输出该天是这一年的第多少天。
--方式一
DECLARE
  NUMS NUMBER;
  Y    NUMBER := &Y;
  M    NUMBER := &M;
  D    NUMBER := &D;
BEGIN
  NUMS := TO_DATE(Y || '-' || M || '-' || D, 'yyyy-mm-dd') -
          TO_DATE(Y || '-01-01', 'yyyy-mm-dd') + 1;
  DBMS_OUTPUT.PUT_LINE(NUMS);
END;

--方式二
DECLARE
  NUMS NUMBER := 0;
  Y    NUMBER := &Y;
  M    NUMBER := &M;
  D    NUMBER := &D;
BEGIN
  FOR I IN 1 .. M - 1 LOOP
    CASE
      WHEN I IN (1, 3, 5, 7, 8, 10, 12) THEN
        NUMS := NUMS + 31;
      WHEN I IN (4, 6, 9, 11) THEN
        NUMS := NUMS + 30;
      WHEN I = 2 THEN
        --判断是否是闰年
        IF MOD(Y, 4) = 0 AND MOD(Y, 100) != 0 OR MOD(Y, 400) = 0 THEN
          NUMS := NUMS + 29;
        ELSE
          NUMS := NUMS + 28;
        END IF;
    END CASE;
  END LOOP;

  NUMS := NUMS + D;
  DBMS_OUTPUT.PUT_LINE(NUMS);
END;


--3.输出100-999之间的水仙花数:水仙花数：153=1*1*1+5*5*5+3*3*3=153.
DECLARE
 g NUMBER;
 s NUMBER;
 b NUMBER;
BEGIN
  FOR i IN 100..999 LOOP
    --个位
    g:=SUBSTR(i,3);
    --dbms_output.put_line(g);
    --十位
    s:=SUBSTR(i,2,1);
    --百位
    b:=SUBSTR(i,1,1);
    
    IF i=POWER(g,3)+POWER(s,3)+POWER(b,3) THEN
      dbms_output.put_line(i);
    END IF;
  END LOOP;
END;
    

DECLARE
 g NUMBER;
 s NUMBER;
 b NUMBER;
BEGIN
  FOR i IN 100..999 LOOP
    --个位
    g:=MOD(i,10);
    --十位      123      12
    s:=mod(floor(i/10),10);
    --百位
    b:=FLOOR(i/100);
    
    IF i=POWER(g,3)+POWER(s,3)+POWER(b,3) THEN
      dbms_output.put_line(i);
    END IF;
  END LOOP;
END;


SELECT * FROM amount;


--请写一段SQL，按year分组取value前两小和前两大时对应的user_id字段，注意：需保持value最小、最大的user_id排首位
--得到如下结果：
--year | min_user_id | max_user_id
--2022  B,C     A,C
--2023  C,D     B,A

SELECT YEAR, SUBSTR(MI, 1, 3), SUBSTR(MA, 1, 3)
  FROM (SELECT YEAR,
               LISTAGG(USER_ID, ',') WITHIN GROUP(ORDER BY VALUE) MI,
               LISTAGG(USER_ID, ',') WITHIN GROUP(ORDER BY VALUE DESC) MA
          FROM AMOUNT
         GROUP BY YEAR);


CREATE TABLE T12(
       A VARCHAR2(50),
       B VARCHAR2(50),
       C VARCHAR2(50)
);

INSERT INTO T12 VALUES('001', 'A/B', '/1/3/5');
INSERT INTO T12 VALUES('002', 'B/C/D', '4/5');

SELECT * FROM T12;
COMMIT;

SELECT DISTINCT a,'type_b' d ,regexp_substr(b,'[^/]+',1,LEVEL) e FROM t12 CONNECT BY LEVEL<=regexp_count(b,'/')+1
UNION ALL
SELECT DISTINCT a,'type_c' d ,regexp_substr(c,'[^/]+',1,LEVEL) e FROM t12 CONNECT BY LEVEL<=regexp_count(c,'/')+1

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
INSERT INTO OPSTATION VALUES('200000723','5@18134206077@8888888');
--题目9、提取opstaion的手机号码信息（符合11位长度的数字），若不符合手机号规则，则置空值。（10%）
SELECT o.*,regexp_substr(OPSTATION,'1[356789]\d{9}') FROM OPSTATION o;


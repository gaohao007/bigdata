--声明一个游标，用来查询指定部门的员工的姓名和工资
DECLARE
 --声明游标
 CURSOR cur_emp(dno NUMBER) IS
 SELECT ename,sal FROM emp WHERE deptno=dno;
 --声明变量
 e_name emp.ename%TYPE;
 e_sal emp.sal%TYPE;
BEGIN
  --打开游标
  OPEN cur_emp(20);
  
  --使用循环来多次读取游标中的数据
  LOOP
    --读取游标
    FETCH cur_emp INTO e_name,e_sal;  
    EXIT WHEN cur_emp%NOTFOUND;
    --输出数据
    dbms_output.put_line(e_name||','||e_sal);
    END LOOP;
  --关闭游标
  CLOSE cur_emp;
END;

--使用while循环
DECLARE
 --声明游标
 CURSOR cur_emp(dno NUMBER) IS
 SELECT ename,sal FROM emp WHERE deptno=dno;
 --声明变量
 e_name emp.ename%TYPE;
 e_sal emp.sal%TYPE;
BEGIN
  --打开游标
  OPEN cur_emp(20);
  --使用循环来多次读取游标中的数据
  --读取游标
  FETCH cur_emp INTO e_name,e_sal;  
  WHILE cur_emp%FOUND LOOP
    --输出数据
    dbms_output.put_line(e_name||','||e_sal);
     --读取游标
    FETCH cur_emp INTO e_name,e_sal;  
    END LOOP;
  --关闭游标
  CLOSE cur_emp;
END;

--使用for循环来读取游标
DECLARE
 --声明游标
 CURSOR cur_emp(dno NUMBER) IS
 SELECT ename,sal FROM emp WHERE deptno=dno;
 BEGIN
   --使用循环操作游标
   FOR r_emp IN cur_emp(20) LOOP
     --输出结果
     dbms_output.put_line(r_emp.ename||','||r_emp.sal);
   END LOOP;
 END;  
     
--批量读取游标操作
--使用for循环来读取游标
DECLARE
 --声明游标
 CURSOR cur_emp IS
 SELECT * FROM emp WHERE deptno=20;
 --定义一个表类型
 TYPE type_table IS TABLE OF emp%ROWTYPE;
 --声明表类型变量
 r_emp type_table;
 BEGIN
   --打开游标
   OPEN cur_emp;
   --读取游标
   FETCH cur_emp BULK COLLECT INTO r_emp;
   --使用for循环将数据打印出来
   FOR i IN r_emp.first..r_emp.last LOOP
     dbms_output.put_line(r_emp(i).ename||','||r_emp(i).sal);
   END LOOP;
END;
   
--批量读取emp表中的数据每次读取5条
DECLARE
 CURSOR cur_emp IS
 SELECT * FROM emp;
  --定义一个表类型
 TYPE type_table IS TABLE OF emp%ROWTYPE;
 --声明表类型变量
 r_emp type_table;
 --定义变量记录次数
 c NUMBER:=0;
 BEGIN
   --打开游标
   OPEN cur_emp;
   --循环读取游标
   LOOP
     c:=c+1;
     
     FETCH cur_emp BULK COLLECT INTO r_emp LIMIT 5;
     --如果读取到表类型中行数为0则代表数据读取完成
     EXIT WHEN r_emp.count=0;
     --批量读取数据
     dbms_output.put_line('第'||c||'批读取数据：');
      --使用for循环将数据打印出来
       FOR i IN r_emp.first..r_emp.last LOOP
         dbms_output.put_line(r_emp(i).ename||','||r_emp(i).sal);
       END LOOP;
     END LOOP;
     
   --关闭游标
   CLOSE cur_emp;
  END;
     
--使用select ..bulk collect来读取数据
DECLARE
    --定义一个表类型
 TYPE type_table IS TABLE OF emp%ROWTYPE;
 --声明表类型变量
 r_emp type_table;
 --定义一个循环变量
 n NUMBER:=1;
 --批次
 page NUMBER:=0;
 BEGIN
   --获取批次
   SELECT ceil(count(*)/5) INTO page FROM emp;
   --循环读取
   WHILE n<=page LOOP
          dbms_output.put_line('第'||n||'批读取数据：');
         SELECT empno,ename,job,mgr,hiredate,sal,comm,deptno BULK COLLECT INTO r_emp FROM(  
         SELECT e.*,ROWNUM rn FROM emp e) WHERE rn BETWEEN (n-1)*5+1 AND 5*n; 
   --使用for循环将数据打印出来
       FOR i IN r_emp.first..r_emp.last LOOP
         dbms_output.put_line(r_emp(i).ename||','||r_emp(i).sal);
       END LOOP;
       n:=n+1;
     END LOOP;
 END;
/*
1     1       5
2     6       10
3     11      15
.....
n   (n-1)*5+1  5*n      



*/

--声明一个游标，用来查询指定部门的员工的姓名和工资
DECLARE
 --声明游标
 CURSOR cur_emp(dno NUMBER) IS
 SELECT ename,sal FROM emp WHERE deptno=dno;
 --声明变量
 e_name emp.ename%TYPE;
 e_sal emp.sal%TYPE;
BEGIN
  
  OPEN cur_emp(20);
  IF cur_emp%ISOPEN THEN
    dbms_output.put_line('游标已经被打开');
  ELSE
    --打开游标
    OPEN cur_emp(20);
  END IF;
  --使用循环来多次读取游标中的数据
  LOOP
    --读取游标
    FETCH cur_emp INTO e_name,e_sal;  
    EXIT WHEN cur_emp%NOTFOUND;
    --输出数据
    dbms_output.put_line(e_name||','||e_sal);
    END LOOP;
  --关闭游标
  CLOSE cur_emp;
END;


--将员工表中的20号部门的员工的工资上调20%，并且输出上调人数。
BEGIN
  --上调工资
  UPDATE emp SET sal=sal*1.2 WHERE deptno=20;
    --输出上调人数
  dbms_output.put_line('上调的人数为：'||sql%ROWCOUNT);
  --删除员工
  DELETE FROM emp WHERE deptno=30;
  dbms_output.put_line('删除的人数为：'||sql%ROWCOUNT);
END;
  
SELECT * FROM emp;


--查询20号部门的员工的信息
--显式游标
DECLARE
 CURSOR cur_emp IS
 SELECT * FROM emp WHERE deptno=20;
 BEGIN
   FOR r IN cur_emp LOOP
     dbms_output.put_line(r.ename||','||r.sal);
   END LOOP;
END;

--隐式游标
BEGIN
  FOR r IN (SELECT * FROM emp WHERE deptno=20) LOOP  
   dbms_output.put_line(r.ename||','||r.sal);
   END LOOP;
END;

DECLARE
e_name emp.ename%TYPE;
CURSOR c_emp IS
SELECT * FROM emp;
 BEGIN
   OPEN c_emp;
   OPEN c_emp;
   CLOSE c_emp;
   SELECT ename INTO e_name FROM emp WHERE deptno=&dno;
   dbms_output.put_line(e_name);
 EXCEPTION
   WHEN no_data_found THEN
     dbms_output.put_line('没有查询到数据');
   WHEN too_many_rows THEN
     dbms_output.put_line('查询到多行数据');
   WHEN invalid_cursor THEN
     dbms_output.put_line('不能关闭没有打开的游标');
   WHEN OTHERS THEN
     dbms_output.put_line('发生了异常'||sqlcode||','||Sqlerrm);
END;


SELECT * FROM dept;

--错误编号异常
DECLARE
--声明一个异常变量
  primary_err EXCEPTION;
  --将异常变量和错误编号进行绑定
  PRAGMA EXCEPTION_INIT(primary_err,-00001); 
BEGIN
       INSERT INTO dept VALUES(10,'','');
       EXCEPTION
         WHEN primary_err THEN
           dbms_output.put_line('主键不能重复！');
END;


--定义一个异常，如果在向部门表中添加数据的时候，部门名称为空则就需要引发一个异常。
DECLARE
 --声明一个异常变量
 name_null EXCEPTION;
 r_dept dept%ROWTYPE;
 BEGIN
   --赋值
   r_dept.deptno:=13;
   r_dept.loc:='qqq';
   --添加数据
   INSERT INTO dept VALUES (r_dept.deptno,r_dept.dname,r_dept.loc);
   --判断如果name为空则引发异常
   IF r_dept.dname IS NULL THEN
     --引发异常
     RAISE name_null;
   END IF;
   EXCEPTION
     WHEN name_null THEN
       dbms_output.put_line('部门名称不能为空');
       ROLLBACK;
END;

SELECT * FROM dept;


CREATE TABLE exception_a(
   str VARCHAR2(5)
);

CREATE TABLE exception_b(
     str VARCHAR2(4)
)

INSERT INTO exception_a VALUES('qqq');
INSERT INTO exception_a VALUES('www');
INSERT INTO exception_a VALUES('eee');
INSERT INTO exception_a VALUES('rrrrr');
INSERT INTO exception_a VALUES('ttt');
INSERT INTO exception_a VALUES('yyy');
INSERT INTO exception_a VALUES('uuu');

SELECT * FROM exception_a;
SELECT * FROM exception_b;

INSERT INTO exception_b SELECT * FROM exception_a;

--面试题：使用PL/SQL来实现将表A中的数据逐条添加到表B中，如果在添加的过程中出现了问题，
--则需要将问题记录下来，然后再继续添加后面的数据；
DECLARE
 --定义游标
 CURSOR cur_a IS
 SELECT * FROM exception_a;
 BEGIN
   FOR a IN cur_a LOOP
     BEGIN
     INSERT INTO exception_b VALUES(a.str);
      EXCEPTION 
     WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      END;
    END LOOP;
   EXCEPTION
     WHEN OTHERS THEN
       dbms_output.put_line('系统发生了问题');
END; 




SELECT * FROM Sql_Test;
--动态执行另外一张表中保存的sql语句
DECLARE
 CURSOR cur_sql IS
 SELECT * FROM sql_test;
 BEGIN
   FOR s IN cur_sql LOOP
    --动态执行sql
    EXECUTE IMMEDIATE s.sql_str;
    END LOOP;
 END;


SELECT * FROM dept;
--动态执行DDL语句
BEGIN
  --清空exception_b表中的数据
  EXECUTE IMMEDIATE 'drop TABLE exception_b';
END;

DECLARE
 e_name emp.ename%TYPE;
 e_job emp.job%TYPE;
BEGIN
  --将查询出来的数据保存到指定的变量中
  EXECUTE IMMEDIATE 'select ename,job from emp where empno=7369'
  INTO e_name,e_job;
  dbms_output.put_line(e_name||','||e_job);
END;
  
SELECT * FROM dept;

BEGIN
  EXECUTE IMMEDIATE 'insert into dept values(:dno,:dname,:dloc)'
  USING 81,'qq','ww';
END;


SELECT * FROM customer;
SELECT * FROM product;
SELECT * FROM order1;


--1：查询所有客户的下单货号数、下单总数量、下单总金额
--客户的下单货号数：
--下单总数量:  
--下单总金额:
SELECT COUNT(DISTINCT o.artno) 总下单货号数,
SUM(total) 总数量,
SUM(total*p.unitprice) 总金额
    FROM order1 o JOIN product p ON o.artno=p.artno; 

SELECT o.clientno,o.clientnam, COUNT(o.artno) 总下单货号数,
SUM(total) 总数量,
SUM(total*p.unitprice) 总金额
    FROM order1 o JOIN product p ON o.artno=p.artno GROUP BY o.clientno,o.clientnam; 




 
--2：查询各货号下单最多和最少的记录： 以如下的形式显示：货号，最多数量，最少数量

SELECT artno 货号,max(total)最多数量,MIN(total) 最少数量 FROM order1 GROUP BY artno;

--3：按货号分别统计各客户下单数量，总金额，实现如下表的效果；
--方式一
WITH TMP AS
 (SELECT ARTNO,
         张三,
         李四,
         王艳,
         肖五,
         (NVL(张三, 0) + NVL(李四, 0) + NVL(王艳, 0) + NVL(肖五, 0)) 小计
    FROM (SELECT CLIENTNAM, ARTNO, TOTAL FROM ORDER1)
  PIVOT(MAX(TOTAL)
     FOR CLIENTNAM IN('张三' 张三, '李四' 李四, '王艳' 王艳, '肖五' 肖五)))
SELECT T.*, 小计 * P.UNITPRICE 总金额
  FROM TMP T
  JOIN PRODUCT P
    ON T.ARTNO = P.ARTNO;
--方式二：
WITH tmp AS(
SELECT *
  FROM (SELECT ARTNO, NVL(CLIENTNAM, '小计') CLIENTNAM, SUM(TOTAL) TOTAL
          FROM ORDER1
         GROUP BY ROLLUP(ARTNO, CLIENTNAM)) 
PIVOT(MAX(TOTAL)
   FOR CLIENTNAM IN('张三' 张三,
                    '李四' 李四,
                    '王艳' 王艳,
                    '肖五' 肖五,
                    '小计' 小计)) WHERE artno IS NOT NULL)
                   SELECT T.*, 小计 * P.UNITPRICE 总金额
  FROM TMP T
  JOIN PRODUCT P
    ON T.ARTNO = P.ARTNO;

/*
4：将货号表product中各货号的库存按交期先后顺序分配到订单表order中对应的货号上面，并查询出分配结果

1.先获取所有产品库存
2.将订单表中的数据根据产品编号按照交期进行排序



货号          库存总量    交期     需求      分配       剩余     缺货
MK2017       400          1-10     230        230        170      0
             170           2-10     176        170        0       6
             0             3-10     300       0          0        300
                          
BLU31        2000
4007BW5      100
A8001        330
*/

SELECT * FROM product;

SELECT o.*,row_number()OVER(PARTITION BY artno ORDER BY o.delivery_time) FROM order1 o;

DECLARE
 --定义游标来查询每一个货物的库存
 CURSOR cur_product IS
  SELECT * FROM product;
  --定义游标来查询每一个货物按照交期排序之后的需求数据
  CURSOR cur_order IS
  SELECT o.*,row_number()OVER(PARTITION BY artno ORDER BY o.delivery_time) FROM order1 o;
  
  --定义变量保存库存
  store_n NUMBER;
  BEGIN
    --循环获取产品的库存
    FOR p IN cur_product  LOOP
      --获取库存
      store_n:=p.reportery;
      dbms_output.put_line('货号：'||p.artno||',总库存：'||store_n);
      --dbms_output.put_line(store_n);
      FOR o IN cur_order LOOP
        --判断当前的货号是否是上面对应的货物的货号
        IF o.artno=p.artno THEN
          --可以分配，判断库存是否满足需求
          IF o.total<store_n THEN
            --如果需求小于库存，则分配需求所需数量
            dbms_output.put_line('交期：'||o.delivery_time||',需求：'||o.total||',分配：'||o.total||',剩余：'||(store_n-o.total)||',缺货：0');
            --更新库存
            store_n:=store_n-o.total;
          ELSE
            --如果需求大于库存，则将所有库存都分配
            dbms_output.put_line('交期：'||o.delivery_time||',需求：'||o.total||',分配：'||store_n||',剩余：0,缺货：'||(o.total-store_n));
            --更新库存
            store_n:=0;
          END IF;
         END IF;
        END LOOP;
    END LOOP;  
  END;
      






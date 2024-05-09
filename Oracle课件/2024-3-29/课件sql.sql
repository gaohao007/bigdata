--����һ���α꣬������ѯָ�����ŵ�Ա���������͹���
DECLARE
 --�����α�
 CURSOR cur_emp(dno NUMBER) IS
 SELECT ename,sal FROM emp WHERE deptno=dno;
 --��������
 e_name emp.ename%TYPE;
 e_sal emp.sal%TYPE;
BEGIN
  --���α�
  OPEN cur_emp(20);
  
  --ʹ��ѭ������ζ�ȡ�α��е�����
  LOOP
    --��ȡ�α�
    FETCH cur_emp INTO e_name,e_sal;  
    EXIT WHEN cur_emp%NOTFOUND;
    --�������
    dbms_output.put_line(e_name||','||e_sal);
    END LOOP;
  --�ر��α�
  CLOSE cur_emp;
END;

--ʹ��whileѭ��
DECLARE
 --�����α�
 CURSOR cur_emp(dno NUMBER) IS
 SELECT ename,sal FROM emp WHERE deptno=dno;
 --��������
 e_name emp.ename%TYPE;
 e_sal emp.sal%TYPE;
BEGIN
  --���α�
  OPEN cur_emp(20);
  --ʹ��ѭ������ζ�ȡ�α��е�����
  --��ȡ�α�
  FETCH cur_emp INTO e_name,e_sal;  
  WHILE cur_emp%FOUND LOOP
    --�������
    dbms_output.put_line(e_name||','||e_sal);
     --��ȡ�α�
    FETCH cur_emp INTO e_name,e_sal;  
    END LOOP;
  --�ر��α�
  CLOSE cur_emp;
END;

--ʹ��forѭ������ȡ�α�
DECLARE
 --�����α�
 CURSOR cur_emp(dno NUMBER) IS
 SELECT ename,sal FROM emp WHERE deptno=dno;
 BEGIN
   --ʹ��ѭ�������α�
   FOR r_emp IN cur_emp(20) LOOP
     --������
     dbms_output.put_line(r_emp.ename||','||r_emp.sal);
   END LOOP;
 END;  
     
--������ȡ�α����
--ʹ��forѭ������ȡ�α�
DECLARE
 --�����α�
 CURSOR cur_emp IS
 SELECT * FROM emp WHERE deptno=20;
 --����һ��������
 TYPE type_table IS TABLE OF emp%ROWTYPE;
 --���������ͱ���
 r_emp type_table;
 BEGIN
   --���α�
   OPEN cur_emp;
   --��ȡ�α�
   FETCH cur_emp BULK COLLECT INTO r_emp;
   --ʹ��forѭ�������ݴ�ӡ����
   FOR i IN r_emp.first..r_emp.last LOOP
     dbms_output.put_line(r_emp(i).ename||','||r_emp(i).sal);
   END LOOP;
END;
   
--������ȡemp���е�����ÿ�ζ�ȡ5��
DECLARE
 CURSOR cur_emp IS
 SELECT * FROM emp;
  --����һ��������
 TYPE type_table IS TABLE OF emp%ROWTYPE;
 --���������ͱ���
 r_emp type_table;
 --���������¼����
 c NUMBER:=0;
 BEGIN
   --���α�
   OPEN cur_emp;
   --ѭ����ȡ�α�
   LOOP
     c:=c+1;
     
     FETCH cur_emp BULK COLLECT INTO r_emp LIMIT 5;
     --�����ȡ��������������Ϊ0��������ݶ�ȡ���
     EXIT WHEN r_emp.count=0;
     --������ȡ����
     dbms_output.put_line('��'||c||'����ȡ���ݣ�');
      --ʹ��forѭ�������ݴ�ӡ����
       FOR i IN r_emp.first..r_emp.last LOOP
         dbms_output.put_line(r_emp(i).ename||','||r_emp(i).sal);
       END LOOP;
     END LOOP;
     
   --�ر��α�
   CLOSE cur_emp;
  END;
     
--ʹ��select ..bulk collect����ȡ����
DECLARE
    --����һ��������
 TYPE type_table IS TABLE OF emp%ROWTYPE;
 --���������ͱ���
 r_emp type_table;
 --����һ��ѭ������
 n NUMBER:=1;
 --����
 page NUMBER:=0;
 BEGIN
   --��ȡ����
   SELECT ceil(count(*)/5) INTO page FROM emp;
   --ѭ����ȡ
   WHILE n<=page LOOP
          dbms_output.put_line('��'||n||'����ȡ���ݣ�');
         SELECT empno,ename,job,mgr,hiredate,sal,comm,deptno BULK COLLECT INTO r_emp FROM(  
         SELECT e.*,ROWNUM rn FROM emp e) WHERE rn BETWEEN (n-1)*5+1 AND 5*n; 
   --ʹ��forѭ�������ݴ�ӡ����
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

--����һ���α꣬������ѯָ�����ŵ�Ա���������͹���
DECLARE
 --�����α�
 CURSOR cur_emp(dno NUMBER) IS
 SELECT ename,sal FROM emp WHERE deptno=dno;
 --��������
 e_name emp.ename%TYPE;
 e_sal emp.sal%TYPE;
BEGIN
  
  OPEN cur_emp(20);
  IF cur_emp%ISOPEN THEN
    dbms_output.put_line('�α��Ѿ�����');
  ELSE
    --���α�
    OPEN cur_emp(20);
  END IF;
  --ʹ��ѭ������ζ�ȡ�α��е�����
  LOOP
    --��ȡ�α�
    FETCH cur_emp INTO e_name,e_sal;  
    EXIT WHEN cur_emp%NOTFOUND;
    --�������
    dbms_output.put_line(e_name||','||e_sal);
    END LOOP;
  --�ر��α�
  CLOSE cur_emp;
END;


--��Ա�����е�20�Ų��ŵ�Ա���Ĺ����ϵ�20%����������ϵ�������
BEGIN
  --�ϵ�����
  UPDATE emp SET sal=sal*1.2 WHERE deptno=20;
    --����ϵ�����
  dbms_output.put_line('�ϵ�������Ϊ��'||sql%ROWCOUNT);
  --ɾ��Ա��
  DELETE FROM emp WHERE deptno=30;
  dbms_output.put_line('ɾ��������Ϊ��'||sql%ROWCOUNT);
END;
  
SELECT * FROM emp;


--��ѯ20�Ų��ŵ�Ա������Ϣ
--��ʽ�α�
DECLARE
 CURSOR cur_emp IS
 SELECT * FROM emp WHERE deptno=20;
 BEGIN
   FOR r IN cur_emp LOOP
     dbms_output.put_line(r.ename||','||r.sal);
   END LOOP;
END;

--��ʽ�α�
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
     dbms_output.put_line('û�в�ѯ������');
   WHEN too_many_rows THEN
     dbms_output.put_line('��ѯ����������');
   WHEN invalid_cursor THEN
     dbms_output.put_line('���ܹر�û�д򿪵��α�');
   WHEN OTHERS THEN
     dbms_output.put_line('�������쳣'||sqlcode||','||Sqlerrm);
END;


SELECT * FROM dept;

--�������쳣
DECLARE
--����һ���쳣����
  primary_err EXCEPTION;
  --���쳣�����ʹ����Ž��а�
  PRAGMA EXCEPTION_INIT(primary_err,-00001); 
BEGIN
       INSERT INTO dept VALUES(10,'','');
       EXCEPTION
         WHEN primary_err THEN
           dbms_output.put_line('���������ظ���');
END;


--����һ���쳣����������ű���������ݵ�ʱ�򣬲�������Ϊ�������Ҫ����һ���쳣��
DECLARE
 --����һ���쳣����
 name_null EXCEPTION;
 r_dept dept%ROWTYPE;
 BEGIN
   --��ֵ
   r_dept.deptno:=13;
   r_dept.loc:='qqq';
   --�������
   INSERT INTO dept VALUES (r_dept.deptno,r_dept.dname,r_dept.loc);
   --�ж����nameΪ���������쳣
   IF r_dept.dname IS NULL THEN
     --�����쳣
     RAISE name_null;
   END IF;
   EXCEPTION
     WHEN name_null THEN
       dbms_output.put_line('�������Ʋ���Ϊ��');
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

--�����⣺ʹ��PL/SQL��ʵ�ֽ���A�е�����������ӵ���B�У��������ӵĹ����г��������⣬
--����Ҫ�������¼������Ȼ���ټ�����Ӻ�������ݣ�
DECLARE
 --�����α�
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
       dbms_output.put_line('ϵͳ����������');
END; 




SELECT * FROM Sql_Test;
--��ִ̬������һ�ű��б����sql���
DECLARE
 CURSOR cur_sql IS
 SELECT * FROM sql_test;
 BEGIN
   FOR s IN cur_sql LOOP
    --��ִ̬��sql
    EXECUTE IMMEDIATE s.sql_str;
    END LOOP;
 END;


SELECT * FROM dept;
--��ִ̬��DDL���
BEGIN
  --���exception_b���е�����
  EXECUTE IMMEDIATE 'drop TABLE exception_b';
END;

DECLARE
 e_name emp.ename%TYPE;
 e_job emp.job%TYPE;
BEGIN
  --����ѯ���������ݱ��浽ָ���ı�����
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


--1����ѯ���пͻ����µ����������µ����������µ��ܽ��
--�ͻ����µ���������
--�µ�������:  
--�µ��ܽ��:
SELECT COUNT(DISTINCT o.artno) ���µ�������,
SUM(total) ������,
SUM(total*p.unitprice) �ܽ��
    FROM order1 o JOIN product p ON o.artno=p.artno; 

SELECT o.clientno,o.clientnam, COUNT(o.artno) ���µ�������,
SUM(total) ������,
SUM(total*p.unitprice) �ܽ��
    FROM order1 o JOIN product p ON o.artno=p.artno GROUP BY o.clientno,o.clientnam; 




 
--2����ѯ�������µ��������ٵļ�¼�� �����µ���ʽ��ʾ�����ţ������������������

SELECT artno ����,max(total)�������,MIN(total) �������� FROM order1 GROUP BY artno;

--3�������ŷֱ�ͳ�Ƹ��ͻ��µ��������ܽ�ʵ�����±��Ч����
--��ʽһ
WITH TMP AS
 (SELECT ARTNO,
         ����,
         ����,
         ����,
         Ф��,
         (NVL(����, 0) + NVL(����, 0) + NVL(����, 0) + NVL(Ф��, 0)) С��
    FROM (SELECT CLIENTNAM, ARTNO, TOTAL FROM ORDER1)
  PIVOT(MAX(TOTAL)
     FOR CLIENTNAM IN('����' ����, '����' ����, '����' ����, 'Ф��' Ф��)))
SELECT T.*, С�� * P.UNITPRICE �ܽ��
  FROM TMP T
  JOIN PRODUCT P
    ON T.ARTNO = P.ARTNO;
--��ʽ����
WITH tmp AS(
SELECT *
  FROM (SELECT ARTNO, NVL(CLIENTNAM, 'С��') CLIENTNAM, SUM(TOTAL) TOTAL
          FROM ORDER1
         GROUP BY ROLLUP(ARTNO, CLIENTNAM)) 
PIVOT(MAX(TOTAL)
   FOR CLIENTNAM IN('����' ����,
                    '����' ����,
                    '����' ����,
                    'Ф��' Ф��,
                    'С��' С��)) WHERE artno IS NOT NULL)
                   SELECT T.*, С�� * P.UNITPRICE �ܽ��
  FROM TMP T
  JOIN PRODUCT P
    ON T.ARTNO = P.ARTNO;

/*
4�������ű�product�и����ŵĿ�水�����Ⱥ�˳����䵽������order�ж�Ӧ�Ļ������棬����ѯ��������

1.�Ȼ�ȡ���в�Ʒ���
2.���������е����ݸ��ݲ�Ʒ��Ű��ս��ڽ�������



����          �������    ����     ����      ����       ʣ��     ȱ��
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
 --�����α�����ѯÿһ������Ŀ��
 CURSOR cur_product IS
  SELECT * FROM product;
  --�����α�����ѯÿһ�����ﰴ�ս�������֮�����������
  CURSOR cur_order IS
  SELECT o.*,row_number()OVER(PARTITION BY artno ORDER BY o.delivery_time) FROM order1 o;
  
  --�������������
  store_n NUMBER;
  BEGIN
    --ѭ����ȡ��Ʒ�Ŀ��
    FOR p IN cur_product  LOOP
      --��ȡ���
      store_n:=p.reportery;
      dbms_output.put_line('���ţ�'||p.artno||',�ܿ�棺'||store_n);
      --dbms_output.put_line(store_n);
      FOR o IN cur_order LOOP
        --�жϵ�ǰ�Ļ����Ƿ��������Ӧ�Ļ���Ļ���
        IF o.artno=p.artno THEN
          --���Է��䣬�жϿ���Ƿ���������
          IF o.total<store_n THEN
            --�������С�ڿ�棬�����������������
            dbms_output.put_line('���ڣ�'||o.delivery_time||',����'||o.total||',���䣺'||o.total||',ʣ�ࣺ'||(store_n-o.total)||',ȱ����0');
            --���¿��
            store_n:=store_n-o.total;
          ELSE
            --���������ڿ�棬�����п�涼����
            dbms_output.put_line('���ڣ�'||o.delivery_time||',����'||o.total||',���䣺'||store_n||',ʣ�ࣺ0,ȱ����'||(o.total-store_n));
            --���¿��
            store_n:=0;
          END IF;
         END IF;
        END LOOP;
    END LOOP;  
  END;
      






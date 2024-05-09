SELECT * FROM emp WHERE sal=3000;

SELECT * FROM student;

UPDATE student SET sno=REPLACE(sno,'s');

SELECT * FROM student WHERE  sno=001;


SELECT * FROM range_table;
--�ڷ������ϴ�����������
CREATE INDEX local_index ON range_table(NAME) LOCAL;
DROP INDEX local_index;

--�ڷ������ϴ���һ��ȫ������
DROP INDEX global_index;
CREATE INDEX global_index ON range_table(NAME) GLOBAL
PARTITION BY HASH(NAME)
(PARTITION index_p1,
PARTITION index_p2);


--��ѯ��ְ����Ϊ2023���Ա������Ϣ
--ԭ����������������ʧЧ
SELECT * FROM emp WHERE to_char(hiredate,'yyyy')=2023;
--����һ������
CREATE INDEX hiredate_ind ON emp(hiredate);
--�Ż�֮��ķ�����������Ч
SELECT *
  FROM EMP
 WHERE HIREDATE BETWEEN TO_DATE('2023-1-1', 'yyyy-mm-dd') AND
       TO_DATE('2023-12-31', 'yyyy-mm-dd');


SELECT * FROM emp WHERE sal=3000-500;
SELECT  * FROM emp WHERE empno>7369;


--SELECT * FROM emp WHERE sal<>3000;

--��ѯ���ʴ������ڲ��ŵ�ƽ�����ʵ�Ա��
SELECT * FROM emp e WHERE sal>(SELECT AVG(sal) FROM emp WHERE deptno=e.deptno)



--����ִ�мƻ�
EXPLAIN PLAN 
FOR SELECT * FROM emp WHERE sal=3000-500;
--�鿴ִ�мƻ�
SELECT * FROM TABLE(dbms_xplan.display);

SELECT sname,sage FROM student WHERE sname='����';
SELECT * FROM student WHERE sname='����';
SELECT COUNT(sname) FROM student;

DROP INDEX index_t;
CREATE INDEX index_name ON student(sname,sage);


SELECT ROWID FROM emp;
SELECT * FROM emp WHERE ROWID='AAAWG7AAEAAAM5/AAA'


SELECT  * FROM emp e JOIN dept d ON e.deptno=d.deptno;

--�޸�ִ�мƻ�����ȫ��ɨ��   +full(����)
SELECT /*+full(s)*/ sname,sage FROM student s WHERE sname='����';
--�޸�ִ�мƻ���ʹ�õ�����   +index(����,������,������,...)
SELECT /*+index(emp,INDX_NAME_JOB)*/ * FROM emp WHERE ename='SCOTT';

--�޸ı�����ӷ�ʽ����ϲ����ӣ� +use_merge(����,����)
SELECT /*+use_merge(e,d)*/  * FROM emp e JOIN dept d ON e.deptno=d.deptno;

--�޸ı�����ӷ�ʽΪѭ��Ƕ�ף�+use_nl(����,����)
SELECT /*+use_nl(e,d)*/  * FROM emp e JOIN dept d ON e.deptno=d.deptno;

--�޸�ʹ��hash join��ʽ���ӣ�use_hash(����,����)
SELECT /*+use_hash(e,d)*/  * FROM emp e JOIN dept d ON e.deptno=d.deptno;


SELECT a.*,LAG(����,1,0)OVER(ORDER BY sdate) ��ȥ���� from(
SELECT s.*,LEAD(sdate,1,to_date('2023-3-31','yyyy-mm-dd')) OVER(ORDER BY sdate)-sdate ���� FROM shiti s)
a;

DECLARE
 --�����α�
  CURSOR cur_t IS
SELECT a.*,LAG(����,1,0)OVER(ORDER BY sdate) ��ȥ���� from(
SELECT s.*,LEAD(sdate,1,to_date('2023-3-31','yyyy-mm-dd')) OVER(ORDER BY sdate)-sdate ���� FROM shiti s)
a;
--������������ۼ�ֵ
lj NUMBER:=0;
--����������浱��Ԥ��ֵ
yg NUMBER:=0;
--�����ۼƵ�����
ljts NUMBER:=0;
BEGIN
  FOR t IN cur_t LOOP
    ljts:=t.��ȥ����+ljts;
    --���㵱��Ԥ��
    yg:=(t.ys-lj)/(31-ljts);
    --ѭ������
    FOR i IN 1..t.���� LOOP
      --�ۼ�ֵ
      lj:=lj+yg;
      dbms_output.put_line(to_char((t.sdate+i),'yyyymmdd')||',����Ԥ����'||round(yg,8)||',����Ԥ����'||round(lj,8));
    END LOOP;
  END LOOP;
END;


/*
��ҵ1.������һ���������Ȼ���װһ�´洢���̺ͺ�����
1.�洢���̣��Բ��ű��Ϊ�����������ְ���������3��Ա������������ź�ְλ
2.��������Ա����Ϊ���������ظ�Ա�����ڵĲ��ŵ�ƽ�����ʡ�
3.�洢���̣���Ա���źͲ��ź���Ϊ�������޸�Ա�����ڵĲ���Ϊ������Ĳ��źš�
����޸ĳɹ�������ʾ��Ա���ɡ����Ų��ŵ�����롭���Ų��š�����������ڸ�Ա����
����ʾ��Ա���Ų����ڣ���������ȷ��Ա���š�������������ڸò��ţ�
����ʾ���ò��Ų����ڣ���������ȷ�Ĳ��źš�����
4.�洢���̣���һ������Ϊ���������빤����ߵ�ǰ����������ֵ��Ա������Ϣ��
Ȼ������ϵĴ洢���̺ͺ������е��ò��ԡ�
*/

--����淶
CREATE OR REPLACE PACKAGE pack_zy
IS
--����һ���α�����
TYPE type_cursor IS REF CURSOR;
--�����洢����
PROCEDURE pro_top3(dno IN NUMBER,emp_r OUT type_cursor);
--��������
FUNCTION fun_avg_sal(eno NUMBER) RETURN NUMBER;
--�����洢����
PROCEDURE pro_update(eno NUMBER,dno NUMBER);
--�����洢����
PROCEDURE pro_topn(n NUMBER,topn_emp OUT type_cursor);
END;


--��������
CREATE OR REPLACE PACKAGE body pack_zy
IS
--�洢����
PROCEDURE pro_top3(dno IN NUMBER,emp_r OUT type_cursor)
  IS
  BEGIN
    OPEN emp_r FOR SELECT * FROM(
    SELECT * FROM emp WHERE deptno=dno ORDER BY hiredate) WHERE ROWNUM<=3;
 END  pro_top3;
--����
FUNCTION fun_avg_sal(eno NUMBER) RETURN NUMBER
  IS
  avg_sal NUMBER;
  BEGIN
  SELECT AVG(sal) INTO avg_sal FROM emp WHERE deptno=(SELECT deptno FROM emp WHERE empno=eno);
  --��������
  RETURN avg_sal;
END fun_avg_sal;
  
--�洢����
PROCEDURE pro_update(eno NUMBER,dno NUMBER)
  IS
  --�������
  cou NUMBER;
  d_no NUMBER;
  BEGIN
    SELECT COUNT(*) INTO cou FROM emp WHERE empno=eno;
    IF cou!=0 THEN
      --�жϲ����Ƿ����
      SELECT COUNT(*) INTO cou FROM dept WHERE deptno=dno;
      IF cou!=0 THEN
        --��ѯԭ���Ĳ��ź�
        SELECT deptno INTO d_no FROM emp WHERE empno=eno;
        --�����ڣ�ִ�и��²���
        UPDATE emp SET deptno=dno WHERE empno=eno;
        --��ӡ����
        dbms_output.put_line('Ա����'||d_no||'���ŵ��뵽��'||dno||'���ţ�');
      ELSE
        dbms_output.put_line('�ò��Ų�����');
      END IF;
    ELSE
      dbms_output.put_line('��Ա��������');
    END IF;
END pro_update;

--�洢����
PROCEDURE pro_topn(n NUMBER,topn_emp OUT type_cursor)
  IS
  BEGIN
  OPEN topn_emp FOR SELECT * FROM ( 
  SELECT * FROM emp ORDER BY sal DESC) WHERE ROWNUM<=n;
END pro_topn;
END;

--���ã�
SELECT pack_zy.fun_avg_sal(7369) FROM dual;


DECLARE 
 --����Ӧ���α����ͱ���
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
 --����Ӧ���α����ͱ���
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





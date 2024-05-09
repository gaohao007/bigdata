--��дһ��PL/SQL����ʵ���������ֵ���
--��������
DECLARE
  --��������a=10
  a NUMBER:=10;
  --��������b=20
  b number:=10;
  --����һ������c��������������
  c NUMBER;
  --������һ���ַ�������
  str VARCHAR2(20):='hello';
  --����һ������
  PI CONSTANT NUMBER:=3.14;
  --ִ�в���
  BEGIN
   -- PI:=4.14;   �����������޸�
    a:=20;
    --20:=a    �﷨����
    --������
    c:=a/b;
    --���c
    dbms_output.put_line(c);
    --�쳣����
    EXCEPTION
      WHEN zero_divide THEN
        dbms_output.put_line('��������Ϊ0');
  END;
  
 
--���û�����һ���뾶��������Բ�����
--��������
DECLARE
 --�������������û�����İ뾶
 r NUMBER:=&r;
 --����һ������
 PI CONSTANT NUMBER:=3.14;
 --���������������
 area NUMBER;
 BEGIN
   --����
   area:=PI*POWER(r,2);
   --������
   dbms_output.put_line('Բ�ε����Ϊ:'||area);
 END;



--��ѯԱ�����й���7369��Ա����������ְλ
DECLARE
 --��������
 e_name VARCHAR2(20);
 e_job VARCHAR2(20);
 BEGIN
   SELECT ename,job INTO e_name,e_job  FROM emp WHERE empno=7369;
   --���
   dbms_output.put_line(e_name||','||e_job);
   --���dept���е�����
   --TRUNCATE TABLE dept;
END;
   
--ʹ��%type����
--��ѯԱ�����й���7369��Ա����������ְλ
DECLARE
 --��������
 e_name emp.ename%TYPE;
 e_job emp.job%TYPE;
 BEGIN
   SELECT ename,job INTO e_name,e_job  FROM emp WHERE empno=7369;
   --���
   dbms_output.put_line(e_name||','||e_job);
   --���dept���е�����
   --TRUNCATE TABLE dept;
END;

SELECT * FROM emp;

--��ѯ7369Ա�������е���Ϣ
DECLARE
 --����һ��rowtype���͵ı���
 r_emp emp%ROWTYPE;
 BEGIN
   SELECT * INTO r_emp FROM emp WHERE empno=7369;
   --�������
   dbms_output.put_line(r_emp.ename||','||r_emp.job||','||r_emp.sal);
END;


--��ѯԱ�����й�����ߵ�Ա������Ϣ

DECLARE
 --����һ��rowtype���͵ı���
 r_emp emp%ROWTYPE;
 BEGIN
   SELECT empno,ename,job,mgr,hiredate,sal,comm,deptno INTO r_emp FROM (
   SELECT e.*,row_number()OVER(ORDER BY sal DESC) rn FROM emp e) WHERE rn=1;
   --�������
   dbms_output.put_line(r_emp.ename||','||r_emp.job||','||r_emp.sal);
END;
 

--��ѯԱ������7369��Ա����������ְλ�������Լ������ڲ��ŵ�ƽ������
DECLARE
  --����һ����¼����
  TYPE type_emp IS RECORD(
   e_name emp.ename%TYPE,
   e_job emp.job%TYPE,
   e_sal emp.sal%TYPE,
   avg_sal NUMBER
  );
 --�����¼���ͱ���
  r_emp type_emp;
 BEGIN
   --SELECT ename,job,sal,(SELECT AVG(sal) FROM emp WHERE deptno=e.deptno) ƽ������ FROM emp e WHERE empno=7369;
   SELECT ename,job,sal,avg_sal INTO r_emp FROM(
   SELECT e.*,AVG(sal)OVER(PARTITION BY deptno) avg_sal FROM emp e)  WHERE empno=7369;
     --�������
   dbms_output.put_line(r_emp.e_name||','||r_emp.e_job||','||r_emp.e_sal||','||r_emp.avg_sal);
END;
  

SELECT * FROM emp;

--��ѯ7369Ա����ְλ�����ְλ"PRESIDENT"������ܲã����������Ա��
DECLARE
 e_job emp.job%TYPE;
 BEGIN
   SELECT job INTO e_job FROM emp WHERE empno=7839;
   --�ж�
   IF e_job='PRESIDENT' THEN
     dbms_output.put_line('�ܲ�');
   ELSE
     dbms_output.put_line('Ա��');
   END IF;
END;


--����һ��Ա���ı�ţ���ѯ��Ա����ְλ����ְλ��ʾΪ����
DECLARE
  e_job emp.job%TYPE;
  BEGIN
    --��ѯ����
    SELECT job INTO e_job FROM emp WHERE empno=&eno;
    --�ж�ְλ
    IF e_job='SALESMAN' THEN
      dbms_output.put_line('����Ա');
    ELSIF e_job='CLERK' THEN
      dbms_output.put_line('����Ա');
      ELSIF e_job='MANAGER' THEN
      dbms_output.put_line('����');
      ELSIF e_job='ANALYST' THEN
      dbms_output.put_line('����Ա');
      ELSE
        dbms_output.put_line('�ܲ�');
      END IF;
END;

--����һ��ѧ���ĳɼ����жϳɼ��ȼ�
DECLARE
 score NUMBER:=&s;
 BEGIN
   IF score >100 OR score<0 THEN
     dbms_output.put_line('�ɼ���Ч');
   ELSIF score>=90 THEN
     dbms_output.put_line('����');
   ELSIF score>=80 THEN
     dbms_output.put_line('����');
     ELSIF score>=60 THEN
     dbms_output.put_line('����'); 
    ELSE 
     dbms_output.put_line('������'); 
  END IF;
END;


--����һ��Ա���ı�ţ���ѯ��Ա����ְλ����ְλ��ʾΪ����
DECLARE
  e_job emp.job%TYPE;
  BEGIN
    --��ѯ����
    SELECT job INTO e_job FROM emp WHERE empno=&eno;
    --�ж�ְλ
    CASE e_job  WHEN 'SALESMAN' THEN
                      dbms_output.put_line('����Ա');
                WHEN 'CLERK' THEN
                     dbms_output.put_line('����Ա');
                WHEN 'MANAGER' THEN
                     dbms_output.put_line('����');
                WHEN 'ANALYST' THEN
                     dbms_output.put_line('����Ա');
                ELSE
                     dbms_output.put_line('�ܲ�');
        END CASE;
END;

--����һ��ѧ���ĳɼ����жϳɼ��ȼ�
DECLARE
 score NUMBER:=&s;
 BEGIN
   CASE WHEN score >100 OR score<0 THEN
     dbms_output.put_line('�ɼ���Ч');
   WHEN score>=90 THEN
     dbms_output.put_line('����');
   WHEN score>=80 THEN
     dbms_output.put_line('����');
     WHEN score>=60 THEN
     dbms_output.put_line('����'); 
    ELSE 
     dbms_output.put_line('������'); 
  END CASE;
END;



--����һ����ݣ��ж��Ƿ�������
--�����������ܱ�4�������ǲ��ܱ�100�����������ܱ�400����
DECLARE
  YEAR NUMBER:=&YEAR;
  BEGIN
    --�ж��Ƿ�������
    IF MOD(YEAR,4)=0 AND MOD(YEAR,100)<>0 OR MOD(YEAR,400)=0 THEN
      dbms_output.put_line('������');
    ELSE
      dbms_output.put_line('��������');
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
--ʹ��ѭ������ӡ1-5
DECLARE
  i NUMBER:=1;
  BEGIN
    --ѭ��
    LOOP
        dbms_output.put_line(i);
        i:=i+1;
     EXIT WHEN i>10;
     END LOOP;
 END;

--����1-100�ĺ�
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

ѭ��������i=1
ѭ��������i<=100
ѭ���壺sum1:=sum1+i
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
   --������
   dbms_output.put_line('1-100�ĺ�Ϊ��'||sum1);
END;



--��ӡ1-10
DECLARE
 --����ѭ������
 i NUMBER:=1;
 BEGIN
   WHILE i<=10 LOOP
     dbms_output.put_line(i);
     --ѭ����������
     i:=i+1;
   END LOOP;
END;

--����1-100�ĺ�
DECLARE
 sum1 NUMBER :=0;
 i NUMBER:=1;
 BEGIN
   WHILE i<=100 LOOP
     sum1:=sum1+i;
     --����
     i:=i+1;
   END LOOP;
      --������
   dbms_output.put_line('1-100�ĺ�Ϊ��'||sum1);
END;

--ʹ��forѭ����ӡ1-10
BEGIN
  FOR i IN 1..10 LOOP
    dbms_output.put_line(i);
  END LOOP;
END;

--��ӡ10-1
BEGIN
  FOR i IN REVERSE 1..10 LOOP
    dbms_output.put_line(i);
  END LOOP;
END;

--��ӡ10-1
DECLARE
 --����ѭ������
 i NUMBER:=10;
 BEGIN
   WHILE i>0 LOOP
     dbms_output.put_line(i);
     --ѭ����������
     i:=i-1;
   END LOOP;
END;



--ʹ��forѭ������1-100�ĺ�
DECLARE
 sum1 NUMBER:=0;
 BEGIN
   FOR i IN 1..100 LOOP
     sum1:=sum1+i;
   END LOOP;
         --������
   dbms_output.put_line('1-100�ĺ�Ϊ��'||sum1);
END;


--��ӡ1-10
DECLARE
 i NUMBER:=1;
 BEGIN
   WHILE TRUE LOOP
     --���i����10�����ѭ��
     IF i>10 THEN
       EXIT;
     END IF;
     dbms_output.put_line(i);
     i:=i+1;
   END LOOP;
 END;


--��ӡ���ڶ����ܱ�17����������
DECLARE
 --����ѭ������
 i NUMBER:=1;
 --���������������¼�������Ĵ���
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
     --ѭ������Ҫ����
     i:=i+1;
    END LOOP;
 END;    


--��ӡ1-10�г���3֮�������
BEGIN
  FOR i IN 1..10 LOOP
    IF i=3 THEN
      CONTINUE;
    END IF;
    dbms_output.put_line(i);
  END LOOP;         
 END;






--��ѯ20�Ų��ŵ�Ա����������ְλ������
DECLARE
  --����һ��������
  TYPE table_emp IS TABLE OF emp%ROWTYPE;
  --����һ�������͵ı���
  t_emp table_emp;
BEGIN
  SELECT * BULK COLLECT INTO t_emp FROM emp WHERE deptno=20;
  --ѭ����ȡ�������б��������
  FOR i IN t_emp.first..t_emp.last LOOP
    dbms_output.put_line(t_emp(i).ename||','||t_emp(i).job);
  END LOOP;
END;


SELECT * FROM emp WHERE deptno=20;


SELECT * FROM T_STU ;
SELECT * FROM t_s_c;
SELECT * FROM t_course;

--����Ϊ�ﵽ����Ч������ѧ��ѡ�޵Ŀγ�������ʾ��һ���У���Ҫ���ճɼ�������ʾ������ʾ��߳ɼ��Ŀγ���
--��ʽһ��
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
 
--��ʽ����
 
 WITH TMP AS
  (SELECT S.ID,
          NAME,
          COURSE,
          CID,
          COURSENAME,
          ROW_NUMBER() OVER(PARTITION BY S.ID, NAME ORDER BY COURSE DESC) ����
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
  START WITH ���� = 1
 CONNECT BY ID = PRIOR ID
        AND PRIOR ���� = ���� - 1;


-- �����⣺������һ����Ա��ַ���ṹ���£����е�ַ���д洢�ĸ�ʽΪʡ-��-�أ�����
/*
create table addr_table(
       a_name varchar(20),
       a_addr varchar(50)
);

insert into addr_table values('����','����-�˲�-���');
insert into addr_table values('����','���ɹ�-���ͺ���-��ˮ��');
insert into addr_table values('С��','�㶫-����-����');
*/
  
SELECT DISTINCT a_name,regexp_substr(a_addr,'[^-]+',1,LEVEL) addr,
DECODE(LEVEL,1,'ʡ',2,'��',3,'��/��')
 FROM addr_table CONNECT BY LEVEL<=regexp_count(a_addr,'-')+1;
  
 

/*
�������
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

--��дһ��SQL����year����ȡvalueǰ��С��ǰ����ʱ��Ӧ��user_id�ֶΣ�ע�⣺�豣��value��С������user_id����λ

/*
�������
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
�ڰ����
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
�ھ����
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
  
  

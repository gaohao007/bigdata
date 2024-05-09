--��ѯԱ���Ĺ�����ߵ�Ա������Ϣ
SELECT * FROM(
SELECT * FROM emp ORDER BY sal DESC) WHERE ROWNUM=1;

--����һ����ͼ������Ա�����ʽ��������Ľ��
CREATE OR REPLACE VIEW view_emp_sal
AS
SELECT * FROM  emp ORDER BY sal DESC;
SELECT * FROM view_emp_sal WHERE ROWNUM=1;
SELECT * FROM view_emp_sal WHERE ROWNUM<=3;
--����ͼ�е�7369Ա�����Ĺ����ϵ�20%
UPDATE view_emp_sal SET sal=sal*1.2 WHERE empno=7369;

--����һ����ͼ����������Ա���Ĺ��ʺͽ���
CREATE OR REPLACE VIEW View_Emp
AS
SELECT empno,ename,job,mgr,hiredate,deptno FROM emp;

SELECT * FROM View_Emp;


--����һ����ͼ������ÿһ�����ŵ�ƽ������
CREATE OR REPLACE VIEW view_sal(dno,avg_sal)
AS
SELECT deptno,AVG(sal) FROM emp GROUP BY deptno;

SELECT * FROM view_sal;
--�оۺϺ�������ͼ�ǲ������޸ġ�
--UPDATE view_sal SET avg_sal=3000 WHERE dno=20


--������ͼ����Ա����Ͳ��ű���й���
CREATE OR REPLACE VIEW view_e_d
AS
SELECT e.*,dname,loc FROM emp e JOIN dept d ON e.deptno=d.deptno;

SELECT * FROM view_e_d;

--�޸�7369Ա���Ĺ��ʺͽ���
UPDATE view_e_d SET sal=1000,comm=1000 WHERE empno=7369;
--�޸�7369Ա���Ĺ��ʺͲ������ƣ�������ֱ���޸ģ�
--UPDATE view_e_d SET sal=1000,dname='���۲�' WHERE empno=7369;



--����һ���ﻯ��ͼ���������沿�ű���Ϣ
CREATE MATERIALIZED VIEW mv_dept 
AS 
SELECT * FROM dept;

SELECT * FROM mv_dept;
--�������
INSERT  INTO dept VALUES(80,'zzz','mmmmmm');
--�ֶ�ͬ������
BEGIN
  dbms_mview.refresh('mv_dept','C');
END;


--����һ���ﻯ��ͼ���������沿�ű���Ϣ,һ��ʼ������Ҫͬ������
CREATE MATERIALIZED VIEW mv_dept1 
BUILD DEFERRED 
REFRESH COMPLETE
ON COMMIT
AS 
SELECT * FROM dept;
SELECT * FROM mv_dept1;
--�ֶ�ͬ������
BEGIN
  dbms_mview.refresh('mv_dept1','F');
END;
--�������
INSERT  INTO dept VALUES(81,'dddd','tttttt');
--�ύ����
COMMIT;

--����һ���ﻯ��ͼ���������沿�ű���Ϣ,ÿ��һ����ͬ��һ������
CREATE MATERIALIZED VIEW mv_dept2 
REFRESH COMPLETE
START WITH SYSDATE NEXT SYSDATE+1/24/60
AS 
SELECT * FROM dept;
DROP MATERIALIZED VIEW mv_dept2;



SELECT * FROM mv_dept2;
--�������
INSERT  INTO dept VALUES(83,'kkkkk','ooooo');
UPDATE dept SET dname='pppppp' WHERE deptno=80;
DELETE FROM dept WHERE deptno=82;


--������ͼ��־
CREATE MATERIALIZED VIEW LOG ON dept;
SELECT * FROM mlog$_dept;

DROP MATERIALIZED VIEW LOG ON dept;

DROP MATERIALIZED VIEW mv_dept1;



--����һ��Ĭ�����У�
CREATE SEQUENCE seq_2;

--����һ�����У�����10
CREATE SEQUENCE seq_3
START WITH 10
INCREMENT BY 10
MINVALUE 10
MAXVALUE 100000000000000000000
CACHE 10


--��ѯ��ǰ�����к�
SELECT seq_2.currval FROM dual;

--����һ������
SELECT seq_2.nextval FROM dual;

SELECT * FROM good;
INSERT INTO good VALUES(seq_3.nextval,'ww');

--����һ�������������good��Ĳ�������������Ĳ���д�뵽һ����־����
--����һ����־��
CREATE TABLE good_log(oper_type VARCHAR2(20),oper_date DATE);
--����������
CREATE OR REPLACE TRIGGER tri_good
BEFORE 
INSERT OR UPDATE OR DELETE 
ON good
--��������
DECLARE
oper_type VARCHAR2(20);
BEGIN
  --�жϵ�ǰ�Ĳ�������
  IF inserting THEN
    oper_type:='����';
  ELSIF updating THEN
    oper_type:='����';
  ELSIF deleting THEN
    oper_type:='ɾ��';
  END IF;
  --��������ӵ���־��
  INSERT INTO good_log VALUES(oper_type,SYSDATE);
END;

SELECT * FROM good;
--ɾ������
DELETE FROM good WHERE ID>50;

--ɾ��������
DROP TRIGGER tri_good;
SELECT * FROM good_log;


--��дһ���û����������������scott�û���������еĶ���Ĳ��������ҽ����ݼ�¼����־���С�
CREATE TABLE user_log1(
 oper_type VARCHAR2(20),
 oper_object VARCHAR2(100),
 oper_event VARCHAR2(20),
 oper_date DATE,
 oper_user VARCHAR2(20)
);
--����������
CREATE OR REPLACE TRIGGER tri_user
AFTER
CREATE OR ALTER OR DROP OR TRUNCATE
ON scott.schema      --schema��������û�ģʽ
BEGIN
  --�������
  INSERT INTO user_log1 VALUES(
       ora_dict_obj_type,---��¼���ǲ����Ķ�������
       ora_dict_obj_name,--��¼�����Ķ��������
       ora_sysevent,--��¼��ǰ�������¼�
       sysdate,
       ora_login_user  --��¼��ǰ��¼���û�   
  );
END;

SELECT * FROM user_log1;

--���
TRUNCATE TABLE good;


--��дһ��������ʵ��good���������������Ĺ���
CREATE OR REPLACE TRIGGER tri_insert 
BEFORE 
INSERT
ON good
FOR EACH ROW
  BEGIN
    --����һ��������ӵ��µ�һ�����ݵ�����λ��
    --:new.id:=seq_3.nextval;
    SELECT seq_3.nextval INTO :new.id FROM dual;
END;

--�������
INSERT INTO good(NAME) VALUES('qq');
SELECT * FROM good;

--��дһ������������ز��ű���ɾ����ÿһ�����ݣ���ɾ�������ݴ�ӡ����
CREATE  OR REPLACE TRIGGER tri_delete
AFTER 
DELETE
ON dept
FOR EACH ROW
  BEGIN
    dbms_output.put_line('ɾ�������ݣ�'||:old.deptno||','||:OLD.dname||','||:old.loc);
 END;

SELECT * FROM dept;
DELETE FROM dept WHERE deptno>=80;
DELETE FROM dept WHERE deptno >20 AND deptno<30;

--�޸�7369Ա���Ĺ��ʺͲ������ƣ�������ֱ���޸ģ�
--UPDATE view_e_d SET sal=1000,dname='���۲�' WHERE empno=7369;
--��дһ���滻���������޸���ͼ�ж��Ż��������
CREATE OR REPLACE TRIGGER tri_instead
INSTEAD OF
UPDATE
ON view_e_d
FOR EACH ROW
  BEGIN
    --�޸�Ա������
    UPDATE emp SET sal=:new.sal WHERE empno=:new.empno;
    --�޸Ĳ��ű�����
    UPDATE dept SET dname=:new.dname WHERE deptno=:new.deptno;
END;

UPDATE view_e_d SET sal=1000,dname='���۲�' WHERE empno=7369;
SELECT * FROM view_e_d ;

--��дһ������������dept���е��޸���Ϣ��¼����
CREATE OR REPLACE TRIGGER tri_update
AFTER
UPDATE
ON dept
FOR EACH ROW
  BEGIN
    dbms_output.put_line('�޸�ǰ��'||:old.dname||',�޸ĺ�'||:new.dname);
 END;

SELECT * FROM dept;
UPDATE dept SET dname='���۲�' WHERE deptno=11;


SELECT * FROM user_t;
SELECT * FROM user_t1;
TRUNCATE TABLE user_t1;
INSERT INTO user_t1 SELECT * FROM user_t;

--��дһ�������������޸�user_t���ͬʱ��user_t1���еĶ�Ӧ������Ҳ�޸�Ϊ���µ�����
CREATE OR REPLACE TRIGGER tri_t
AFTER
UPDATE
ON User_T
FOR EACH ROW
  BEGIN
    UPDATE user_t1 SET NAME=:new.name,age=:new.age,last_date=:new.last_date WHERE ID=:new.id;
 END;

--�޸�user_t�е�����
UPDATE user_t SET NAME='С�װ�' WHERE ID=4;

SELECT * FROM rms_olt;

--һ��RMS_OLT������ZH_LABEL��ͬ���ظ����ݣ����ֻ����һ���������ڣ�create_date�����µ����ݡ�
DELETE FROM rms_olt r WHERE NOT EXISTS(
SELECT zh_label, MAX(create_date) FROM rms_olt GROUP BY zh_label
HAVING zh_label=r.zh_label AND MAX(create_date)=r.CREATE_date)



--��дһ���洢����
CREATE OR REPLACE PROCEDURE pro_test
IS
--����һ���α�
 CURSOR cur_t IS
  SELECT a.resclassenname,a.dstablename FROM m_resclass a JOIN m_resclassdiagram b ON b.resclassdiagramid=a.classdiagramtype
  WHERE b.resclassdiagramcnname='������';
BEGIN
  FOR t IN cur_t LOOP
    --�����Ա������һ�����ݣ�insert into
    --ģ�ͱ�m_resclass
    --רҵ��m_resclassdiagram
    INSERT INTO m_resattribute VALUES(t.resclassenname,'emos_flag','��־',NULL,'varchar2(20)');
    --�������������ֶΣ�alter table 
    EXECUTE IMMEDIATE 'alter table :tn add (emos_flag varchar2(20))'
    USING t.dstablename;
  END LOOP;
END;
SELECT dbms_random.value FROM dual;

SELECT abs(mod(dbms_random.random,100)) FROM dual;
--��Ա�����������ȡһ������
SELECT * FROM(
SELECT * FROM emp ORDER BY dbms_random.value) WHERE ROWNUM=1;









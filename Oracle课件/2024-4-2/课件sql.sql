--ģ��Դϵͳ
--�����ͻ���
CREATE TABLE customer_t(
  ID NUMBER,
  cust_id NUMBER,
  phone_no VARCHAR2(20),
  NAME VARCHAR2(20),
  create_time DATE,
  address VARCHAR2(100),
  cust_type NUMBER,
  prod_id VARCHAR2(20),
  credit_rank VARCHAR2(5)
);
--����cust_info.csv�ļ��е�����

SELECT COUNT(*) FROM customer_t;

--������Ʒ��
create table PRODUCT_t
(
  prod_id         VARCHAR2(40),
  prod_desc       VARCHAR2(40),
  basic_fee       NUMBER,
  mf_time         VARCHAR2(40),
  call_minute_fee NUMBER(7,2),
  mf_flow         VARCHAR2(40),
  flow_minute_fee NUMBER(7,2)
);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G58', '58Ԫ�����ײ�', 58, '30', .19, '6G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G78', '78Ԫ�����ײ�', 78, '50', .19, '20G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G98', '98Ԫ�����ײ�', 98, '150', .19, '30G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G168', '168Ԫ�����ײ�', 168, '450', .19, '30G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G198', '198Ԫ�����ײ�', 198, '700', .19, '50G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G288', '288Ԫ�����ײ�', 288, '1200', .19, '50G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G388', '388Ԫ�����ײ�', 388, '2000', .19, '100G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G588', '588Ԫ�����ײ�', 588, '40000', .19, '150G', .29);
commit;

SELECT * FROM product_t;

--����ͨ����¼��
create table CALL_RECORD
(
  call_id     INTEGER,
  call_date   DATE,
  call_type   VARCHAR2(20),
  phone_no    VARCHAR2(20),
  phone2_no   VARCHAR2(20),
  begin_time  VARCHAR2(30),
  region      VARCHAR2(20),
  phone_model VARCHAR2(20),
  time_long   NUMBER,
  fee         FLOAT,
  fields1     VARCHAR2(200),
  fields2     VARCHAR2(200),
  fields3     VARCHAR2(200),
  fields4     VARCHAR2(200),
  fields5     VARCHAR2(200)
);

--����oltp_data.sql�ļ��е�����
SELECT count(*) FROM call_record;


--����ODS��ı�ṹ
CREATE TABLE ods_customer AS SELECT * FROM customer_t WHERE 1=2;
CREATE TABLE ods_product AS SELECT * FROM product_t WHERE 1=2;
CREATE TABLE ods_call_record AS SELECT * FROM call_record WHERE 1=2;
--����һ����־��
CREATE TABLE fee_log(
 sp_name VARCHAR2(100),
 begin_time DATE,
 end_time DATE,
 errcode VARCHAR2(100),
 errm VARCHAR2(500),
 status VARCHAR2(10)
);
--����ODS������
CALL sp_ods_customer();
CALL sp_ods_product();
CALL sp_ods_call_record();
SELECT * FROM ods_customer;
SELECT * FROM ods_product;
SELECT * FROM ods_call_record;
SELECT * FROM fee_log;

--�·� �ͻ����   �ͻ�����   �ֻ���     ��Ʒ���    ��Ʒ����   ͨ��ʱ��    ��������     �������      �ܷ���

--����ÿ����ÿһ���û���ͨ��ʱ��
SELECT phone_no,to_char(call_date,'yyyymm')call_month,SUM(time_long)total_long FROM ods_call_record GROUP BY phone_no,to_char(call_date,'yyyymm');
--�����ͻ���
SELECT CALL_MONTH,
       CUST_ID,
       NAME,
       C.PHONE_NO,
       P.PROD_ID,
       P.PROD_DESC,
       TOTAL_LONG,
       P.BASIC_FEE,
       CASE
         WHEN (TOTAL_LONG - MF_TIME) > 0 THEN
          (TOTAL_LONG - MF_TIME) * CALL_MINUTE_FEE
         ELSE
          0
       END EW_FEE,
       (CASE
         WHEN (TOTAL_LONG - MF_TIME) > 0 THEN
          (TOTAL_LONG - MF_TIME) * CALL_MINUTE_FEE
         ELSE
          0
       END) + BASIC_FEE TOTAL_FEE
  FROM ODS_CUSTOMER C
  JOIN (SELECT PHONE_NO,
               TO_CHAR(CALL_DATE, 'yyyymm') CALL_MONTH,
               SUM(TIME_LONG) TOTAL_LONG
          FROM ODS_CALL_RECORD
         GROUP BY PHONE_NO, TO_CHAR(CALL_DATE, 'yyyymm')) A
    ON C.PHONE_NO = A.PHONE_NO
  JOIN ODS_PRODUCT P
    ON C.PROD_ID = P.PROD_ID;

TRUNCATE TABLE dw_call_fee;
SELECT * FROM dw_call_fee;

--���ô洢����
CALL sp_dw_call_fee();

--����DM���
--�ͻ������
CREATE TABLE dm_customer(
  cust_id NUMBER,
  NAME VARCHAR2(20),
  call_month VARCHAR2(30),
  month_fee NUMBER,
  call_q VARCHAR2(20),
  q_fee NUMBER
);
--��Ʒ�����
CREATE TABLE dm_product(
  prod_id VARCHAR2(10),
  call_month VARCHAR2(30),
  month_fee NUMBER,
  call_q VARCHAR2(20),
  q_fee NUMBER
);

ALTER TABLE dm_product MODIFY(prod_id VARCHAR2(20));

--�ͻ������
SELECT CUST_ID,
       NAME,
       CALL_MONTH,
       TOTAL_FEE,
       SUBSTR(CALL_MONTH, 1, 4) || (CASE
                                      WHEN SUBSTR(CALL_MONTH, 5, 2) IN ('01', '02', '03') THEN
                                       'Q1'
                                      WHEN SUBSTR(CALL_MONTH, 5, 2) IN ('04', '05', '06') THEN
                                       'Q2'
                                      WHEN SUBSTR(CALL_MONTH, 5, 2) IN ('07', '08', '09') THEN
                                       'Q3'
                                      WHEN SUBSTR(CALL_MONTH, 5, 2) IN ('10', '11', '12') THEN
                                       'Q4'
                                    END) CALL_Q,
       SUM(TOTAL_FEE) OVER(PARTITION BY CUST_ID, TRUNC(TO_DATE(CALL_MONTH, 'yyyymm'), 'q')) Q_FEE

  FROM DW_CALL_FEE;


--���ô洢����
CALL sp_dm_customer();
SELECT * FROM dm_customer;

--��Ʒ�����
--ÿ���·�ÿ����Ʒ����
SELECT PROD_ID,
       CALL_MONTH,
       MONTH_FEE,
       SUBSTR(CALL_MONTH, 1, 4) || (CASE
                                      WHEN SUBSTR(CALL_MONTH, 5, 2) IN ('01', '02', '03') THEN
                                       'Q1'
                                      WHEN SUBSTR(CALL_MONTH, 5, 2) IN ('04', '05', '06') THEN
                                       'Q2'
                                      WHEN SUBSTR(CALL_MONTH, 5, 2) IN ('07', '08', '09') THEN
                                       'Q3'
                                      WHEN SUBSTR(CALL_MONTH, 5, 2) IN ('10', '11', '12') THEN
                                       'Q4'
                                    END) CALL_Q,
       SUM(MONTH_FEE) OVER(PARTITION BY PROD_ID, TRUNC(TO_DATE(CALL_MONTH, 'yyyymm'), 'q')) Q_FEE
  FROM (SELECT PROD_ID, CALL_MONTH, SUM(TOTAL_FEE) MONTH_FEE
          FROM DW_CALL_FEE
         GROUP BY PROD_ID, CALL_MONTH);

--���� 
CALL sp_dm_product();
SELECT * FROM dm_product;

SELECT * FROM fee_log;



--Ӧ�ò㣺
--1.����2018��ĵڶ������ȸ�����Ʒ�����������
--��Ʒ����    ��������      ����  
SELECT prod_id,call_q,q_fee FROM dm_product WHERE call_q='2018Q2' GROUP BY prod_id,call_q,q_fee;

--  2.����2018��ڶ������ȿͻ����׶�ǰʮ��
-- �ͻ����   �ͻ�����      ��������       ����         ռ��
SELECT * FROM(
SELECT a.*,q_fee/SUM(q_fee)OVER() FROM(
SELECT cust_id,NAME,call_Q,q_fee FROM dm_customer WHERE call_q='2018Q2' GROUP BY cust_id,NAME,call_Q,q_fee ORDER BY q_fee DESC) a
) WHERE ROWNUM<=50;


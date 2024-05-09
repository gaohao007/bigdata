--模拟源系统
--创建客户表
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
--导入cust_info.csv文件中的数据

SELECT COUNT(*) FROM customer_t;

--创建产品表
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
values ('4G58', '58元畅享套餐', 58, '30', .19, '6G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G78', '78元畅享套餐', 78, '50', .19, '20G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G98', '98元畅享套餐', 98, '150', .19, '30G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G168', '168元畅享套餐', 168, '450', .19, '30G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G198', '198元畅享套餐', 198, '700', .19, '50G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G288', '288元畅享套餐', 288, '1200', .19, '50G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G388', '388元畅享套餐', 388, '2000', .19, '100G', .29);
insert into PRODUCT_t (prod_id, prod_desc, basic_fee, mf_time, call_minute_fee, mf_flow, flow_minute_fee)
values ('4G588', '588元畅享套餐', 588, '40000', .19, '150G', .29);
commit;

SELECT * FROM product_t;

--创建通话记录表
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

--导入oltp_data.sql文件中的数据
SELECT count(*) FROM call_record;


--创建ODS层的表结构
CREATE TABLE ods_customer AS SELECT * FROM customer_t WHERE 1=2;
CREATE TABLE ods_product AS SELECT * FROM product_t WHERE 1=2;
CREATE TABLE ods_call_record AS SELECT * FROM call_record WHERE 1=2;
--创建一个日志表
CREATE TABLE fee_log(
 sp_name VARCHAR2(100),
 begin_time DATE,
 end_time DATE,
 errcode VARCHAR2(100),
 errm VARCHAR2(500),
 status VARCHAR2(10)
);
--加载ODS层数据
CALL sp_ods_customer();
CALL sp_ods_product();
CALL sp_ods_call_record();
SELECT * FROM ods_customer;
SELECT * FROM ods_product;
SELECT * FROM ods_call_record;
SELECT * FROM fee_log;

--月份 客户编号   客户姓名   手机号     产品编号    产品名称   通话时长    基础费用     额外费用      总费用

--计算每个月每一个用户总通话时长
SELECT phone_no,to_char(call_date,'yyyymm')call_month,SUM(time_long)total_long FROM ods_call_record GROUP BY phone_no,to_char(call_date,'yyyymm');
--关链客户表
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

--调用存储过程
CALL sp_dw_call_fee();

--创建DM层表
--客户主题表
CREATE TABLE dm_customer(
  cust_id NUMBER,
  NAME VARCHAR2(20),
  call_month VARCHAR2(30),
  month_fee NUMBER,
  call_q VARCHAR2(20),
  q_fee NUMBER
);
--产品主题表
CREATE TABLE dm_product(
  prod_id VARCHAR2(10),
  call_month VARCHAR2(30),
  month_fee NUMBER,
  call_q VARCHAR2(20),
  q_fee NUMBER
);

ALTER TABLE dm_product MODIFY(prod_id VARCHAR2(20));

--客户主题表
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


--调用存储过程
CALL sp_dm_customer();
SELECT * FROM dm_customer;

--产品主题表
--每个月份每个产品收入
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

--调用 
CALL sp_dm_product();
SELECT * FROM dm_product;

SELECT * FROM fee_log;



--应用层：
--1.分析2018年的第二个季度各个产品的收入情况。
--产品名称    季度名称      收入  
SELECT prod_id,call_q,q_fee FROM dm_product WHERE call_q='2018Q2' GROUP BY prod_id,call_q,q_fee;

--  2.分析2018年第二个季度客户贡献度前十。
-- 客户编号   客户姓名      季度名称       话费         占比
SELECT * FROM(
SELECT a.*,q_fee/SUM(q_fee)OVER() FROM(
SELECT cust_id,NAME,call_Q,q_fee FROM dm_customer WHERE call_q='2018Q2' GROUP BY cust_id,NAME,call_Q,q_fee ORDER BY q_fee DESC) a
) WHERE ROWNUM<=50;


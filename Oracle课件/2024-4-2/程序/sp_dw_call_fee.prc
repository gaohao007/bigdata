create or replace procedure sp_dw_call_fee is
/*****************************************************************************
     程序名称：sp_dw_call_fee
     功能描述：费用明细数据
     输入参数: 
     输出参数: 
     返 回 值：
     目 标 表：dw_call_fee
     源    表：ods_customer
               ods_product
               ods_call_record
     创 建 人：....
     创建日期：
     修改日期：
     修改人员：
     修改原因：
  ******************************************************************************/
  --声明开始时间
  begin_time DATE;
  --声明结束时间
  end_time DATE;
begin
   --记录开始时间
   begin_time:=SYSDATE;
   --清空目标表中的数据
   EXECUTE IMMEDIATE 'truncate table dw_call_fee';
   --加载数据
   INSERT INTO dw_call_fee
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
   --提交事务
   COMMIT;
   --记录结束时间
   end_time:=SYSDATE;
   --记录日志
   sp_log('sp_dw_call_fee',begin_time,end_time,NULL,NULL,'成功！');
   --处理异常
   EXCEPTION
     WHEN OTHERS THEN
       --记录结束时间
       end_time:=SYSDATE;
       --记录日志
       sp_log('sp_dw_call_fee',begin_time,end_time,SQLCODE,Sqlerrm,'失败！');
end sp_dw_call_fee;
/

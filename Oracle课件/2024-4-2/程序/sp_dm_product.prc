create or replace procedure sp_dm_product is
/*****************************************************************************
     程序名称：sp_dm_product
     功能描述：产品主题表
     输入参数: 
     输出参数: 
     返 回 值：
     目 标 表：dm_product
     源    表：dw_call_fee
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
   EXECUTE IMMEDIATE 'truncate table dm_product';
   --加载数据
   INSERT INTO dm_product
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
   --提交事务
   COMMIT;
   --记录结束时间
   end_time:=SYSDATE;
   --记录日志
   sp_log('sp_dm_product',begin_time,end_time,NULL,NULL,'成功！');
   --处理异常
   EXCEPTION
     WHEN OTHERS THEN
       --记录结束时间
       end_time:=SYSDATE;
       --记录日志
       sp_log('sp_dm_product',begin_time,end_time,SQLCODE,Sqlerrm,'失败！');
end sp_dm_product;
/

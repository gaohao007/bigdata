create or replace procedure sp_ods_customer IS
/*****************************************************************************
     程序名称：sp_ods_customer
     功能描述：抽取客户表的数据
     输入参数: 
     输出参数: 
     返 回 值：
     目 标 表：ods_customer
     源    表：customer_t
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
   EXECUTE IMMEDIATE 'truncate table ods_customer';
   --加载数据
   INSERT INTO ods_customer
   SELECT * FROM customer_t;
   --提交事务
   COMMIT;
   --记录结束时间
   end_time:=SYSDATE;
   --记录日志
   sp_log('sp_ods_customer',begin_time,end_time,NULL,NULL,'成功！');
   --处理异常
   EXCEPTION
     WHEN OTHERS THEN
       --记录结束时间
       end_time:=SYSDATE;
       --记录日志
       sp_log('sp_ods_customer',begin_time,end_time,SQLCODE,Sqlerrm,'失败！');
end sp_ods_customer;
/

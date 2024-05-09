create or replace procedure sp_ods_call_record is
/*****************************************************************************
     程序名称：sp_ods_call_record
     功能描述：抽取通话记录表的数据
     输入参数: 
     输出参数: 
     返 回 值：
     目 标 表：ods_call_record
     源    表：call_record
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
   EXECUTE IMMEDIATE 'truncate table ods_call_record';
   --加载数据
   INSERT INTO ods_call_record
   SELECT * FROM call_record;
   --提交事务
   COMMIT;
   --记录结束时间
   end_time:=SYSDATE;
   --记录日志
   sp_log('sp_ods_call_record',begin_time,end_time,NULL,NULL,'成功！');
   --处理异常
   EXCEPTION
     WHEN OTHERS THEN
       --记录结束时间
       end_time:=SYSDATE;
       --记录日志
       sp_log('sp_ods_call_record',begin_time,end_time,SQLCODE,Sqlerrm,'失败！');
end sp_ods_call_record;
/

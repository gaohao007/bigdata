create or replace procedure sp_log(sp_name varchar2,begin_time date,end_time date,errcode varchar2,errm varchar2,status varchar2) is
/*********************************

记录日志

*********************************/
BEGIN
  INSERT INTO fee_log VALUES(sp_name,begin_time,end_time,errcode,errm,status);
  --提交事务
  COMMIT;
end sp_log;
/

create or replace procedure sp_ods_call_record is
/*****************************************************************************
     �������ƣ�sp_ods_call_record
     ������������ȡͨ����¼�������
     �������: 
     �������: 
     �� �� ֵ��
     Ŀ �� ��ods_call_record
     Դ    ��call_record
     �� �� �ˣ�....
     �������ڣ�
     �޸����ڣ�
     �޸���Ա��
     �޸�ԭ��
  ******************************************************************************/
  --������ʼʱ��
  begin_time DATE;
  --��������ʱ��
  end_time DATE;
begin
   --��¼��ʼʱ��
   begin_time:=SYSDATE;
   --���Ŀ����е�����
   EXECUTE IMMEDIATE 'truncate table ods_call_record';
   --��������
   INSERT INTO ods_call_record
   SELECT * FROM call_record;
   --�ύ����
   COMMIT;
   --��¼����ʱ��
   end_time:=SYSDATE;
   --��¼��־
   sp_log('sp_ods_call_record',begin_time,end_time,NULL,NULL,'�ɹ���');
   --�����쳣
   EXCEPTION
     WHEN OTHERS THEN
       --��¼����ʱ��
       end_time:=SYSDATE;
       --��¼��־
       sp_log('sp_ods_call_record',begin_time,end_time,SQLCODE,Sqlerrm,'ʧ�ܣ�');
end sp_ods_call_record;
/

create or replace procedure sp_ods_product is
/*****************************************************************************
     �������ƣ�sp_ods_product
     ������������ȡ��Ʒ������
     �������: 
     �������: 
     �� �� ֵ��
     Ŀ �� ��ods_product
     Դ    ��product_t
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
   EXECUTE IMMEDIATE 'truncate table ods_product';
   --��������
   INSERT INTO ods_product
   SELECT * FROM product_t;
   --�ύ����
   COMMIT;
   --��¼����ʱ��
   end_time:=SYSDATE;
   --��¼��־
   sp_log('sp_ods_product',begin_time,end_time,NULL,NULL,'�ɹ���');
   --�����쳣
   EXCEPTION
     WHEN OTHERS THEN
       --��¼����ʱ��
       end_time:=SYSDATE;
       --��¼��־
       sp_log('sp_ods_product',begin_time,end_time,SQLCODE,Sqlerrm,'ʧ�ܣ�');
end sp_ods_product;
/

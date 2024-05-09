create or replace procedure sp_dw_call_fee is
/*****************************************************************************
     �������ƣ�sp_dw_call_fee
     ����������������ϸ����
     �������: 
     �������: 
     �� �� ֵ��
     Ŀ �� ��dw_call_fee
     Դ    ��ods_customer
               ods_product
               ods_call_record
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
   EXECUTE IMMEDIATE 'truncate table dw_call_fee';
   --��������
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
   --�ύ����
   COMMIT;
   --��¼����ʱ��
   end_time:=SYSDATE;
   --��¼��־
   sp_log('sp_dw_call_fee',begin_time,end_time,NULL,NULL,'�ɹ���');
   --�����쳣
   EXCEPTION
     WHEN OTHERS THEN
       --��¼����ʱ��
       end_time:=SYSDATE;
       --��¼��־
       sp_log('sp_dw_call_fee',begin_time,end_time,SQLCODE,Sqlerrm,'ʧ�ܣ�');
end sp_dw_call_fee;
/

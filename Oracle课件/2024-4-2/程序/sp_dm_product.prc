create or replace procedure sp_dm_product is
/*****************************************************************************
     �������ƣ�sp_dm_product
     ������������Ʒ�����
     �������: 
     �������: 
     �� �� ֵ��
     Ŀ �� ��dm_product
     Դ    ��dw_call_fee
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
   EXECUTE IMMEDIATE 'truncate table dm_product';
   --��������
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
   --�ύ����
   COMMIT;
   --��¼����ʱ��
   end_time:=SYSDATE;
   --��¼��־
   sp_log('sp_dm_product',begin_time,end_time,NULL,NULL,'�ɹ���');
   --�����쳣
   EXCEPTION
     WHEN OTHERS THEN
       --��¼����ʱ��
       end_time:=SYSDATE;
       --��¼��־
       sp_log('sp_dm_product',begin_time,end_time,SQLCODE,Sqlerrm,'ʧ�ܣ�');
end sp_dm_product;
/

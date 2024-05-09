create or replace function fun_jisuan1(a number,b number,oper varchar2) return number is
  res number;
begin
  CASE oper 
      WHEN '+' THEN res:=a+b;
      WHEN '-' THEN res:=a-b;
      WHEN '*' THEN res:=a*b;
      WHEN '/' THEN res:=a/b;
       END CASE;
       --·µ»ØÊý¾Ý
       RETURN res;
end fun_jisuan1;
/

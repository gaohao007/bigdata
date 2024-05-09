--申请表ap_info
CREATE TABLE ap_info(
id VARCHAR(20),
name VARCHAR(20) NOT NULL,--姓名
birth VARCHAR(20) NOT NULL,--生日
sex VARCHAR(10) NOT NULL,--性别
PRIMARY KEY(id)
);
--贷款表loan_info
CREATE TABLE loan_info(
id VARCHAR(20),
id_no VARCHAR(20),
term VARCHAR(20) NOT NULL,---期数
rate VARCHAR(20) NOT NULL,---利率
PRIMARY KEY(id,id_no)
);
--还款表repay_info
CREATE TABLE repay_info(
id_no VARCHAR(20),
type VARCHAR(20),---还款状态（枚举值：提前还款、正常还款、逾期还款）
PRIMARY KEY(id_no)
);
--变量表decision_data_info
CREATE TABLE decision_data_info(
id_no VARCHAR(20),
a_1 VARCHAR(20),-----变量1
a_2 VARCHAR(20),-----变量2
a_3 VARCHAR(20),-----变量3
a_4 VARCHAR(20),-----变量4
PRIMARY KEY(id_no)
);

--插入申请表测试数据
insert into ap_info values('01' , '赵雷' , '1990-01-01' , '男');
insert into ap_info values('02' , '钱电' , '1990-12-21' , '男');
insert into ap_info values('03' , '孙风' , '1990-05-20' , '男');
insert into ap_info values('04' , '李云' , '1990-08-06' , '男');
insert into ap_info values('05' , '周梅' , '1991-12-01' , '女');
insert into ap_info values('06' , '吴兰' , '1992-03-01' , '女');
insert into ap_info values('07' , '郑竹' , '1989-07-01' , '女');
insert into ap_info values('08' , '王菊' , '1990-01-20' , '女');
--贷款表测试数据
insert into loan_info values('01' ,'5642' , '12' , '0.052');
insert into loan_info values('02' ,'4372' , '9' , '0.064');
insert into loan_info values('03' ,'8934' , '3' , '0.041');
insert into loan_info values('04' ,'2351' , '6' , '0.032');
insert into loan_info values('05' ,'2683' , '1' , '0.045');
insert into loan_info values('06' ,'2467' , '6' , '0.056');
insert into loan_info values('07' ,'5783' , '12' , '0.064');
insert into loan_info values('08' ,'3516' , '3' , '0.075');

--还款表测试数据
insert into repay_info values('5642' , '正常还款');
insert into repay_info values('4372' , '提前还款');
insert into repay_info values('8934' , '正常还款');
insert into repay_info values('2351' , '正常还款');
insert into repay_info values('2683' , '正常还款');
insert into repay_info values('2467' , '提前还款');
insert into repay_info values('5783' , '逾期还款');
insert into repay_info values('3516' , '逾期还款');

--变量表测试数据
insert into decision_data_info values('5642' , 30 , 80 , 183 , 802);
insert into decision_data_info values('4372' , 20 , 90 , 204 , 302);
insert into decision_data_info values('8934' , 20 , 99 , 216 , 403);
insert into decision_data_info values('2351' , 10 , 70 , 157 , 555);
insert into decision_data_info values('2683' , 30 , 60 , 283 , 670);
insert into decision_data_info values('2467' , 30 , 80 , 108 , 809);
insert into decision_data_info values('5783' , 20 , 80 , 172 , 707);
insert into decision_data_info values('3516' , 10, 80 , 166,NULL);

--1、查询变量为变量3大于180且变量4小于500的所有客户的id。

SELECT ID FROM decision_data_info d JOIN loan_info l ON d.id_no=l.id_no WHERE
a_3>180 AND a_4<500


--2、查询所有变量平均值大于200的客户的还款状态、期数及利率。
WITH tmp AS(
SELECT id_no,(a_1+a_2+a_3+nvl(a_4,0))/4 FROM decision_data_info WHERE (a_1+a_2+a_3+nvl(a_4,0))/4>200)
SELECT t.id_no,ID,TYPE,term,rate FROM tmp t JOIN repay_info r ON t.id_no=r.id_no JOIN loan_info l ON r.id_no=l.id_no

--3、查询所有客户的id、姓名、利率。
SELECT a.ID,NAME,rate FROM ap_info a JOIN loan_info l ON a.id=l.id;

--4、查询期数=6的id个数。
SELECT COUNT(DISTINCT ID) FROM loan_info WHERE term=6;

--5、查询不同期数的最大利率。
SELECT term,MAX(rate) FROM loan_info GROUP BY term;


--7、查询不同利率的变量1的平均值。
SELECT rate,AVG(a_1) FROM loan_info l JOIN decision_data_info d ON l.id_no=d.id_no GROUP BY rate

--8、查询期数为6的所有客户变量3和变量4的平均值及总值。
SELECT AVG(a_3),AVG(a_4),SUM(a_3),SUM(a_4) FROM loan_info l JOIN decision_data_info d ON l.id_no=d.id_no
WHERE term=6 

--9、查询和id_no等于“5642”的客户期数相同的所有客户的id
--查询5642客户期数
SELECT term FROM loan_info WHERE id_no='5642'
--结果
SELECT ID FROM loan_info WHERE term=(SELECT term FROM loan_info WHERE id_no='5642') AND id_no<>'5642'


--10、创建一张新表，按如下形式显示：
--Id，id_no，期数，利率，a_1，a_2，a_1+a_2
CREATE TABLE new_t AS
SELECT ID,l.id_no,term,rate,a_1,a_2,a_1+a_2 a_l FROM loan_info l JOIN decision_data_info d ON l.id_no=d.id_no;

SELECT * FROM new_t;

--11、删除id=03客户四张表的记录
--删除变量表
DELETE FROM decision_data_info WHERE id_no IN(SELECT id_no FROM loan_info WHERE ID='03');
SELECT * FROM decision_data_info;
--删除还款表
DELETE FROM repay_info WHERE id_no IN(SELECT id_no FROM loan_info WHERE ID='03');
SELECT * FROM repay_info;
--删除贷款表
DELETE FROM loan_info WHERE id='03';
--删除申请表
DELETE FROM ap_info WHERE ID='03';
SELECT * FROM ap_info;

--12、按变量4从低到高排列，以如下形式显示：id,姓名,生日,期数，a_1，a_2，a_3，a_4
SELECT a.id,a.name,a.birth,term,a_1,a_2,a_3,a_4 FROM ap_info a JOIN loan_info l ON a.id=l.id JOIN decision_data_info d ON l.id_no=d.id_no
ORDER BY a_4;


--13、查询不同期数利率从高到低显示
SELECT l.*,row_number()OVER(PARTITION BY term ORDER BY rate DESC) FROM loan_info l;

--14、查询变量4最高和最低的分： 以如下的形式显示：id，期数，还款状态
WITH tmp AS(
SELECT * FROM decision_data_info d WHERE EXISTS(
SELECT * FROM(
SELECT  max(a_4) m,MIN(a_4) n FROM decision_data_info) WHERE d.a_4=m OR d.a_4=n ))
SELECT ID,term,TYPE FROM tmp t JOIN loan_info l ON t.id_no=l.id_no JOIN repay_info r ON l.id_no=r.id_no;

--查询变量4的最大值和最小值
SELECT * FROM(
SELECT d.*,MAX(a_4)OVER() r1,
           MIN(a_4)OVER() r FROM decision_data_info d)
           WHERE a_4=r1 OR a_4=r
           
SELECT * FROM student;
SELECT * FROM teacher;
SELECT * FROM sc;
SELECT * FROM course;         
           

--1.把“SC”表中“谌燕”老师教的课的成绩都更改为此课程的平均成绩；
--使用in
UPDATE sc s SET score=(SELECT AVG(score) FROM sc WHERE cno=s.cno) WHERE cno 
IN(SELECT cno FROM teacher t JOIN course c ON t.tno=c.tno WHERE t.tname='谌燕');
--使用exists
UPDATE sc s SET score=(SELECT AVG(score) FROM sc WHERE cno=s.cno) WHERE 
EXISTS(SELECT cno FROM teacher t JOIN course c ON t.tno=c.tno WHERE t.tname='谌燕' AND s.cno=c.cno);

--查询“谌燕”老师教授的课程号
SELECT cno FROM teacher t JOIN course c ON t.tno=c.tno WHERE t.tname='谌燕';
SELECT cno,AVG(score) FROM sc GROUP BY cno;
SELECT * FROM sc;

--2.删除学习“谌燕”老师课的SC 表记录；
DELETE FROM sc s WHERE EXISTS
(SELECT cno FROM teacher t JOIN course c ON t.tno=c.tno WHERE t.tname='谌燕' AND s.cno=c.cno)

--3.查询各科成绩最高和最低的分：以如下形式显示：课程ID，最高分，最低分
SELECT cno 课程ID,MAX(score)最高分,MIN(score)最低分 FROM sc GROUP BY cno

--4.查询不同老师所教不同课程平均分从高到低显示
SELECT tno,c.cno,AVG(score) 平均成绩 FROM sc JOIN course c ON sc.cno=c.cno GROUP BY tno,c.cno
ORDER BY 平均成绩 desc;


--5.查询每门课程被选修的学生数
--SELECT cno,COUNT(*) FROM sc GROUP BY cno;
SELECT c.cno,COUNT(sno)人数 FROM course c LEFT JOIN sc ON c.cno=sc.cno GROUP BY c.cno;


--6.查询出只选修了一门课程的全部学生的学号和姓名
--子查询
 SELECT sno,sname FROM student WHERE sno IN(
 SELECT sno FROM sc GROUP BY sno HAVING COUNT(*)=1);
 
  SELECT sno,sname FROM student s WHERE EXISTS(
 SELECT sno FROM sc WHERE s.sno=sno GROUP BY sno HAVING COUNT(*)=1);
--关联查询
SELECT s.sno,sname FROM student s JOIN sc ON s.sno=sc.sno GROUP BY s.sno,sname
HAVING COUNT(*)=1;

--7.查询男生、女生人数
SELECT ssex,COUNT(*) FROM student GROUP BY ssex 
--显示结果：男生      女生
--            5         5
SELECT SUM(CASE WHEN ssex='男' THEN 1 ELSE 0 END) 男生,
       SUM(CASE WHEN ssex='女' THEN 1 ELSE 0 END) 女生 FROM student;

--8.查询姓“张”的学生名单
SELECT * FROM student WHERE sname LIKE '张%'
SELECT * FROM student WHERE regexp_like(sname,'^张')

--9.查询每门课程的平均成绩，结果按平均成绩升序排列，平均成绩相同时，按课程号降序排列
SELECT cno,AVG(score) 平均成绩 FROM sc GROUP BY cno ORDER BY 平均成绩,cno DESC

--10、查询平均成绩大于75 的所有学生的学号、姓名和平均成绩
SELECT s.sno,s.sname,AVG(score) 平均成绩 FROM student s JOIN sc ON s.sno=sc.sno GROUP BY s.sno,s.sname
HAVING AVG(score)>75;

--11、查询课程名称为“J2SE”，且分数低于70 的学生姓名和分数
SELECT sname,score FROM student s JOIN sc ON s.sno=sc.sno
JOIN course c ON sc.cno=c.cno WHERE cname='J2SE' AND score<70


--12、查询所有学生的选课情况；
SELECT  * FROM student s LEFT JOIN sc ON s.sno=sc.sno;

--13、查询任何一门课程成绩在70 分以上的姓名、课程名称和分数；
--只要有一门再70以上
SELECT sname,cname,score FROM student s JOIN sc ON s.sno=sc.sno
JOIN course c ON sc.cno=c.cno WHERE score>70

--所有的课程都要再70分以上
SELECT sname,cname,score FROM(
SELECT sno,MIN(score) min_score FROM sc GROUP BY sno HAVING MIN(score)>70)a
JOIN student s ON a.sno=s.sno 
JOIN sc ON s.sno=sc.sno AND min_score=score
JOIN course c ON c.cno=sc.cno




--14、查询不及格的课程，并按课程号从大到小排列
SELECT * FROM sc WHERE score<60 ORDER BY cno DESC;

--15、查询课程编号为c001 且课程成绩在80 分以上的学生的学号和姓名；
SELECT sno,sname FROM student s WHERE EXISTS(
SELECT sno FROM sc WHERE cno='c001' AND score>80 AND s.sno=sno)

--16、求选了课程的学生人数
SELECT COUNT(DISTINCT sno) FROM sc;
--count(*)和count(列名),count(1)

SELECT * FROM aa;
/*
A
A  B   C   D
c   d  3   4
a   b  1   2
B
A  B   C   D
c  d   2   4
a  b   1   3

*/
--请说出下面两条sql语句的结果
select * from aa a left join bb b on a.A=b.A and a.B=b.B and b.C=1;
--c  d   3   4   
--a  b   1   2   a   b   1   3


select * from aa a left join bb b on a.A=b.A and a.B=b.B where b.C=1;
--a   b   1   2    a   b  1   3

--有两张表A表中有15条数据   b表有8条数据  a表中有14条数据和B表相关联
--b表有3条数据和A表相关联
--问题：1.A inner join B有多少条数据      14条
--内连接的条数：两个表相关条数去最大值
--问题：2.A left join B有多少条数据       15
--左连接条数：内连接条数+左表不相关的条数
--问题：3.A right join B有多少条数据      19=14+5
--右连接条数：内连接条数+右表不相关的条数
--问题：4.A full join B有多少条数据       20=14+5+1
--全连接条数：内连接条数+右表不相关的条数+左表不相关条数
--问题：5.A cross join B有多少条数据      120

SELECT * FROM emp e full JOIN dept d ON e.deptno=d.deptno
SELECT * FROM dept;

--17、查询选修“谌燕”老师所授课程的学生中，成绩最高的学生姓名及其成绩
18、查询各个课程及相应的选修人数
20、查询每门功课成绩最好的前两名
21、统计每门课程的学生选修人数（超过10 人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
22、检索至少选修两门课程的学生学号
25、查询两门以上不及格课程的同学的学号及其平均成绩
26、检索“c004”课程分数小于60，按分数降序排列的同学学号
27、删除“s002”同学的“c001”课程的成绩
28、查询各科成绩前三名的记录:(不考虑成绩并列情况)
29、查询同名同性学生名单，并统计同名人数
30.查询学过“谌燕”老师所教的所有课的同学的学号、姓名；
31、查询课程编号“c002”的成绩比课程编号“c001”课程低的所有同学的学号、姓名；
32、查询没有学全所有课的同学的学号、姓名；
33、查询至少有一门课与学号为“s001”的同学所学相同的同学的学号和姓名
        
           
           
           

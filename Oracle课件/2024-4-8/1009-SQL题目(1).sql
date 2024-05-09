
-- 网页日志记录表exam.urlrecord
--create table exam.urlrecord
--(
--id string,
--url string,
--action string,
--)
--partitioned by(dt string);
--样例数据：
--+---------------+-------------------+-------------------+---------------+--+
--| urlrecord.id  |   urlrecord.url   | urlrecord.action  | urlrecord.dt  |
--+---------------+-------------------+-------------------+---------------+--+
--| 1             | www.sohu.com      | view              | 20201001      |
--| 2             | www.baidu.com     | click             | 20201001      |
--| 3             | www.baidu.com     | click             | 20201001      |
--| 4             | www.bilibili.com  | click             | 20201001      |
--| 5             | www.sohu.com      | click             | 20201002      |
--| 6             | www.qq.com        | click             | 20201002      |
--| 7             | www.sohu.com      | click             | 20201002      |
--| 8             | www.youku.com     | view              | 20201002      |
--| 9             | www.qq.com        | view              | 20201002      |
--| 10            | www.qq.com        | view              | 20201002      |
--| 11            | www.youku.com     | view              | 20201002      |
--| 12            | www.baidu.com     | click             | 20201007      |
--|...            |...                |...                |...            |
--

--题目：求每天url被点击（action='click'）的pv（一次点击算一个pv）值
-- 结果数据示例
--+-----------+-------------------+-------+--+
--|    dt     |        url        |  pv   |
--+-----------+-------------------+-------+--+
--| 20201001  | www.58.com        | 3641  |
--| 20201001  | www.baidu.com     | 3574  |
--| 20201002  | www.58.com        | 3494  |
--| 20201002  | www.baidu.com     | 3457  |
--| 20201002  | www.bilibili.com  | 3551  |


select dt,url,count(*) pv from urlrecord where action='click'  group by dt,url;












-- 学生表 exam.userinfo
--create table userinfo(
--uid string,
--name string,
--city string 
--);

--样例数据
--+---------------+----------------+----------------+--+
--| userinfo.uid  | userinfo.name  | userinfo.city  |
--+---------------+----------------+----------------+--+
--| 1             | Iceice         | beijing        |
--| 2             | Aui            | shanghai       |

-- 成绩表 exam.scores
--create table scores
--(
--uid string,
--courseid string,
--score int
--);
--其中，courseid的取值范围为('01','02','03','04')
--样例数据
--+-------------+------------------+---------------+--+
--| scores.uid  | scores.courseid  | scores.score  |
--+-------------+------------------+---------------+--+
--| 1           | 01               | 95            |
--| 1           | 02               | 60            |
--| 1           | 03               | 95            |
--| 1           | 04               | 70            |


--注意：如果有人没有参加某一门的考试，则scores里不会有记录；可能有同学缺席了所有的考试，scores表里就没有该同学的信息

--题目：求出uid,name, 01成绩，02课程成绩，03课程成绩，04课程成绩；如果没有参数某一门考试，结果成绩为0
--输出结果样例，成绩的数据类型为int
--+------+---------+------+------+------+------+--+
--| uid  |  name   | 01成绩  |02成绩  | 03成绩  | 04成绩  |
--+------+---------+------+------+------+------+--+
--| 1    | Iceice  | 95   | 60   | 95   | 70   |
--| 2    | Aui     | 70   | 85   | 80   | 80   |



SELECT s.sno,sname,nvl(c001,0),nvl(c002,0),nvl(c003,0) FROM student s LEFT JOIN(
SELECT * FROM sc PIVOT(MAX(score) FOR cno IN('c001' c001,'c002' c002,'c003' c003))) a
ON s.sno=a.sno;











-- 网页日志记录表
--create table exam.urlrecord
--(
--id string,
--url string,
--action string,
--)
--partitioned by(dt string);
--样例数据：
--+---------------+-------------------+-------------------+---------------+--+
--| urlrecord.id  |   urlrecord.url   | urlrecord.action  | urlrecord.dt  |
--+---------------+-------------------+-------------------+---------------+--+
--| 1             | www.sohu.com      | view              | 20201001      |
--| 2             | www.baidu.com     | click             | 20201001      |
--| 3             | www.baidu.com     | click             | 20201001      |
--| 4             | www.bilibili.com  | click             | 20201001      |
--| 5             | www.sohu.com      | click             | 20201002      |
--| 6             | www.qq.com        | click             | 20201002      |
--| 7             | www.sohu.com      | click             | 20201002      |
--| 8             | www.youku.com     | view              | 20201002      |
--| 9             | www.qq.com        | view              | 20201002      |
--| 10            | www.qq.com        | view              | 20201002      |
--| 11            | www.youku.com     | view              | 20201002      |
--| 12            | www.baidu.com     | click             | 20201007      |
--|...            |...                |...                |...            |

--url单次被点击价格表
--create table   exam.codetable
--（
-- url string，
-- price double
-- ）
 --样例数据
--+-------------------+------------------+--+
--|   codetable.url   | codetable.price  |
--+-------------------+------------------+--+
--| www.weibo.com     | 1.0              |
--| www.58.com        | 2.0              |
--| www.jd.com        | 3.0              |
--| ...               | ...              |
--+-------------------+------------------+--+

--题目：  求在 dt='20201002'这天的各个url，被点击（action='click'）产生的广告费用是多少?

--结果数据样例
--|       url         |   收入    |
--+-------------------+----------+--+
--| www.58.com        | 6988.0   |
--| www.baidu.com     | 3457.0   |
--| www.bilibili.com  | 21306.0  |

--注意点： 考试中的数据量很小，写的过程中要考虑下数据量过大情况下查询的最优解法


select a.url,sum(price) from(
select * from urlrecord where  action='click' and dt='20201002') a
join codetable c on a.url=c.url group by a.url;






-- 网页日志记录表exam.urlrecord

--create table exam.urlrecord
--(
--id string,
--url string,
--action string,
--)
--partitioned by(dt string);
--样例数据：
--+---------------+-------------------+-------------------+---------------+--+
--| urlrecord.id  |   urlrecord.url   | urlrecord.action  | urlrecord.dt  |
--+---------------+-------------------+-------------------+---------------+--+
--| 1             | www.sohu.com      | view              | 20201001      |
--| 2             | www.baidu.com     | click             | 20201001      |
--| 3             | www.baidu.com     | click             | 20201001      |
--| 4             | www.bilibili.com  | click             | 20201001      |
--| 5             | www.sohu.com      | click             | 20201002      |
--| 6             | www.qq.com        | click             | 20201002      |
--| 7             | www.sohu.com      | click             | 20201002      |
--| 8             | www.youku.com     | view              | 20201002      |
--| 9             | www.qq.com        | view              | 20201002      |
--| 10            | www.qq.com        | view              | 20201002      |
--| 11            | www.youku.com     | view              | 20201002      |
--| 12            | www.baidu.com     | click             | 20201007      |
--|...            |...                |...                |...            |


--题目： 求该表中每天的url被点击（action='click'）次数最多的top 5 ，以及基于当前排名的pv的累计值

--输出数据格式  dt,url,pv(点击总数),rank（排名）, psum 当天的点击数累计值（截止当天当前排名的pv的总和）
--注意，如果有排名相同的，rank 排名取相同的值，后一位递增，比如 1 2 3 3 5 ，或者 1 2 3 4 5 5 等，
--psum的计算逻辑如示例中所示，计算当前排名下的累计的pv值；如果排名相同，则如示例所示，两个排名5的，按生成顺序累计叠加。
-- 结果数据示例


--+-----------+-------------------+--------+---------+--------+--+
--|     dt    |         url       |   pv  |   rank  |   psum |          psum计算逻辑解析
--+-----------+-------------------+--------+---------+--------+--+
--| 20201001  | www.58.com        | 3641   | 1       | 3641   |          3614  
--| 20201001  | www.qq.com        | 3637   | 2       | 7278   |          3614+3637
--| 20201001  | www.douban.com    | 3634   | 3       | 10912  |          3614+3637+3634
--| 20201001  | www.jd.com        | 3606   | 4       | 14518  |          3614+3637+3634+3606
--| 20201001  | www.baidu.com     | 3574   | 5       | 18092  |          3614+3637+3634+3606+3574
--| 20201001  | www.youku.com     | 3574   | 5       | 21666  |          3614+3637+3634+3606+3574+3574
--| 20201002  | www.jd.com        | 3643   | 1       | 3643   |
--| 20201002  | www.weibo.com     | 3637   | 2       | 7280   |
--| 20201002  | www.douban.com    | 3620   | 3       | 10900  |
--| 20201002  | www.youku.com     | 3579   | 4       | 14479  |
--| 20201002  | www.sohu.com      | 3555   | 5       | 18034  |
--| 20201003  | www.douban.com    | 3634   | 1       | 3634   |

SELECT * from(
SELECT a.*,dense_rank()OVER(PARTITION BY dt ORDER BY pv) 排名,
SUM(pv) OVER(PARTITION BY dt ORDER BY pv) psum FROM(
select dt,url,count(*)pv from urlrecord   where action='click' group by  dt,url) a) WHERE 排名<=5












once you are done with this create a github repo to put that link in your resume. Some example github links:
https://github.com/ptyadana/SQL-Data-Analysis-and-Visualization-Projects/tree/master/Advanced%20SQL%20for%20Application%20Development
https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/COVID%20Portfolio%20Project%20-%20Data%20Exploration.sql

-- to check the list of databases in the sql server
SELECT name FROM sys.databases;

-- To use the project named 'Credit Card Transactions Project' for the analysis purpose.
USE [Credit Card Transactions Project];
GO

-- To check the records in 'credit_card_transcations' table under 'Credit Card Transactions Project'
select * from credit_card_transcations

--This project focuses on analyzing consumer spending behavior using a real-world credit card transactions dataset.
-- Total no of columns in data are 7 
-- total no of records are 26052

--A. Exploratory Data Analysis (EDA) Using SQL

--Key Objectives of EDA 

--✅ Understand spending trends over time
--✅ Identify popular spending categories
--✅ Analyze card type usage patterns
--✅ Examine geographical spending distribution

	--A.1. Timeframe of Transactions: Focus on getting the range of data and get the timeframe of data
	select min(transaction_date) as min_date, max(transaction_date) as max_date
	from credit_card_transcations
	-- Insight: Transactions span from October 2013 to May 2015.

	--A.2. Card Types Used : Focus on getting different card types
	select distinct card_type 
	from credit_card_transcations
	--Insight: The dataset includes four card types: Silver, Gold, Platinum, and Signature.


	--A.3. Expense Categories : Focus on getting different expense type
	select distinct exp_type 
	from credit_card_transcations
	--Insight: we have 6 categories of exp_type such as Entertainment, Food, Bills, Fuel, Travel and Grocery

	--A.4. Geographical Distribution: Focus on getting different cities included in dataset
	select distinct city 
	from credit_card_transcations
	--Insight: Transactions occurred in 986 unique cities, indicating a wide geographic spread.


--Solve below questions
--1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 

with cte1 as( -- getting total amount by city
	select city, sum(amount) as amount_spent_by_city
	from credit_card_transcations
	group by city
),
total_amount_spent as( -- getting total amount overall
	select sum(cast(amount as bigint)) as total_amount 
	from credit_card_transcations
)
-- Things we did in below query
--1- Performing cross join to combine total amount city amount, we do not need to define the join condition.
--2- When we multiply with 1.0, integer is converted to decimal/float no
--3- Multiplying with 100 to get the percentage value
--4- Using round to reduce the number of decmials to 2
select top 5 cte1.*, total_amount_spent.total_amount, 
round((cte1.amount_spent_by_city*1.0/total_amount_spent.total_amount)*100,2) as city_amount_in_percent 
from cte1, total_amount_spent
order by cte1.amount_spent_by_city desc


--2- write a query to print highest spend month and amount spent in that month for each card type

select * from credit_card_transcations

--using rank function.
with cte1 as (
select card_type, datepart(year,transaction_date) as year_of_transaction,
datepart(month,transaction_date) as month_of_transaction, sum(amount) as total_spent
from credit_card_transcations
group by card_type,datepart(year,transaction_date), datepart(month,transaction_date)
)
select * from (select *, rank() over(partition by card_type order by total_spent) as rn
from cte1) sub_query1
where rn=1



3- write a query to print the transaction details(all columns from the table) for each card type when
it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)

-- cummulative sum means running sum
-- for each card type we have to identify when it is reaching the cumulative of 1000000, including transaction id and transaction date
with cte as(
select *,sum(amount) over(partition by card_type order by transaction_date,transaction_id) as total_spend
from credit_card_transcations
)
,cte2 as (
select *, rank() over(partition by card_type order by total_spend asc) as rn
from cte
where total_spend >=1000000
)
select * from cte2
where rn=1

--4- write a query to find city which had lowest percentage spend for gold card type

select * from credit_card_transcations

with cte1 as(
	select city,card_type, sum(amount) as amount_spent_by_city
	,sum(case when card_type='Gold' then amount end) as gold_amnt_by_city
	from credit_card_transcations
	group by city,card_type
	--order by city,card_type
)
select top 1 city, sum(gold_amnt_by_city)*1.0/sum(amount_spent_by_city) as gold_spent_ratio
from cte1
group by city
having sum(gold_amnt_by_city) is not null
order by gold_spent_ratio

--another way
WITH cte AS (
    SELECT 
        city, 
        SUM(amount) AS total_amount_spent, 
        SUM(CASE WHEN card_type = 'Gold' THEN amount ELSE 0 END) AS gold_amount_spent
    FROM credit_card_transcations
    GROUP BY city
)
SELECT TOP 1 
    city, 
    1.0 * gold_amount_spent / total_amount_spent AS gold_spent_ratio
FROM cte
WHERE gold_amount_spent > 0  -- Ensure city has Gold spending
ORDER BY gold_spent_ratio;


--5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)

--using cte
with cte as(
select city,exp_type,min(amount) as min_amount_exp_type ,max(amount)as max_amount_exp_type
group by city,exp_type
),
--using window functions -rank
cte2 as(
select *,
rank() over(partition by city order by max(amount) desc) as highest_rank,
rank() over(partition by city order by min(amount) asc) as lowest_rank
from credit_card_transcations
)
--using case when statement
select city,
max(case when highest_rank=1 then exp_type end) as highest_exp_type
,min(case when lowest_rank=1 then exp_type end) as lowest_exp_type
from cte2 
group by city


--6- write a query to find percentage contribution of spends by females for each expense type

--using cte
with cte as(
select exp_type, sum(amount) as total_amount,
sum(case when gender='F' then amount else 0 end) as Female_only_amount
from credit_card_transcations
group by exp_type
)

-- dividing integer by integer leads to 0.
select exp_type,
(Female_only_amount*1.0/total_amount) as Female_percentage
from cte
order by Female_percentage desc



7- which card and expense type combination saw highest month over month growth in Jan-2014

-- clear case of lead/lag because you have to compare with the previous month. (jan2024 to december 2023)

--we need year and month info to get the mom growth
with cte1 as (
select card_type, exp_type, datepart(year,transaction_date) as year_of_transaction,
datepart(month,transaction_date) as month_of_transaction, sum(amount) as total_spent
from credit_card_transcations
group by card_type, exp_type, datepart(year,transaction_date), datepart(month,transaction_date)
)
--  we need lag to calculate previous month sales to calculate mom growth
,cte2 as 
(select *,lag(total_spent,1) over(partition by card_type, exp_type order by year_of_transaction,month_of_transaction) as previous_month_spent
from cte1)
-- to find top card type and expense type combination with highest growth
select top 1 *, (total_spent-previous_month_spent)*1.0/previous_month_spent as mom_growth
from cte2
where previous_month_spent is not null and year_of_transaction=2014 and month_of_transaction=1
order by mom_growth desc


8- during weekends which city has highest total spend to total no of transcations ratio 

--calculating weekend using datepart/ datename
with cte as(
select *,datename(weekday,transaction_date) as weekend
from credit_card_transcations
where datename(weekday,transaction_date) in ('Saturday','Sunday') 
)
select top 1 city,sum(amount) as total_spent, count(transaction_id) as transaction_cnt, sum(amount)/ count(transaction_id) as ratio
from cte
group by city
order by ratio desc

9- which city took least number of days to reach its 500th transaction after the first transaction in that city

select * from credit_card_transcations

with cte as(
select *,row_number() over(partition by city order by transaction_date) as transaction_cnt
--,datepart(day,transaction_date) as transaction_day
from credit_card_transcations
)
,cte2 as(
select c1.city,c1.transaction_date as transaction_date_start ,c1.transaction_cnt as transaction_cnt_start,
c2.transaction_date as transaction_date_end,c2.transaction_cnt  as transaction_cnt_end
from cte as c1
inner join cte as c2
on c1.city=c2.city
where c1.transaction_cnt = 1 and c2.transaction_cnt = 500
)
select top 1 city,datediff(day,transaction_date_start,transaction_date_end) as difference_day
from cte2
order by difference_day

--another way
--using window function 
with cte as(
select *,row_number() over(partition by city order by transaction_date) as rn
from credit_card_transcations
)
select top 1 city, count(1), datediff(day,min(transaction_date),max(transaction_date)) as datdiff_indays
from cte
where rn=1 or rn=500
group by city
having count(1)=2
order by datdiff_indays asc

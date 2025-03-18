# Project Overview

This project focuses on analyzing consumer spending behavior using a real-world credit card transactions dataset. The dataset, sourced from Kaggle, contains 26,000+ records covering transactions from October 2013 to May 2015.The analysis is performed using SQL Server queries to extract key insights related to spending trends, geographical distribution, and card usage patterns.
![tRaDVO_N](https://github.com/user-attachments/assets/f917d7e3-0bf6-4d6c-aca5-c0f76bab0b80)



# Dataset Source

📥 [Download Dataset from Kaggle](https://www.kaggle.com/datasets/thedevastator/analyzing-credit-card-spending-habits-in-india)

## Dataset Structure

The dataset consists of 26,052 transactions with 7 columns providing detailed transaction data.
Columns in the Dataset:

    transaction_id: Unique identifier for each transaction

    transaction_date: Date of the transaction (ranging from October 2013 to May 2015)

    card_type: Type of credit card used (e.g., Silver, Gold, Platinum, Signature)

    exp_type: Expense category (e.g., Entertainment, Food, Bills, Fuel, Travel, Grocery)

    amount: Transaction amount

    city: City where the transaction occurred (986 unique cities)

    gender: Gender of the cardholder
    
# Credit Card Transactions Overview

This dataset contains over <b>26,000 transactions</b> spanning from <b> October 2013 to May 2015 </b>, providing a comprehensive two-year window into consumer spending patterns.
The transactions are linked to four different card types— <b>Silver, Gold, Platinum, and Signature </b>—each likely representing a different tier of customer privileges and benefits.
Spending Categories and Consumer Behavior

<b>Cardholders used their credit cards across a variety of six major expense categories:</b>

    Entertainment
    Food
    Bills
    Fuel
    Travel
    Grocery

These categories suggest a mix of essential spending (bills, groceries, fuel) and discretionary spending (entertainment, food, and travel). This could help in identifying consumer spending trends, such as whether higher-tier cardholders tend to spend more on travel and entertainment, while others focus on necessities.

<b>Geographic Reach</b>

The dataset also reveals that transactions occurred in a wide geographic spread, covering 986 unique cities. This indicates that the card services are widely accepted across various regions, possibly including both metropolitan and smaller cities. Analyzing transaction density by location could help in identifying high-spending regions, potential market expansion opportunities, or regional trends in spending habits.

<b>--Key Objectives </b>

--✅ Understand spending trends over time

--✅ Identify popular spending categories

--✅ Analyze card type usage patterns

--✅ Examine geographical spending distribution



## Exploratory Data Analysis (EDA) Questions

<b>A. Data Overview</b>

    What is the timeframe of the transactions?

    What are the different card types used in the dataset?

    What are the various expense categories?

    What are the different cities included in the dataset?
    

<b>B. Business Questions </b>

    Identify the top 5 cities with the highest credit card spends and their percentage contribution.

    Find the month with the highest spend for each card type.

    Identify the first transaction for each card type that reached a cumulative spend of 1,000,000.

    Find the city with the lowest percentage spend for Gold card type.

    Determine the highest and lowest expense type for each city.

    Calculate the percentage contribution of spends by females for each expense category.

    Identify the card and expense type combination that saw the highest month-over-month growth in January 2014.

    Find the city with the highest total spend to total transactions ratio during weekends.

    Determine the city that took the least number of days to reach its 500th transaction after the first transaction in that city.
    

<b>Technologies Used</b>

    SQL Server for query execution and data analysis.
    

<b>How to Use</b>

    Clone the repository and set up the database in SQL Server.

    Run the provided queries to explore the dataset and answer the business questions.
    


<b>Future Enhancements</b>

    Data visualization using Python or Power BI

    Machine learning models for predictive analysis of spending behavior

    Integration of additional datasets for deeper insights

Author

    [Saurabh Singh]






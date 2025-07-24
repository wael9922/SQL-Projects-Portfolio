# 🍽️ Restaurant Order Analysis – SQL Project

## 📊 Overview

This project explores a fictional restaurant's order data to uncover key insights using SQL. The goal is to answer business-critical questions such as:

- Which items and cuisines are most popular?
- When are the busiest times?
- What does a high-value order look like?
- Which items appear most in the highest-spending orders?

The dataset contains order-level data and menu item metadata including names, categories, prices, and timestamps.

## 💡 Business Questions Answered

1. **What were the most and least ordered items?**  
   → Identifies top- and bottom-performing items by count and category.

2. **Were there certain times that had more or fewer orders?**  
   → Analyzes hourly order trends and revenue to identify peak business hours.

3. **Which cuisines should we focus on developing more menu items for?**  
   → Evaluates categories (cuisines) by total orders and revenue contribution.

4. **What do the highest spend orders look like?**  
   → Displays item breakdown and total amount spent for the top 20 orders.

5. **In the top 10 highest-value orders, which items were ordered the most?**  
   → Highlights key menu items frequently included in expensive orders — great for upselling or bundling.

## 📊 Key Findings:

![Revenue per Cuisine](charts\Revnue_and_Orders_Per_Cuisine.png)

- **Italian** and **Asian** cuisines lead in both popularity and revenue.

![Orders Per Hour](charts\orders_per_hour.png)

- The busiest hours are around **12 PM and 5 PM**, both in number of orders and total revenue.

![Most Ordered Items](charts\most_ordered_items.png)

- Most ordered items were `Hamburger`, `Edamame`, and `Korean Beef Bowl`.

- Interestingly, while`Hamburger` and `Edamame` were the most ordered items overall, `Eggplant Parmesan ` and `Chips & Salsa` were the most ordered within the ten highest-value orders.

---

## 💡 Business Insights

- While **Italian cuisine** had the most revnue, **Asian cuisine** had a higher number of items sold. iven that the revenue difference between the two is relatively small, I believe it's more insightful to prioritize number of orders as the key indicator of customer preference.

- My recommendation for the restaurant is to improve the Asian cuisine and consider adding new asian cuisine items to the menue to meet growing demand.

- **From 12 PM until 7 PM** the resturant must ensure that they have enough staff and kitchen supplies to maintain service quality and operational efficiency, especially during **lunchtime (12 PM–2 PM)** and **dinnertime (5 PM–7 PM)**.

## 🧪 Tools Used

- **SQL (PostgreSQL syntax)**
- SQL concepts used:
  - Window functions
  - CTEs (Common Table Expressions)
  - Subqueries and filtering
  - Aggregation and grouping
  - String aggregation with `STRING_AGG`

## 📁 Files

- `project_queries.sql`: All SQL queries used for analysis, categorized by business question.

## ✅ Author Notes

> All queries were written from scratch without guided instruction. The analysis reflects real-world thinking about business value, customer behavior, and operational improvement.

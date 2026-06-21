# Payment Revenue Drop — Root Cause Analysis

## Overview

This project investigates a **revenue decline** observed over the last two months in an e-commerce orders dataset. Sessions remained stable during this period, pointing to a conversion/payment quality issue rather than a traffic problem.

The analysis was conducted entirely in SQL, progressively narrowing down the root cause through a series of diagnostic queries.

This project is not tutorial based. It is intended to demonstrate **business intelligence and data literacy** skills.

---

## Dataset

**Table:** `orders`

| Column | Type | Description |
| --- | --- | --- |
| `order_date` | Date | Date of the session |
| `order_value` | Numeric | Revenue value of the order |
| `device_type` | Text | Desktop or Mobile |
| `payment_method` | Text | Card, Cash, Wallet |
| `city` | Text | Customer city |
| `added_to_cart` | Boolean | Whether the session added an item to cart |
| `started_checkout` | Boolean | Whether the session reached checkout |
| `payment_success` | Boolean | Whether the payment was completed successfully |

---

## Methodology

The analysis follows a **funnel-based diagnostic approach**, slicing the data by different dimensions such as device type, city and payment method to isolate where and why the drop occurred.

---

### Funnel Metrics Defined

```
Conversion Rate         = sessions that added to cart    / total sessions
Checkout Rate           = sessions that reached checkout / sessions that added to cart
Successful Payment Rate = completed orders               / sessions that reached checkout
```

---

## Analysis

### Monthly Revenue and Traffic Trend

```sql
SELECT 
	FORMAT(order_date, 'yyyy-MM') as months,
	SUM(order_value) as monthly_revenue,
	COUNT(*) as monthly_sessions
FROM orders
GROUP BY FORMAT(order_date, 'yyyy-MM') 
ORDER BY FORMAT(order_date, 'yyyy-MM');
```

![Revenue Vs Traffic Sessions](Charts/Revenue%20Vs%20Traffic%20Sessions.png)

#### Key Findings

- **Revenue is dropping** → the revenue in the last two months dropped significantly
- **Sessions are stable** → the problem of the revenue is not traffic

---

### Monthly Revenue and Traffic Trend By Device

```sql
SELECT 
	device_type,
	FORMAT(order_date, 'yyyy-MM') as months,
	SUM(order_value) as monthly_revenue,
	COUNT(*) as monthly_sessions
FROM orders
GROUP BY device_type, FORMAT(order_date, 'yyyy-MM') 
ORDER BY FORMAT(order_date, 'yyyy-MM');
```

![Revenue Vs Traffic Sessions By Device](Charts/Revenue%20Vs%20Traffic%20Sessions%20By%20Device.png)

#### Key Findings

- **Revenue is dropping** → the revenue in the last two months dropped especially by `Mobile` customers
- **Sessions are stable** → the traffic is stable for both devices
- **Mobile is more affected** than Desktop, but Desktop also shows a notable drop

---

### Funnel Conversion Rates by Device Type, Per Month

```sql
WITH monthly_report_device as(
	SELECT 
		device_type,
		FORMAT(order_date, 'yyyy-MM') as months,
		COUNT(*) as total_sessions,
		SUM(order_value) as total_revenue,
		SUM(CAST(added_to_cart AS INT)) as total_sessions_added_to_cart,
		SUM(CAST(started_checkout AS INT)) as total_sessions_reached_checkout,
		SUM(CAST(payment_success AS INT)) as total_completed_orders
	FROM orders
	GROUP BY device_type, FORMAT(order_date, 'yyyy-MM')
)
SELECT
	device_type,
	months,
	total_revenue,
	ROUND(100.00*total_sessions_added_to_cart    / NULLIF(total_sessions, 0), 2)                   as added_to_cart_rate,
	ROUND(100.00*total_sessions_reached_checkout / NULLIF(total_sessions_added_to_cart, 0), 2)     as checkout_rate,
	ROUND(100.00*total_completed_orders          / NULLIF(total_sessions_reached_checkout, 0), 2)  as successful_payment_rate
FROM monthly_report_device
ORDER BY months;
```

![Revenue Vs Conversion Rates by Device and Month](Charts/Revenue%20Vs%20Conversion%20Rates%20by%20Device%20Month.png)
#### Key Findings

- **Revenue is dropping** → this analysis shows a correlation between the drop in revenue and conversion rate, especially in the last stage of the funnel
- **Stable Checkout Rate** rules out add-to-cart or product issues
- **Drop in the Successful Payment Rate** → this drop while earlier stages are stable may indicate an issue in payment execution, causing the revenue drop
- **Mobile is more affected** than Desktop, but Desktop also shows a notable drop in revenue and Successful Payment Rate

---

### Funnel Conversion Rates by Payment Method, Per Month

```sql
WITH monthly_report_payment_method as(
	SELECT 
		payment_method,
		FORMAT(order_date, 'yyyy-MM') as months,
		COUNT(*) as total_sessions,
		SUM(order_value) as total_revenue,
		SUM(CAST(added_to_cart AS INT)) as total_sessions_added_to_cart,
		SUM(CAST(started_checkout AS INT)) as total_sessions_reached_checkout,
		SUM(CAST(payment_success AS INT)) as total_completed_orders
	FROM orders
	GROUP BY payment_method, FORMAT(order_date, 'yyyy-MM')
)
SELECT
	payment_method,
	months,
	total_revenue,
	ROUND(100.00*total_sessions_added_to_cart    / NULLIF(total_sessions, 0), 2)                   as added_to_cart_rate,
	ROUND(100.00*total_sessions_reached_checkout / NULLIF(total_sessions_added_to_cart, 0), 2)     as checkout_rate,
	ROUND(100.00*total_completed_orders          / NULLIF(total_sessions_reached_checkout, 0), 2)  as successful_payment_rate
FROM monthly_report_payment_method
ORDER BY months;
```

#### Key Findings

- **The drop is across all payment methods** → rules out a single payment provider as the root cause

---

### Funnel Conversion Rates by City for March

```sql
WITH cities_report_march as(
	SELECT 
		city,
		FORMAT(order_date, 'yyyy-MM') as months,
		COUNT(*) as total_sessions,
		SUM(order_value) as total_revenue,
		SUM(CAST(added_to_cart AS INT)) as total_sessions_added_to_cart,
		SUM(CAST(started_checkout AS INT)) as total_sessions_reached_checkout,
		SUM(CAST(payment_success AS INT)) as total_completed_orders
	FROM orders
	WHERE FORMAT(order_date, 'yyyy-MM') = '2026-03'
	GROUP BY city, FORMAT(order_date, 'yyyy-MM')
)
SELECT
	city,
	months,
	total_revenue,
	ROUND(100.00*total_sessions_added_to_cart    / NULLIF(total_sessions, 0), 2)                   as added_to_cart_rate,
	ROUND(100.00*total_sessions_reached_checkout / NULLIF(total_sessions_added_to_cart, 0), 2)     as checkout_rate,
	ROUND(100.00*total_completed_orders          / NULLIF(total_sessions_reached_checkout, 0), 2)  as successful_payment_rate
FROM cities_report_march
ORDER BY months;
```

![March Funnel Conversion Rates by City](Charts/March%20Funnel%20Conversion%20Rates%20by%20City.png)

#### Key Findings

- **Stable Checkout Rate across all cities** rules out add-to-cart or product issues in any city
- **Drop in the Successful Payment Rate** → all cities show a drop, but `Amman` and `Irbid` had a significantly larger drop compared to others

---

### Funnel Conversion Rates for Amman & Irbid by Device — March

```sql
WITH cities_device_report_ as(
	SELECT 
		city,
		device_type,
		FORMAT(order_date, 'yyyy-MM') as months,
		COUNT(*) as total_sessions,
		SUM(order_value) as total_revenue,
		SUM(CAST(added_to_cart AS INT)) as total_sessions_added_to_cart,
		SUM(CAST(started_checkout AS INT)) as total_sessions_reached_checkout,
		SUM(CAST(payment_success AS INT)) as total_completed_orders
	FROM orders
	WHERE FORMAT(order_date, 'yyyy-MM') = '2026-03' AND city IN('Amman', 'Irbid')
	GROUP BY city, device_type, FORMAT(order_date, 'yyyy-MM')
)
SELECT
	city,
	device_type,
	months,
	total_revenue,
	ROUND(100.00*total_sessions_added_to_cart    / NULLIF(total_sessions, 0), 2)                   as added_to_cart_rate,
	ROUND(100.00*total_sessions_reached_checkout / NULLIF(total_sessions_added_to_cart, 0), 2)     as checkout_rate,
	ROUND(100.00*total_completed_orders          / NULLIF(total_sessions_reached_checkout, 0), 2)  as successful_payment_rate
FROM cities_device_report_
ORDER BY city;
```

![Conversion Rate By City and Device](Charts/Conversion%20Rate%20By%20City%20and%20Device.png)

#### Key Findings

- **Mobile users in Amman** had the largest drop in Successful Payment Rate compared to Desktop users in Amman and other cities
- Adding device-level granularity confirms that the issue is concentrated in **Mobile + specific cities**, suggesting a possible network or mobile payment infrastructure issue in those regions

---

## Conclusions & Next Steps

The data points to a **payment processing issue** that emerged in the last two months, disproportionately affecting mobile users — particularly in Amman and Irbid. 
- investigating with engineering or the payment provider to check for payment failures/declines especially in march.
- verify if an update for webiste/app was deployed in the last two monthes.
- finally point them to focus more on issues in specific cities like Amman and Irbid.


## Tools

| Tool | Purpose |
| --- | --- |
| SQL Server | Data extraction and analysis |
| Excel | Building charts and visualizations |
| Obsidian | Documentation and write-up |
| AI | Assisted with rephrasing and wording |
# User Registration Trends & Moving Average

## Problem

Given a `users` table containing user registration timestamps, generate a daily report that:

- Includes every date between the earliest and latest registration date.
- Shows the number of user registrations for each day.
- Displays an 8-day running average of registrations.
- Treats days with no registrations as having 0 signups.
- Orders results by date in ascending order.

---

## Business Goal

This type of analysis is commonly used to:

- Monitor platform growth.
- Identify signup trends.
- Smooth daily fluctuations using a moving average.
- Support reporting dashboards and KPI tracking.

---

## Key Insight

The most important requirement is:

> Dates with no registrations must still appear in the report.

Because the `users` table only contains dates where registrations occurred, a calendar table must first be generated.

After creating a complete date range, registrations can be joined to the calendar and aggregated.

---

## Approach

### Step 1: Generate a Calendar

Create a date series from:

- Earliest registration date
- Latest registration date

This ensures every date appears in the final report.

### Step 2: Join Registrations

Use a `LEFT JOIN` between the calendar and the users table.

This allows dates with no registrations to remain in the result set.

### Step 3: Count Daily Signups

Aggregate registrations by date using:

```sql
COUNT(u.id)
```

Days without registrations automatically return:

```text
0
```

### Step 4: Calculate Moving Average

Use a window function to calculate an 8-day running average:

```sql
AVG(sign_ups)
OVER (
    ORDER BY date
    ROWS BETWEEN 7 PRECEDING
             AND CURRENT ROW
)
```

The window includes:

- Current day
- Previous 7 days

For the first few dates, the average is calculated using the available rows only.

---

## SQL Concepts Used

### Recursive CTE

Used to generate a calendar table.

### LEFT JOIN

Used to preserve dates with no activity.

### Aggregation

Used to count daily registrations.

### Window Functions

Used to calculate a rolling average.

### Time-Series Analysis

Used to analyze signup trends over time.

---

## Pattern Learned

### Calendar Table Pattern

When a report must include dates without activity:

1. Generate a complete date range.
2. LEFT JOIN the fact table.
3. Aggregate results.

This pattern is frequently used in:

- Sales reporting
- Website traffic analysis
- User growth dashboards
- Financial reporting

---

### Moving Average Pattern

Moving averages help smooth short-term fluctuations and reveal longer-term trends.

Example:

| Date | Signups |
|--------|---------:|
| Day 1 | 5 |
| Day 2 | 8 |
| Day 3 | 0 |
| Day 4 | 7 |

Running averages:

| Date | Avg Signups |
|--------|-----------:|
| Day 1 | 5.00 |
| Day 2 | 6.50 |
| Day 3 | 4.33 |
| Day 4 | 5.00 |

---

## Skills Demonstrated

- Time-series reporting
- Recursive CTEs
- Window functions
- Moving averages
- Handling missing data
- Analytical SQL design

---

## Final Query

See `solution.sql`.
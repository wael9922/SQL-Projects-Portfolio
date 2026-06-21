# Contest Streak Analysis

## Problem

Given contest submission data, generate a daily report that:

1. Counts the number of hackers who have made **at least one submission every day starting from the first day of the contest up to the current day**.
2. Identifies the hacker who made the **highest number of submissions on each day**.
3. If multiple hackers have the same highest submission count on a day, select the hacker with the **lowest hacker_id**.
4. Return the results ordered by contest date.

---

## Business Goal

This type of analysis is useful for:

- Tracking participant engagement.
- Measuring retention throughout a contest.
- Identifying highly active users.
- Building daily leaderboard reports.

---

## Key Insight

The most difficult requirement was determining whether a hacker maintained a submission streak.

The business rule:

> Submitted at least once every day from the beginning of the contest through the current day.

can be translated into:

```text
Distinct submission dates
=
Number of contest days elapsed
```

For example:

| Contest Day | Submission Dates | Distinct Days | Qualifies |
|------------|------------------|--------------:|-----------|
| 3 | 1,2,3 | 3 | Yes |
| 3 | 1,3 | 2 | No |

This mathematical translation makes the problem solvable using SQL.

---

## Approach

### Step 1: Calculate Submission Streaks

For each hacker and contest date:

- Count distinct submission dates from the contest start date through the current date.
- Compare this count to the contest day number.

If:

```text
streak = contest_day
```

the hacker has submitted every day.

---

### Step 2: Count Qualified Hackers

For each contest date:

- Count distinct hackers whose streak remains intact.

This produces the daily participant retention metric.

---

### Step 3: Calculate Daily Submission Totals

For each:

```text
submission_date
+
hacker_id
```

count the number of submissions.

---

### Step 4: Rank Daily Leaders

Use:

```sql
ROW_NUMBER()
OVER (
    PARTITION BY submission_date
    ORDER BY total_submissions DESC,
             hacker_id
)
```

This ensures:

1. Highest submission count wins.
2. Ties are resolved using the smallest hacker_id.

---

### Step 5: Combine Results

Join:

- Daily streak counts
- Daily submission leaders

to produce the final report.

---

## SQL Concepts Used

### Correlated Subqueries

Used to calculate submission streaks.

### Common Table Expressions (CTEs)

Used to break the solution into logical stages.

### Aggregation

Used for counting submissions and participants.

### Window Functions

Used to rank daily submission leaders.

### ROW_NUMBER

Used to implement tie-breaking rules.

---

## Pattern Learned

### Streak Detection Pattern

Many business requirements involve consecutive activity.

Instead of checking every date individually, convert the requirement into:

```text
Observed Activity Count
=
Expected Activity Count
```

For this problem:

```text
Distinct Submission Days
=
Contest Days Elapsed
```

This pattern can be reused for:

- Login streaks
- Attendance tracking
- Daily habits
- Subscription activity
- User engagement analysis

---

### Ranking With Tie Handling

A common leaderboard pattern is:

```sql
ROW_NUMBER()
OVER (
    PARTITION BY group
    ORDER BY metric DESC,
             tie_breaker
)
```

This guarantees a single winner per group while respecting business rules.

---

## Skills Demonstrated

- Business-rule translation
- Streak analysis
- Leaderboard generation
- Window functions
- Ranking and tie handling
- Multi-step analytical SQL design

---

## Challenges Encountered

The wording of the streak requirement was initially ambiguous.

The key realization was that:

```text
Submitted every day
```

can be measured by comparing:

```text
Distinct submission dates
```

against:

```text
Number of contest days elapsed
```

Once that relationship was identified, the SQL implementation became much more straightforward.

---

## Final Query

See `solution.sql`.
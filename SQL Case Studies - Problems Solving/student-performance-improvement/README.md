# Student Performance Improvement Analysis

## Problem

Given student course data for the academic year 2022–2023, identify students who have shown **consistent improvement across three trimesters**:

- Michaelmas term (Oct–Dec 2022)
- Lent term (Jan–Mar 2023)
- Summer term (Apr–Jun 2023)

A student is considered to have consistent improvement if:

```text
Lent average > Michaelmas average
AND
Summer average > Lent average
```

---

## Business Goal

This analysis is useful for:

- Identifying high-performing students
- Measuring learning progression over time
- Academic performance monitoring
- Supporting student success interventions
- Evaluating teaching effectiveness

---

## Key Insight

The key challenge is transforming row-level course records into **term-level performance metrics per student**.

Instead of analyzing individual course scores, we first aggregate data into:

```text
Student → Term → Average Score
```

Only after this transformation can we compare performance across time periods.

---

## Approach

### Step 1: Filter Relevant Academic Year

Only include records within:

```text
2022-10-01 to 2023-06-30
```

This ensures that only valid trimester data is used.

---

### Step 2: Assign Courses to Trimesters

Each course is classified into one of three terms:

- Michaelmas (Oct–Dec 2022)
- Lent (Jan–Mar 2023)
- Summer (Apr–Jun 2023)

This is done using conditional logic.

---

### Step 3: Calculate Term Averages

For each student:

```text
AVG(score per trimester)
```

This produces a single row per student containing:

- Michaelmas average
- Lent average
- Summer average

---

### Step 4: Compare Performance Across Terms

Determine whether:

```text
Lent_avg > Michaelmas_avg
AND
Summer_avg > Lent_avg
```

If both conditions are true, the student is flagged as improving consistently.

---

### Step 5: Format Output

The final output includes:

- Student ID
- Name
- Formatted trimester averages
- Boolean improvement flag

---

## SQL Concepts Used

### Conditional Aggregation

Used to compute averages per trimester:

```sql
AVG(CASE WHEN condition THEN score END)
```

---

### Date Filtering

Used to ensure only valid academic year data is included.

---

### Common Table Expressions (CTEs)

Used to separate aggregation logic from final comparison logic.

---

### CASE Expressions

Used to assign values to specific time periods.

---

## Pattern Learned

### Time-Based Grouping Pattern

A common analytical requirement is:

> Group continuous time data into meaningful business periods

Examples:

- Academic terms
- Fiscal quarters
- Product lifecycle phases
- Customer onboarding stages

This is solved by:

1. Defining time boundaries
2. Assigning each record to a period
3. Aggregating within each period

---

### Trend Detection Pattern

This problem demonstrates a simple but powerful pattern:

```text
Metric(t2) > Metric(t1) > Metric(t0)
```

Used for:

- Student improvement tracking
- Sales growth analysis
- User engagement trends
- Performance monitoring

---

## Skills Demonstrated

- Conditional aggregation
- Time-series grouping
- Data transformation
- Trend analysis
- Business rule implementation
- Multi-step SQL design

---

## Challenges Encountered

The main challenge is not SQL syntax, but **structuring the data correctly before comparison**.

Once the data is transformed into:

```text
Student → Term → Average Score
```

the improvement logic becomes straightforward.

---

## Final Query

See `solution.sql`.
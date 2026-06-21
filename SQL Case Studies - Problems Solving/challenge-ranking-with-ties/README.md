# Challenge Ranking with Tie Handling

## Problem

Given two tables:

### Hackers

| Column | Description |
|----------|-------------|
| hacker_id | Unique hacker identifier |
| name | Hacker name |

### Challenges

| Column | Description |
|----------|-------------|
| challenge_id | Unique challenge identifier |
| hacker_id | Creator of the challenge |

Generate a report showing:

- `hacker_id`
- `name`
- Total number of challenges created by each hacker

The results must be ordered by:

1. Total challenges (descending)
2. hacker_id (ascending)

### Special Rule

If multiple hackers created the same number of challenges:

- Keep them only if that challenge count is the **maximum challenge count**.
- Otherwise exclude them from the result.

---

## Business Goal

This type of analysis is useful for:

- Leaderboards
- Contributor rankings
- Content creator reports
- Gamification systems

The challenge introduces an additional business rule that requires handling ties differently depending on whether the tied value is the maximum.

---

## Key Insight

The problem is not simply counting challenges.

The difficult part is determining:

> Which challenge counts should remain and which should be removed?

The solution requires analyzing two levels of aggregation:

### First Aggregation

Determine:

```text
Hacker
→
Number of challenges created
```

Example:

| Hacker | Challenges |
|----------|----------:|
| A | 8 |
| B | 7 |
| C | 7 |
| D | 5 |

---

### Second Aggregation

Determine:

```text
Challenge Count
→
Number of hackers with that count
```

Example:

| Challenge Count | Hackers |
|----------------|---------:|
| 8 | 1 |
| 7 | 2 |
| 5 | 1 |

This reveals which counts are tied.

---

## Approach

### Step 1: Count Challenges Per Hacker

Generate:

```text
hacker_id
name
total_challenges
```

using aggregation.

---

### Step 2: Analyze Ties

Group by:

```text
total_challenges
```

and count how many hackers share each value.

Example:

```text
7 challenges
→
2 hackers
```

This indicates a tie.

---

### Step 3: Identify Maximum Challenge Count

Determine:

```text
MAX(total_challenges)
```

This value receives special treatment.

---

### Step 4: Apply Business Rules

Keep rows when:

### Condition 1

The challenge count is unique.

Example:

```text
8 challenges
1 hacker
```

Keep.

---

### Condition 2

The challenge count is tied but also equals the maximum challenge count.

Example:

```text
10 challenges
2 hackers
```

Keep both.

---

### Condition 3

The challenge count is tied and not the maximum.

Example:

```text
7 challenges
2 hackers
```

Remove both.

---

### Step 5: Sort Results

Order by:

```text
total_challenges DESC
hacker_id ASC
```

---

## SQL Concepts Used

### Aggregation

Used to count challenges per hacker.

### Multi-Stage Aggregation

Used to analyze challenge counts after computing them.

### Common Table Expressions (CTEs)

Used to separate the logic into manageable stages.

### Conditional Logic

Used to determine whether tied counts should be included.

### Subqueries

Used to identify the maximum challenge count.

---

## Pattern Learned

### Frequency of Frequencies

This challenge demonstrates an important analytical pattern:

First count:

```text
Entity
→
Frequency
```

Then count:

```text
Frequency
→
Number of entities
```

Example:

```text
Customer
→
Purchases

Purchases
→
Number of Customers
```

or

```text
Employee
→
Projects

Projects
→
Number of Employees
```

This pattern appears frequently in analytics and reporting.

---

### Tie Analysis Pattern

Many ranking problems involve special tie rules.

A useful strategy is:

1. Calculate the metric.
2. Analyze duplicate values.
3. Apply business rules based on uniqueness or ranking.

This approach often produces cleaner solutions than attempting to handle all logic in a single query.

---

## Skills Demonstrated

- Multi-stage aggregation
- Analytical problem solving
- Business-rule implementation
- Tie detection
- Data summarization
- Query decomposition using CTEs

---

## Challenges Encountered

The main challenge was determining how to identify and handle tied challenge counts.

The successful approach was to stop thinking about individual hackers and instead analyze:

```text
Challenge Count
→
How many hackers have that count?
```

Once ties were represented explicitly, the filtering rules became straightforward to implement.

This was a useful example of breaking a complex requirement into smaller analytical steps.

---

## Final Query

See `solution.sql`.
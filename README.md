# Trading Strategy Analysis (SQL)

**Tech stack:** SQL (PostgreSQL)  
**Domain:** Quantitative Trading / Strategy Research  

---

## 1. Project Overview

The goal of this project is to analyze three different execution scenarios of the same trading strategy in the U.S. stock market in order to determine which scenario is the most effective and profitable.

All data processing, cleaning, and analysis were performed using **SQL**.

---

## 2. Objectives of the Analysis

The main objectives of this analysis are:

- Compare strategy performance under different risk-to-reward ratios (1R, 2R, 3R)
- Evaluate win rates for each scenario
- Validate the quality and consistency of backtest data
- Identify data errors and structural inconsistencies
- Determine which scenario has a positive mathematical expectancy

---

## 3. Data Description

The input data consists of backtest results of a trading strategy applied to a defined universe of U.S. stocks over a specific time period.

The project includes three source files:

- **1R.csv** — strategy with a 1:1 risk-to-reward target  
- **2R.csv** — strategy with a 1:2 risk-to-reward target  
- **3R.csv** — strategy with a 1:3 risk-to-reward target  

All three scenarios use identical entry conditions and differ only in their profit-taking logic.

---

## 4. Data Cleaning and Validation

Several issues were identified and resolved during the data preparation stage.

### 4.1 Column Name Correction

In the original datasets, the `entry_time` and `exit_time` columns were swapped, which could lead to incorrect trade duration calculations.

To improve clarity and ensure correctness, the columns were renamed:

```sql
ALTER TABLE "1R"
RENAME COLUMN entry_time TO exit_tm;

### 4.2 Trade Duration Validation

Trade entry and exit timestamps were provided without seconds. As a result, a significant number of trades had identical entry and exit times.

Since trades with zero recorded duration cannot be reliably evaluated or validated, these records were excluded from the analysis.

A new metric, **Time_in_trade**, was calculated as the difference between exit and entry timestamps.  
Only trades with a duration greater than **1 second** were retained to ensure analytical reliability.

---

### 4.3 Initial Performance Evaluation

After filtering invalid trades, the total realized result (`total_r_realized`) was calculated for each scenario:

- **1R:** −1R  
- **2R:** +7R  
- **3R:** −14R  

At this stage, the strategy demonstrated profitability only under the **2R** configuration.

Win rates were also calculated based on empirical outcomes:

- **1R:** 48%  
- **2R:** 39%  
- **3R:** 16%  

When considering both win rate and risk-to-reward ratio, only the **2R** scenario exhibited a positive mathematical expectancy.

---

### 4.4 Date Format Normalization and Dataset Merge

The original datasets used different date formats across scenarios, which prevented direct comparison and aggregation.

To enable further analysis, all trade dates were converted into a unified date format.  
After normalization, the datasets were merged into a single analytical table.

This step ensured consistency across scenarios and enabled cross-scenario validation.

---

### 4.5 Identification of Missing Trades and Data Integrity Issues

During analysis of the merged dataset, it was observed that some trading days contained trades for only a single scenario.

This behavior contradicts the strategy logic, as all scenarios share identical entry conditions and therefore should generate trades simultaneously.

Further investigation revealed that several trades were present in the **2R** dataset but missing from **1R**, indicating a data collection or preparation error in the original backtest results.

These trades (6 in total, 4 profitable) were added back to the **1R** dataset, with results recalculated according to the 1R risk-to-reward rules.

After this correction:

- **1R total result:** +1R  
- **1R win rate:** 51%  

Despite the improvement, the **1R** scenario remains marginal and becomes economically non-viable once transaction costs are considered.

## 5. Analysis and Visualization

After completing data cleaning and validation, the following analyses were performed:

- **Cumulative PnL** was calculated for each scenario, clearly demonstrating the consistent underperformance of the **3R** configuration
- The **1R** scenario showed unstable and borderline results, with strong sensitivity to data quality and trade inclusion
- A **Profit/Loss Zone** was constructed to evaluate strategy viability across different combinations of risk-to-reward ratio and win rate
- Win rates were calculated directly from empirical trade outcomes rather than assumed distributions
- Based on the combined analysis of expectancy, stability, and sensitivity, the **2R** scenario emerged as the only robust and consistently profitable configuration

For the **2R** scenario, a **Winner/Loser distribution** was visualized to identify outcome patterns and confirm result stability.

---

## 6. Conclusions

- The **2R** scenario is the only configuration that demonstrates a stable and positive mathematical expectancy
- The **3R** scenario is consistently unprofitable and exhibits high statistical instability
- The **1R** scenario remains marginal and highly sensitive to data quality, trade filtering, and transaction costs
- Small data inconsistencies can materially alter results, highlighting the importance of strict data validation in trading system evaluation

---

## 7. Limitations and Future Improvements

While the analysis provides meaningful insights, several limitations remain:

- Transaction costs, commissions, and slippage were not included and would negatively impact especially low R/R configurations
- The analysis is based on a single market regime and a limited time period
- No risk-adjusted metrics (e.g. drawdowns, Sharpe-like measures) were evaluated

Potential future improvements include:

- Incorporating transaction costs and execution slippage
- Analyzing drawdowns and volatility-based risk metrics
- Testing the strategy across multiple market regimes
- Automating data quality and consistency validation checks

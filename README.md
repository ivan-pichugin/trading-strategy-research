# Trading Strategy Analysis (SQL)
## 1. Project Overview
The goal of this project is to analyze three different execution scenarios of the same trading strategy in the U.S. stock market in order to determine which scenario is the most effective and profitable.
All data processing, cleaning and analysis were performed using SQL.

## 2. Objectives of the Analysis
The main objectives of this analysis are:
	•	To compare the performance of the trading strategy under different risk-to-reward ratios (1R, 2R, 3R)
	•	To evaluate the win rate for each scenario
	•	To validate the quality and consistency of the backtest data
	•	To identify data errors and structural inconsistencies
	•	To determine which scenario has a positive mathematical expectation

## 3. Data Description
The input data consists of backtest results of a trading strategy applied to a defined universe of U.S. stocks over a specific time period.
The project includes three source files:
	•	1R.csv — strategy with a 1:1 risk-to-reward target
	•	2R.csv — strategy with a 1:2 risk-to-reward target
	•	3R.csv — strategy with a 1:3 risk-to-reward target
All three scenarios use identical entry conditions and differ only in their profit-taking logic.

## 4. Data Cleaning and Validation
Several issues were identified and resolved during the data preparation stage.

4.1 Column Name Correction
In the original datasets, the entry_time and exit_time columns were swapped, which could lead to incorrect calculations of trade duration.
To improve clarity and ensure correctness, the columns were renamed:

ALTER TABLE "1R"
RENAME COLUMN entry_time TO exit_tm;
The same correction was applied to all three tables.

4.2 Trade Duration Validation
Trade entry and exit times were provided without seconds. As a result, many trades had identical entry and exit timestamps.
Since trades with zero duration cannot be reliably evaluated, these records were excluded from the analysis.
A new metric, Time_in_trade, was calculated and only trades with a duration greater than 1 second were retained for further analysis.

4.3 Initial Performance Evaluation
After cleaning the data, the total realized result (total_r_realized) was calculated for each scenario:
	•	1R: −1R
	•	2R: +7R
	•	3R: −14R
At this stage, the strategy was profitable only under the 2R scenario.
Win rates were also calculated:
	•	1R: 48%
	•	2R: 39%
	•	3R: 16%
Considering both win rate and risk-to-reward ratio, only the 2R scenario demonstrated a positive mathematical expectancy.

4.4 Date Format Normalization and Data Merge
Different date formats were used in the 1R and 2R tables. To enable further analysis, all dates were converted to a unified format, after which the datasets were merged.

4.5 Identification of Missing Trades
During the analysis of the merged dataset, it was discovered that on some trading days only a single ticker appeared. This is inconsistent with the strategy logic, as all scenarios share identical entry conditions.
Further investigation showed that several trades were present only in the 2R dataset but missing from 1R, indicating an error in the original data.
These trades (6 total, 4 of them profitable) were added back to the 1R dataset, with their results recalculated according to the 1R risk-to-reward rules.
After this correction:
	•	The total result for 1R became +1R
	•	The win rate increased to 51%
However, even after the correction, the 1R scenario remains marginal and loses viability once transaction costs are considered.

## 5. Analysis and Visualization
After completing data cleaning and validation, the following analyses were performed:
	•	Cumulative PnL clearly demonstrated the poor performance of the 3R scenario
	•	The 1R scenario showed unstable results and high sensitivity to data quality
	•	A Profit/Loss zone was constructed to evaluate strategy viability based on risk-to-reward ratio and win rate
	•	Win rates were calculated directly from actual trade outcomes
	•	The 2R scenario emerged as the only robust and consistently profitable configuration
For the 2R scenario, a Winner/Loser distribution was visualized to identify patterns and confirm the stability of the results.

## 6. Conclusions
	•	The 2R scenario is the only configuration with a stable, positive mathematical expectancy
	•	The 3R scenario is consistently unprofitable and statistically unstable
	•	The 1R scenario is marginal and highly sensitive to data quality and transaction costs
	•	Data accuracy and validation are critical to reliable trading strategy evaluation

## 7. Future Improvements
	•	Incorporate transaction costs and slippage
	•	Analyze drawdowns and risk metrics
	•	Test the strategy across different market regimes
	•	Automate data quality validation checks

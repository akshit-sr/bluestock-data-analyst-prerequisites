# Bluestock Fintech — Data Analyst Prerequisite Program

Assignments completed by Akshit.

## Week 1
Excel, SQL, Python EDA and Power BI on the Superstore sales dataset.

| File | Description |
|---|---|
| `Akshit_Week_1.xlsx` | Excel analysis |
| `sql/schema.sql`, `sql/queries.sql` | Table schema and analysis queries |
| `Python_Data_Analysis.ipynb` | Python EDA notebook |
| `EDA_Report.docx` | EDA report |
| `Akshit_Week_1.pbix` | Power BI dashboard |
| `data/` | Raw and cleaned sales data |

## Week 2
Financial domain and software ecosystem.

| File | Description |
|---|---|
| `Akshit_Week_2.docx` | Full submission: stock market summary, Infosys financial statement analysis, API assignment, GitHub, architecture diagram, Zerodha FinTech report |
| `api_to_csv.py` | Calls the Yahoo Finance Chart API and converts the JSON response to CSV |
| `api_response_sample.json` | Raw API response |
| `infy_prices.csv` | Extracted daily Infosys (NSE) prices |
| `diagram.py`, `data_flow_diagram.png` | Data flow diagram: user action → database → analytics dashboard |

## Running

```bash
# Week 1 notebook
cd Week-1 && uv sync && uv run jupyter notebook

# Week 2 API extraction (standard library only)
cd Week-2 && uv run --no-project python api_to_csv.py
```

*For learning purposes only; not investment advice.*

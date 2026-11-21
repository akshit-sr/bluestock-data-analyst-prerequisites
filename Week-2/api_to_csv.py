"""Call a public stock-price API, inspect the JSON, and save it as CSV."""
import csv
import json
import sys
import urllib.request
from datetime import datetime, timezone

URL = "https://query1.finance.yahoo.com/v8/finance/chart/{symbol}?range={range}&interval=1d"


def fetch(symbol="INFY.NS", range_="3mo"):
    req = urllib.request.Request(URL.format(symbol=symbol, range=range_), headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=20) as r:
        return json.load(r)


def to_rows(data):
    res = data["chart"]["result"][0]
    q = res["indicators"]["quote"][0]
    rows = []
    for i, ts in enumerate(res["timestamp"]):
        if q["close"][i] is None:  # holidays/partial days come back as nulls
            continue
        rows.append({
            "date": datetime.fromtimestamp(ts, timezone.utc).strftime("%Y-%m-%d"),
            "open": round(q["open"][i], 2),
            "high": round(q["high"][i], 2),
            "low": round(q["low"][i], 2),
            "close": round(q["close"][i], 2),
            "volume": q["volume"][i],
        })
    return rows


def save(rows, path):
    with open(path, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=rows[0].keys())
        w.writeheader()
        w.writerows(rows)


def _selftest():
    sample = {"chart": {"result": [{"timestamp": [1700000000, 1700086400],
              "indicators": {"quote": [{"open": [1.111, None], "high": [2, None], "low": [1, None],
                                        "close": [1.5, None], "volume": [100, None]}]}}]}}
    rows = to_rows(sample)
    assert len(rows) == 1 and rows[0]["open"] == 1.11 and rows[0]["date"] == "2023-11-14", rows


if __name__ == "__main__":
    _selftest()
    symbol = sys.argv[1] if len(sys.argv) > 1 else "INFY.NS"
    data = fetch(symbol)
    with open("api_response_sample.json", "w") as f:
        json.dump(data, f, indent=2)
    meta = data["chart"]["result"][0]["meta"]
    print("Top-level keys:", list(data["chart"]["result"][0].keys()))
    print("Symbol:", meta["symbol"], "| Currency:", meta["currency"], "| Exchange:", meta["exchangeName"])
    rows = to_rows(data)
    save(rows, f"{symbol.split('.')[0].lower()}_prices.csv")
    closes = [r["close"] for r in rows]
    print(f"Rows: {len(rows)} | First close: {closes[0]} | Last close: {closes[-1]} | "
          f"Change: {(closes[-1] / closes[0] - 1) * 100:.2f}% | Avg volume: {sum(r['volume'] for r in rows) // len(rows):,}")

import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch

steps = [
    ("1. User action", "Clicks 'Buy' in web/mobile app\n(Frontend: React / app UI)", "white"),
    ("2. API request", "HTTPS POST /api/orders\nJSON body + auth token (JWT)", "white"),
    ("3. Backend server", "Validates auth & input, business\nlogic, error handling, logging", "white"),
    ("4. Database (OLTP)", "PostgreSQL: users, orders, trades\n(INSERT order row)", "white"),
    ("5. Data pipeline (ETL)", "Scheduled job: Extract -> clean ->\ntransform -> Load (e.g. hourly)", "white"),
    ("6. Data warehouse", "Analytics tables / star schema\n(fact_orders, dim_users)", "white"),
    ("7. Analytics dashboard", "Power BI / Tableau: orders/day,\nactive users, revenue KPIs", "white"),
]

fig, ax = plt.subplots(figsize=(8, 10.5))
ax.set_xlim(0, 10); ax.set_ylim(0, len(steps) * 1.5); ax.axis("off")
for i, (title, body, color) in enumerate(steps):
    y = (len(steps) - 1 - i) * 1.5 + 0.2
    ax.add_patch(FancyBboxPatch((1, y), 6, 1.05, boxstyle="round,pad=0.05", fc="white", ec="black", lw=1.2))
    ax.text(4, y + 0.75, title, ha="center", fontsize=12, weight="bold", color="black")
    ax.text(4, y + 0.3, body, ha="center", va="center", fontsize=9.5, color="black")
    if i < len(steps) - 1:
        ax.annotate("", xy=(4, y - 0.2), xytext=(4, y + 0.0), arrowprops=dict(arrowstyle="-|>", color="black", lw=1.6))

# side annotations
ax.text(7.4, 9.5, "CLIENT", fontsize=10, weight="bold", color="black")
ax.text(7.4, 6.85, "SERVER\n(Backend)", fontsize=10, weight="bold", color="black")
ax.text(7.4, 2.7, "ANALYTICS\nSIDE", fontsize=10, weight="bold", color="black")
ax.text(7.4, 5.0, "Logs -> monitoring\n(errors, latency)", fontsize=8.5, style="italic", color="black")
ax.text(7.4, 6.15, "Response: 201 Created\nor 4xx/5xx error JSON\n-> back to client", fontsize=8.5, style="italic", color="black")
ax.set_title("Data Flow: User Action -> Database -> Analytics Dashboard", fontsize=13, weight="bold")
plt.tight_layout()
plt.savefig("data_flow_diagram.png", dpi=150)

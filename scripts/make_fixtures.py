"""Build a tiny synthetic dataset with the same schema as Olist, for CI and fast local runs.

Deterministic. Run: uv run python scripts/make_fixtures.py
Then:           uv run dbt build --vars '{olist_data_dir: tests/fixtures/olist}'
"""

import csv
import random
from datetime import datetime, timedelta
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "tests" / "fixtures" / "olist"
rng = random.Random(7)
STATES = ["SP", "RJ", "MG", "PR", "BA"]
CATEGORIES = ["beleza_saude", "informatica_acessorios", "cama_mesa_banho", "esporte_lazer"]
TRANSLATION = {
    "beleza_saude": "health_beauty",
    "informatica_acessorios": "computers_accessories",
    "cama_mesa_banho": "bed_bath_table",
    "esporte_lazer": "sports_leisure",
}


def write(name: str, header: list[str], rows: list[list]) -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    with (OUT / name).open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f, lineterminator="\n", quoting=csv.QUOTE_ALL)
        w.writerow(header)
        w.writerows(rows)


def ts(d: datetime | None) -> str:
    return d.strftime("%Y-%m-%d %H:%M:%S") if d else ""


write(
    "product_category_name_translation.csv",
    ["product_category_name", "product_category_name_english"],
    [[k, v] for k, v in TRANSLATION.items()],
)

products = [[f"prod{i:03d}", rng.choice(CATEGORIES), 40, 200, 2, 500, 20, 10, 15] for i in range(1, 21)]
products[0][1] = ""  # Olist has products without a category
write(
    "olist_products_dataset.csv",
    [
        "product_id",
        "product_category_name",
        "product_name_lenght",
        "product_description_lenght",
        "product_photos_qty",
        "product_weight_g",
        "product_length_cm",
        "product_height_cm",
        "product_width_cm",
    ],
    products,
)

# one person can have several customer_id (Olist creates one per order)
uniques = [f"person{i:03d}" for i in range(1, 41)]
customers, orders, items, payments = [], [], [], []
start = datetime(2017, 1, 1)
for n in range(1, 101):
    cid, oid = f"cust{n:04d}", f"order{n:04d}"
    person = rng.choice(uniques)
    customers.append([cid, person, f"{rng.randint(1000, 99999)}", "sao paulo", rng.choice(STATES)])
    status = rng.choices(["delivered", "shipped", "canceled", "unavailable", "invoiced"], [80, 6, 6, 4, 4])[0]
    bought = start + timedelta(days=rng.randint(0, 540), hours=rng.randint(0, 23))
    delivered = bought + timedelta(days=rng.randint(3, 25)) if status == "delivered" else None
    estimated = bought + timedelta(days=rng.randint(10, 20))
    orders.append(
        [
            oid,
            cid,
            status,
            ts(bought),
            ts(bought + timedelta(hours=2)),
            ts(bought + timedelta(days=2)) if status in ("delivered", "shipped") else "",
            ts(delivered),
            ts(estimated),
        ]
    )
    if status in ("canceled", "unavailable") and rng.random() < 0.7:
        continue  # real data has orders that never got items or payments
    total = 0.0
    for k in range(1, rng.randint(1, 3) + 1):
        price, freight = round(rng.uniform(10, 300), 2), round(rng.uniform(5, 40), 2)
        total += price + freight
        items.append([oid, k, rng.choice(products)[0], "seller01", ts(bought + timedelta(days=3)), price, freight])
    parts = rng.choice([1, 1, 2])
    for seq in range(1, parts + 1):
        value = round(total / parts, 2)
        payments.append([oid, seq, rng.choice(["credit_card", "boleto", "voucher"]), rng.randint(1, 6), value])

write(
    "olist_customers_dataset.csv",
    ["customer_id", "customer_unique_id", "customer_zip_code_prefix", "customer_city", "customer_state"],
    customers,
)
write(
    "olist_orders_dataset.csv",
    [
        "order_id",
        "customer_id",
        "order_status",
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ],
    orders,
)
write(
    "olist_order_items_dataset.csv",
    ["order_id", "order_item_id", "product_id", "seller_id", "shipping_limit_date", "price", "freight_value"],
    items,
)
write(
    "olist_order_payments_dataset.csv",
    ["order_id", "payment_sequential", "payment_type", "payment_installments", "payment_value"],
    payments,
)
print(f"customers={len(customers)} orders={len(orders)} items={len(items)} payments={len(payments)}")

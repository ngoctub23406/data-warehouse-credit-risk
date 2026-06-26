import duckdb
import os

token = os.environ.get("MOTHERDUCK_TOKEN")
conn = duckdb.connect(f"md:shopping_db?token={token}")

print("=== KIỂM TRA TRÊN MOTHERDUCK ===")
bronze = conn.execute("SELECT COUNT(*) FROM bronze.raw_sessions").fetchone()[0]
print(f"Bronze: {bronze} dòng")

silver = conn.execute("SELECT COUNT(*) FROM main.stg_sessions").fetchone()[0]
print(f"Silver: {silver} dòng")

gold = conn.execute("SELECT COUNT(*) FROM main.fct_sessions").fetchone()[0]
print(f"Gold: {gold} dòng")

conn.close()
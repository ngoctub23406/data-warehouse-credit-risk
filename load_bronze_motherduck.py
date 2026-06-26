import duckdb
from datasets import load_dataset
import os

TOKEN = os.environ.get("MOTHERDUCK_TOKEN")
if not TOKEN:
    TOKEN = input("Nhập MotherDuck token (có quyền ghi): ")

# Bước 1: Kết nối đến MotherDuck mà không chỉ định database (dùng 'md:')
# Sau đó tạo database nếu chưa tồn tại
conn = duckdb.connect(f"md:?token={TOKEN}")

# Tạo database 'shopping_db' nếu chưa có
conn.execute("CREATE DATABASE IF NOT EXISTS shopping_db")
print("Database 'shopping_db' đã sẵn sàng.")

# Bước 2: Kết nối lại đến đúng database 'shopping_db'
conn = duckdb.connect(f"md:shopping_db?token={TOKEN}")

# Tạo schema bronze
conn.execute("CREATE SCHEMA IF NOT EXISTS bronze")
print("Schema bronze đã sẵn sàng.")

# Tải dữ liệu từ Hugging Face
print("Đang tải dữ liệu...")
dataset = load_dataset("jlh/uci-shopper", split="train")
df = dataset.to_pandas()
print(f"Đã tải {len(df)} dòng.")

# Ghi vào bảng bronze.raw_sessions
conn.execute("CREATE OR REPLACE TABLE bronze.raw_sessions AS SELECT * FROM df")
print("Đã lưu dữ liệu vào bronze.raw_sessions trên MotherDuck.")

# Kiểm tra
count = conn.execute("SELECT COUNT(*) FROM bronze.raw_sessions").fetchone()[0]
print(f"Xác nhận: {count} dòng.")

conn.close()
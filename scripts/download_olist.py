"""Download the Olist dataset from Kaggle into data/olist (git-ignored, licence: CC BY-NC-SA).

Run: uv run python scripts/download_olist.py
Needs a Kaggle login on your machine (never commit tokens).
"""

import kagglehub

path = kagglehub.dataset_download("olistbr/brazilian-ecommerce", output_dir="data/olist")
print("Dataset files in:", path)

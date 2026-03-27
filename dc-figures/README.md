# DC Comics Action Figures — MySQL Database

A filterable MySQL database of 60+ popular DC Comics action figures with a Python CLI query tool.

## Setup

```bash
# 1. Import the schema + seed data
mysql -u root -p < schema_v2.sql

# 2. Install Python connector
pip install mysql-connector-python

# 3. Set connection env vars (optional — defaults to root@localhost/dc_figures)
export DB_USER=root
export DB_PASSWORD=yourpassword
export DB_NAME=dc_figures
```

## Query examples

```bash
# Show all figures (default columns)
python dc_figures.py

# Filter by character
python dc_figures.py --character Batman
python dc_figures.py --character "Wonder Woman"

# Filter by universe
python dc_figures.py --universe Rebirth
python dc_figures.py --universe "Dark Multiverse"

# Filter by rarity
python dc_figures.py --rarity "Ultra Rare"
python dc_figures.py --rarity Common --in-stock

# Price range
python dc_figures.py --max-price 25
python dc_figures.py --min-price 40 --sort price_usd --desc

# Full-text search
python dc_figures.py --search "trident"
python dc_figures.py --search "McFarlane" --rarity Rare

# Custom columns
python dc_figures.py --cols name character year price_usd rarity in_stock

# Summary stats
python dc_figures.py --stats

# Combine filters
python dc_figures.py --universe Rebirth --in-stock --max-price 25 --sort price_usd
```

## Schema

| Column | Type | Description |
|---|---|---|
| `id` | INT | Primary key |
| `name` | VARCHAR(100) | Full figure name |
| `character` | VARCHAR(100) | DC character |
| `series` | VARCHAR(100) | Product line |
| `manufacturer` | VARCHAR(80) | e.g. McFarlane Toys |
| `year` | YEAR | Release year |
| `scale` | VARCHAR(20) | Figure size (7-inch, etc.) |
| `universe` | ENUM | New 52, Rebirth, Classic, etc. |
| `rarity` | ENUM | Common → Ultra Rare |
| `price_usd` | DECIMAL | MSRP in USD |
| `in_stock` | BOOLEAN | Availability |
| `accessories` | TEXT | Included items |

## Figures included

60 figures covering Batman, Superman, Wonder Woman, The Flash, Green Lantern, Aquaman, Joker, Harley Quinn, Darkseid, Lex Luthor, Deathstroke, and more — spanning McFarlane Toys, DC Collectibles, and Mego lines from 2012–2023.

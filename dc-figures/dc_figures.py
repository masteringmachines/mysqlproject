#!/usr/bin/env python3
"""
dc_figures.py — Query & filter the DC Comics Action Figures database.

Usage examples
--------------
  python dc_figures.py                          # show all figures
  python dc_figures.py --character Batman       # filter by character
  python dc_figures.py --rarity "Ultra Rare"    # filter by rarity
  python dc_figures.py --universe Rebirth       # filter by universe
  python dc_figures.py --max-price 25           # under $25
  python dc_figures.py --in-stock               # in stock only
  python dc_figures.py --sort price_usd         # sort by column
  python dc_figures.py --cols name year price_usd rarity
  python dc_figures.py --stats                  # summary stats
"""

import argparse
import os
import sys
from typing import Optional

try:
    import mysql.connector
except ImportError:
    print("Install mysql-connector-python:  pip install mysql-connector-python")
    sys.exit(1)

# ── Available columns ──────────────────────────────────────────────────────────
ALL_COLS = ["id","name","character","series","manufacturer","year","era",
            "scale","universe","rarity","price_usd","in_stock","accessories"]

DEFAULT_COLS = ["id","name","character","era","year","rarity","price_usd","in_stock"]

COL_WIDTHS = {
    "id":12,"name":40,"character":22,"series":22,"manufacturer":20,
    "year":6,"scale":10,"universe":16,"rarity":12,
    "price_usd":10,"in_stock":9,"accessories":50,
}

# ── DB connection ──────────────────────────────────────────────────────────────
def get_conn():
    return mysql.connector.connect(
        host    = os.getenv("DB_HOST",     "localhost"),
        port    = int(os.getenv("DB_PORT", "3306")),
        user    = os.getenv("DB_USER",     "root"),
        password= os.getenv("DB_PASSWORD", ""),
        database= os.getenv("DB_NAME",     "dc_figures"),
    )

# ── Query builder ──────────────────────────────────────────────────────────────
def build_query(args) -> tuple[str, list]:
    where, params = [], []

    if args.character:
        where.append("character LIKE %s");  params.append(f"%{args.character}%")
    if args.era:
        where.append("era LIKE %s");        params.append(f"%{args.era}%")
    if args.series:
        where.append("series LIKE %s");     params.append(f"%{args.series}%")
    if args.manufacturer:
        where.append("manufacturer LIKE %s"); params.append(f"%{args.manufacturer}%")
    if args.universe:
        where.append("universe = %s");      params.append(args.universe)
    if args.rarity:
        where.append("rarity = %s");        params.append(args.rarity)
    if args.year:
        where.append("year = %s");          params.append(args.year)
    if args.min_price is not None:
        where.append("price_usd >= %s");    params.append(args.min_price)
    if args.max_price is not None:
        where.append("price_usd <= %s");    params.append(args.max_price)
    if args.in_stock:
        where.append("in_stock = TRUE")
    if args.search:
        where.append("(name LIKE %s OR character LIKE %s OR accessories LIKE %s)")
        params.extend([f"%{args.search}%"] * 3)

    sql = "SELECT * FROM figures"
    if where:
        sql += " WHERE " + " AND ".join(where)

    valid_sorts = ALL_COLS
    sort = args.sort if args.sort in valid_sorts else "id"
    sql += f" ORDER BY {sort} {'DESC' if args.desc else 'ASC'}"

    if args.limit:
        sql += f" LIMIT {int(args.limit)}"

    return sql, params

# ── Display ────────────────────────────────────────────────────────────────────
def print_table(rows: list[dict], cols: list[str]):
    if not rows:
        print("\n  No results found.\n")
        return

    widths = {c: max(COL_WIDTHS.get(c, 16), len(c)) for c in cols}

    sep  = "+" + "+".join("-" * (w + 2) for w in widths.values()) + "+"
    hdr  = "|" + "|".join(f" {c.upper().replace('_',' '):<{w}} " for c, w in widths.items()) + "|"

    print(f"\n  {len(rows)} result(s)\n")
    print(sep); print(hdr); print(sep)

    for row in rows:
        cells = []
        for col in cols:
            val = row.get(col, "")
            if col == "in_stock":
                val = "✓" if val else "✗"
            elif col == "price_usd":
                val = f"${float(val):.2f}"
            else:
                val = str(val) if val is not None else ""
            w = widths[col]
            cells.append(f" {val[:w]:<{w}} ")
        print("|" + "|".join(cells) + "|")

    print(sep)

def print_stats(conn):
    cur = conn.cursor(dictionary=True)
    queries = {
        "Total figures":        "SELECT COUNT(*) v FROM figures",
        "In stock":             "SELECT COUNT(*) v FROM figures WHERE in_stock=1",
        "Avg price":            "SELECT CONCAT('$', ROUND(AVG(price_usd),2)) v FROM figures",
        "Most expensive":       "SELECT CONCAT(name,' ($',price_usd,')') v FROM figures ORDER BY price_usd DESC LIMIT 1",
        "Most common character":"SELECT character v FROM figures GROUP BY character ORDER BY COUNT(*) DESC LIMIT 1",
    }
    print("\n  ── STATS ──────────────────────────────")
    for label, sql in queries.items():
        cur.execute(sql)
        val = cur.fetchone()["v"]
        print(f"  {label:<25} {val}")
    print()

    cur.execute("SELECT rarity, COUNT(*) n, ROUND(AVG(price_usd),2) avg FROM figures GROUP BY rarity ORDER BY FIELD(rarity,'Common','Uncommon','Rare','Ultra Rare')")
    print(f"  {'Rarity':<14} {'Count':>6} {'Avg Price':>10}")
    print("  " + "-" * 32)
    for r in cur.fetchall():
        print(f"  {r['rarity']:<14} {r['n']:>6} {'$'+str(r['avg']):>10}")
    print()
    cur.close()

# ── CLI ────────────────────────────────────────────────────────────────────────
def main():
    p = argparse.ArgumentParser(description="Query DC Comics Action Figures DB")
    p.add_argument("--character",    help="Filter by character name (partial match)")
    p.add_argument("--era",          help="Filter by era (e.g. 'Mego Era', 'Super Powers Era')")
    p.add_argument("--series",       help="Filter by series (partial match)")
    p.add_argument("--manufacturer", help="Filter by manufacturer")
    p.add_argument("--universe",     choices=["New 52","Rebirth","Classic","Dark Multiverse","Elseworlds","Movie"])
    p.add_argument("--rarity",       choices=["Common","Uncommon","Rare","Ultra Rare"])
    p.add_argument("--year",         type=int,   help="Filter by release year")
    p.add_argument("--min-price",    type=float, dest="min_price")
    p.add_argument("--max-price",    type=float, dest="max_price")
    p.add_argument("--in-stock",     action="store_true", dest="in_stock")
    p.add_argument("--search",       help="Full-text search across name, character, accessories")
    p.add_argument("--sort",         default="id", choices=ALL_COLS, help="Sort column")
    p.add_argument("--desc",         action="store_true", help="Sort descending")
    p.add_argument("--limit",        type=int, help="Max rows to return")
    p.add_argument("--cols",         nargs="+", default=DEFAULT_COLS,
                   choices=ALL_COLS, metavar="COL", help=f"Columns to display: {ALL_COLS}")
    p.add_argument("--stats",        action="store_true", help="Show summary statistics")
    args = p.parse_args()

    try:
        conn = get_conn()
    except Exception as e:
        print(f"\n  DB connection failed: {e}")
        print("  Set env vars: DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME")
        sys.exit(1)

    if args.stats:
        print_stats(conn)
        conn.close()
        return

    sql, params = build_query(args)
    cur = conn.cursor(dictionary=True)
    cur.execute(sql, params)
    rows = cur.fetchall()
    cur.close()
    conn.close()

    print_table(rows, args.cols)

if __name__ == "__main__":
    main()

import json
from playwright.sync_api import Page
from pathlib import Path
import pandas as pd
from step_1_1 import OUT_DIR
from step_1_2 import run_playWright
from step_1_3 import OUT_1_3, parse_table_kospi, goto_market_cap
from step_2_1 import fetch_total_page

OUT_2_2 = OUT_DIR / f"{Path(__file__).stem}.json"


def get_total_parse(page: Page, total_page: int):
    body_li = []
    header = []
    for i in range(1, total_page+1):
        page.goto(f"https://finance.naver.com/sise/sise_market_sum.naver?&page={i}")
        page.wait_for_load_state("networkidle")
        header, body = parse_table_kospi(page)
        body_li += body
    return header, body_li

if __name__ == "__main__":
    play, browser, page = run_playWright(slow_mo=1000)
    goto_market_cap(page)
    total_page = fetch_total_page(page)
    header, body_li = get_total_parse(page, total_page)

    dumped = json.dumps(dict(header=header, body=body_li), ensure_ascii=False, indent=2)
    OUT_2_2.write_text(dumped, encoding="utf-8")
    browser.close()
    play.stop()
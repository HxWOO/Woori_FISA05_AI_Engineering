import json
from pathlib import Path
from playwright.sync_api import Page
from set_path import OUT_DIR
from play_wright import run_playWright

OUT_JOB_REC = OUT_DIR / f"{Path(__file__).stem}.json"

def goto_recruit_cap(page:Page):
    page.goto("https://www.saramin.co.kr/zf_user/")  # 사람인 
    page.get_by_role("link", name="채용정보", exact=True).click()
    page.get_by_role("link", name="직업별").click()
    page.get_by_role("button", name="기획·전략").click()


def parse_recruit_count_saramin(page:Page) -> list[str]:
    job = page.locator("body").locator("div > div > div > div ") \
        .locator("form > fieldset") \
        .locator("div > div > div > div ") \
        .locator("div > div > div > div > div ") \
        .locator("ul > li > button > span")
    # 선택한 (직종, 총 공고 수) 리스트를 받음
    job.all()
    body = [tr.all_inner_texts() for tr in job.all()]

    return body

if __name__ == "__main__":
    play, browser, page = run_playWright(slow_mo=1000)  # playwright 실행
    goto_recruit_cap(page)  # 직업별 페이지 이동
    body = parse_recruit_count_saramin(page)  # 코스피 수집
    dumped = json.dumps(dict(body=body),
                        ensure_ascii=False, indent=2)
    OUT_JOB_REC.write_text(dumped, encoding="utf-8")  # JSON으로 저장
    browser.close()
    play.stop()

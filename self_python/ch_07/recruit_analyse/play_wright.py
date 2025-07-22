from playwright.sync_api import Browser, Page, Playwright, sync_playwright

def run_playWright(slow_mo: float = None) -> tuple[Playwright, Browser, Page]:
    play: Playwright = sync_playwright().start()  # PlayWright 객체 생성
    browser: Browser = play.chromium.launch(  # Browser 객체 생성
        args=["--start-maximized"],  # 웹 브라우저 최대화
        headless=False,  # 헤드리스 모드 사용 x
        slow_mo=slow_mo,  # 자동화 처리 지연 시간
    )
    page: Page = browser.new_page(no_viewport=True)  # Page 객체 생성
    return play, browser, page


if __name__ == "__main__":
    play, browser, page = run_playWright()
    page.goto("https://www.saramin.co.kr/zf_user/")  # 사람인
    page.pause()
    browser.close()
    play.stop()
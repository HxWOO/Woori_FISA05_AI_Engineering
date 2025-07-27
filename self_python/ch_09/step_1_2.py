from dotenv import load_dotenv
import requests
import os
# 통계표 코드: 722Y001, 주기: 년A, 반년D, 월M, 분기Q
# 통계항목 코드: 0101000, 단위: 연%

load_dotenv()  # .env 로드
ECOS_API_KEY = os.getenv("ECOS_API_KEY")

api_url = f"https://ecos.bok.or.kr/api/StatisticSearch/{ECOS_API_KEY}/json/kr/1/10/722Y001/A/2020/2025/0101000/?/?/?"
print(api_url)
resp = requests.get(api_url)
print(resp.json())
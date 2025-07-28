import requests
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.font_manager as fm
from dotenv import load_dotenv
import os

# 한글 폰트 설정 (Windows 기준)
font_path = 'C:/Windows/Fonts/malgun.ttf'
font_name = fm.FontProperties(fname=font_path).get_name()
plt.rc('font', family=font_name)
plt.rcParams['axes.unicode_minus'] = False # 마이너스 부호 깨짐 방지

# ECOS API 키 설정
load_dotenv()
ECOS_API_KEY = os.getenv("ECOS_API_KEY")

def get_ecos_data(stat_code, start_date, end_date, stat_item_code, freq='M'):
    """ECOS API를 통해 경제 지표 데이터를 가져오는 함수"""
    url = f"https://ecos.bok.or.kr/api/StatisticSearch/{ECOS_API_KEY}/json/kr/1/1000/{stat_code}/{freq}/{start_date}/{end_date}/{stat_item_code}"
    response = requests.get(url)
    response.raise_for_status()  # HTTP 오류 발생 시 예외 발생
    data = response.json()
    
    if 'StatisticSearch' in data and 'row' in data['StatisticSearch']:
        df = pd.DataFrame(data['StatisticSearch']['row'])
        df['TIME'] = pd.to_datetime(df['TIME'], format='%Y%m')
        df.set_index('TIME', inplace=True)
        df['DATA_VALUE'] = pd.to_numeric(df['DATA_VALUE'])
        return df[['DATA_VALUE']]
    else:
        print(f"데이터를 가져오지 못했습니다: {data}")
        return pd.DataFrame()

# 데이터 수집 기간 설정
start_date = "201001"
end_date = pd.Timestamp.now().strftime('%Y%m')

# 소비자물가지수(CPI)와 생산자물가지수(PPI) 코드
cpi_code = "901Y009" # 소비자물가지수(총지수, 2020=100) 0 , 2020=100
ppi_code = "404Y014" # 생산자물가지수(총지수, 2015=100)  *AA , 2020=100

# 데이터 수집
cpi_df = get_ecos_data(cpi_code, start_date, end_date, '0')
ppi_df = get_ecos_data(ppi_code, start_date, end_date, '*AA')

if not cpi_df.empty and not ppi_df.empty:
    # 데이터 전처리 및 파생 변수 생성
    cpi_df.rename(columns={'DATA_VALUE': 'CPI'}, inplace=True)
    ppi_df.rename(columns={'DATA_VALUE': 'PPI'}, inplace=True)

    df = pd.concat([cpi_df, ppi_df], axis=1)
    df.dropna(inplace=True)

    df['CPI_YoY'] = df['CPI'].pct_change(12) * 100
    df['PPI_YoY'] = df['PPI'].pct_change(12) * 100

    df['Inflation_Gap'] = df['CPI_YoY'] - df['PPI_YoY']

    df.dropna(inplace=True)

    # 시각화
    plt.style.use('ggplot')
    fig, ax1 = plt.subplots(figsize=(14, 8))

    ax1.plot(df.index, df['CPI_YoY'], color='blue', label='소비자물가지수(CPI) 상승률')
    ax1.plot(df.index, df['PPI_YoY'], color='green', label='생산자물가지수(PPI) 상승률')
    ax1.set_xlabel('연도')
    ax1.set_ylabel('전년 동월 대비 상승률 (%)', color='black')
    ax1.tick_params(axis='y', labelcolor='black')
    ax1.legend(loc='upper left')

    ax2 = ax1.twinx()
    ax2.bar(df.index, df['Inflation_Gap'], color='gray', alpha=0.3, width=20, label='인플레이션 갭 (CPI - PPI)')
    ax2.set_ylabel('인플레이션 갭 (%)', color='gray')
    ax2.tick_params(axis='y', labelcolor='gray')
    ax2.legend(loc='upper right')

    plt.title('소비자물가지수(CPI)와 생산자물가지수(PPI) 상승률 및 인플레이션 갭')
    fig.tight_layout()
    fig.savefig("./OUTPUT.png")
    plt.show()
else:
    print("데이터를 가져오지 못했습니다. API 키와 통계 코드를 확인해주세요.")

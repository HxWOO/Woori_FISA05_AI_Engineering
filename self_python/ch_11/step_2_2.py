import pandas as pd
from datakart import Datagokr
from step_1_1 import DATAGO_KEY

datagokr = Datagokr(DATAGO_KEY)
resp = datagokr.apt_trade("11680", "202312")
df_raw = pd.DataFrame(resp)
df_filter = df_raw.filter(["sggCd", "dealYear", "dealMonth", "dealingGbn", "umdNm", "aptNm", "excluUseAr", "dealAmount", "cdealDay"])
df_filter.columns = ["지역코드", "계약년도", "계약월", "거래유형", "법정동", "단지명", "전용면적", "거래금액", "해제사유발생일"]
df_filter.head(3)  # 첫 3개 행 데이터 출력

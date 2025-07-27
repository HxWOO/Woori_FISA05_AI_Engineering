from pathlib import Path
import pandas as pd
from datakart import Ecos
from step_1_1 import OUT_DIR
from dotenv import load_dotenv
import os

# 통계표 코드: 722Y001, 주기: 년A, 반년D, 월M, 분기Q
# 통계항목 코드: 0101000, 단위: 연%

load_dotenv()
ECOS_API_KEY = os.getenv("ECOS_API_KEY")
ecos = Ecos(ECOS_API_KEY)
resp = ecos.stat_search(
    stat_code= "722Y001",
    freq= "M",
    item_code1= "0101000",
    start= "202301",
    end= "202506",
)

df_raw = pd.DataFrame(resp)
df_raw.to_csv(OUT_DIR/f"{Path(__file__).stem}.csv", index=False)
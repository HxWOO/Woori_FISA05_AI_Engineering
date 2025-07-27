from pathlib import Path
import pandas as pd
from datakart import Ecos
from step_1_1 import OUT_DIR, ECOS_API_KEY

OUT_2_2 = OUT_DIR / f"{Path(__file__).stem}.xlsx"

def ecos_to_xlsx():
    CODE_LIST = [  # ["지표명", "통계코드", "주기", "통계항목코드", 시작일, 종료일]
        ["기준금리", "722Y001", "D", "0101000", "20230101", "20250701" ],
        ["국고채", "817Y002", "D", "010200000", "20230101", "20250701"],  # 국고채 3년
        ["회사채", "817Y002", "D", "010300000", "20230101", "20250701"],  # 회사채 3년 AA-
        ["코스피지수", "802Y001", "D", "0001000", "20230101", "20250701"],
        ["원달러환율", "731Y001", "D", "0000001", "20230101", "20250701"],  # 원달러(시가)
    ]

    with pd.ExcelWriter(OUT_2_2) as writer:  # ExcelWriter 객체 생성
        ecos = Ecos(ECOS_API_KEY)
        for name, stat_code, freq, item_code1, start, end in CODE_LIST:
            resp = ecos.stat_search(  # stat_search = 통계 조회 API
                stat_code=stat_code,
                freq=freq,
                item_code1=item_code1,
                start=start,
                end=end
            )
            df_raw = pd.DataFrame(resp)
            df_raw.to_excel(writer, sheet_name=name, index=False)

if __name__ == "__main__":
    ecos_to_xlsx()
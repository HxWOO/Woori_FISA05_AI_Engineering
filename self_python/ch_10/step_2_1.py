from pathlib import Path
import pandas as pd
from datakart import Ecos
from step_1_1 import OUT_DIR, FSS_API_KEY, ECOS_API_KEY

OUT_2_1 = OUT_DIR / f"{Path(__file__).stem}.xlsx"

def indicators_to_xlsx():
    CODE_LIST = [
        ["산금채", "721Y001", "M", "6050000", 100],
        ["정기예금", "121Y002", "M", "BEABAA2118", 100],
        ["정기적금", "121Y002", "M", "BEABAA2112", 100],
        ["일반신용대출", "121Y006", "M", "BECBLA03051", 100],
        ["주택담보대출", "121Y006", "M", "BECBLA0302", 100],
    ]

    with pd.ExcelWriter(OUT_2_1) as writer:
        ecos = Ecos(ECOS_API_KEY)
        for name, stat_code, freq, item_code1, limit in CODE_LIST:
            resp = ecos.stat_search(
                stat_code=stat_code,
                freq=freq,
                item_code1=item_code1,
                limit=limit,
            )
            df_raw = pd.DataFrame(resp)
            df_raw.to_excel(writer, sheet_name=name, index=False)

if __name__ == "__main__":
    indicators_to_xlsx()
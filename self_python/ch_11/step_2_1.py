from pathlib import Path

import pandas as pd
from datakart import Datagokr

from step_1_1 import OUT_DIR, DATAGO_KEY

OUT_2_1 = OUT_DIR / f"{Path(__file__).stem}.csv"


def sido_sgg_to_csv(region: str = None):
    datago = Datagokr(DATAGO_KEY) 
    resp = datago.lawd_code(region)
    df_raw = pd.DataFrame(resp) 
    df_raw["sido_sgg"] = df_raw["sido_cd"] + df_raw["sgg_cd"]

    f_no_sgg = df_raw["sgg_cd"] == "000"
    f_no_umd = df_raw["umd_cd"] == "000"
    f_no_ri = df_raw["ri_cd"] == "00"
    f_only_sgg = (~f_no_sgg) & (f_no_umd) & (f_no_ri)
    df_sliced = df_raw.loc[f_only_sgg]

    df_filter = df_sliced.filter(["sido_sgg", "locatadd_nm"])
    df_sort = df_filter.sort_values("locatadd_nm")
    df_result = df_sort.reset_index(drop=True)
    df_result.to_csv(OUT_2_1, index=False) 


if __name__ == "__main__":
    region = "서울특별시"
    sido_sgg_to_csv(region)

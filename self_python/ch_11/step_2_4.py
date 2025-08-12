from pathlib import Path

import pandas as pd

from step_1_1 import OUT_DIR
from step_2_1 import OUT_2_1
from step_2_3 import OUT_2_3

OUT_2_4 = OUT_DIR / f"{Path(__file__).stem}.csv"


def avg_price_to_csv():
    df_apt = pd.read_csv(OUT_2_3, dtype="string")
    df_apt["거래금액"] = df_apt["거래금액"].str.replace(",", "")  # 콤마 제거
    df_apt = df_apt.astype({"전용면적": float, "거래금액": int})  # 숫자로 변환
    df_apt["면적당금액"] = df_apt["거래금액"] / df_apt["전용면적"]
    df_pivot = df_apt.pivot_table(index="지역코드", values=["전용면적", "면적당금액"], aggfunc="mean")
    df_reindex = df_pivot.reset_index(drop=False)

    df_sido_sgg = pd.read_csv(OUT_2_1, dtype="string")
    df_merge = pd.merge(df_reindex, df_sido_sgg, left_on="지역코드", right_on="sido_sgg", how="inner")
    df_filter = df_merge.filter(["sido_sgg", "locatadd_nm", "전용면적", "면적당금액"])
    df_filter.columns = ["sido_sgg", "locatadd_nm", "avg_area", "avg_price"]
    df_sort = df_filter.sort_values("locatadd_nm")
    df_sort.to_csv(OUT_2_4, index=False)


if __name__ == "__main__":
    avg_price_to_csv()

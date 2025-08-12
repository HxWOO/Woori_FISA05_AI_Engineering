from pathlib import Path

import pandas as pd
from datakart import Datagokr
from tqdm import tqdm

from step_1_1 import OUT_DIR, DATAGO_KEY
from step_2_1 import OUT_2_1

OUT_2_3 = OUT_DIR / f"{Path(__file__).stem}.csv"


def apt_trade_to_csv():
    df_addr = pd.read_csv(OUT_2_1, dtype="string")
    addr_list = df_addr.values.tolist()

    datagokr = Datagokr(DATAGO_KEY)
    yyyymm_range = [f"2023{m:02}" for m in range(1, 13)]
    result = []
    with tqdm(total=len(addr_list)) as pbar:
        for code, addr in addr_list:
            for yyyymm in yyyymm_range:
                pbar.set_description(f"[{addr:20}][{code}][{yyyymm}]")
                resp = datagokr.apt_trade(code, yyyymm)
                result += resp
            pbar.update()

    df_raw = pd.DataFrame(result)
    df_filter = df_raw.filter(["sggCd", "dealYear", "dealMonth", "dealingGbn", "umdNm", "aptNm", "excluUseAr", "dealAmount", "cdealDay"])
    df_filter.columns = ["지역코드", "계약년도", "계약월", "거래유형", "법정동", "단지명", "전용면적", "거래금액", "해제사유발생일"]

    f_is_real_deal = df_filter["해제사유발생일"].isna()
    df_real = df_filter.loc[f_is_real_deal]
    df_real = df_real.drop(columns=["해제사유발생일"])
    df_real.to_csv(OUT_2_3, index=False)


if __name__ == "__main__":
    apt_trade_to_csv()

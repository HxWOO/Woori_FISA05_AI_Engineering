import pandas as pd
from step_2_2 import OUT_2_2
from pathlib import Path
from step_1 import OUT_DIR

df_raw = pd.read_excel(OUT_2_2)
df_pivot_1 = pd.pivot_table(df_raw, index="분류", values="사용금액", aggfunc="sum")
df_pivot_1
# 피벗 테이블 이용해서 각 카테고리별 총 사용금액 집계

df_raw["거래연월"] = df_raw["거래일시"].str.slice(0,7)
df_raw
# 거래일시에서 거래연월 부분만 슬라이싱해서 컬럼 추가

df_pivot_2 = pd.pivot_table(df_raw, index="분류", columns="거래연월",
                            values="사용금액", aggfunc="sum")
df_pivot_2["누적금액"] = df_pivot_2.sum(axis=1)
df_pivot_2
# 거래연월로 컬럼 추가, 각 거래연월 값을 더해서 누적금액 컬럼 추가

df_sort = df_pivot_2.sort_values("누적금액", ascending=False)
df_sort
# 누적금액으로 내림차순 정렬

df_reindex = df_sort.reset_index()
df_reindex
# 분류를 인덱스로 쓰던걸 일반 열로 전환

df_reindex.to_excel(OUT_DIR/f"{Path(__file__).stem}.xlsx", index=False,
                    sheet_name="분류별누적금액")
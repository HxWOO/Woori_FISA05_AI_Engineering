from pathlib import Path

import geopandas as gpd
import pandas as pd

from step_1_1 import OUT_DIR
from step_2_4 import OUT_2_4
from step_3_2 import OUT_3_2

OUT_3_3 = OUT_DIR / f"{Path(__file__).stem}.geojson"


def merge_dataframe():
    gdf_geo = gpd.read_file(OUT_3_2, encoding="utf-8")
    gdf_price = gpd.read_file(OUT_2_4, encoding="utf-8")
    gdf_merge = pd.merge(
        gdf_geo,
        gdf_price,
        left_on="adm_nm",
        right_on="locatadd_nm",
        how="inner",
    )

    gdf_filter = gdf_merge.filter(["adm_nm", "avg_area", "avg_price", "geometry"])
    gdf_result = gdf_filter.astype({"avg_area": float, "avg_price": float})
    str_jsoned: str = gdf_result.to_json(drop_id=True, ensure_ascii=False, indent=2)
    OUT_3_3.write_text(str_jsoned, encoding="utf-8")  # GeoJSON 형식의 텍스트 파일로 저장


if __name__ == "__main__":
    merge_dataframe()

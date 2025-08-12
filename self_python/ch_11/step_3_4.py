from pathlib import Path

import geopandas as gpd
import matplotlib.pyplot as plt
import seaborn as sns

from step_1_1 import OUT_DIR
from step_3_3 import OUT_3_3

OUT_3_4 = OUT_DIR / f"{Path(__file__).stem}.png"


def geojson_to_img():
    sns.set_theme(context="poster", font="Malgun Gothic")
    fig, ax = plt.subplots(figsize=(16, 9), dpi=100)

    gdf_raw: gpd.GeoDataFrame = gpd.read_file(OUT_3_3, encoding="utf-8")
    gdf_raw.plot(
        column="avg_price", 
        cmap="OrRd",
        edgecolor="k",
        legend=True,
        legend_kwds={"label": "(단위: 만원)", "orientation": "vertical"},
        ax=ax,
    )
    ax.set_axis_off()
    ax.set_title("단위 면적당 평균 아파트 매매 실거래가")
    fig.set_layout_engine("tight")
    fig.savefig(OUT_3_4)


if __name__ == "__main__":
    geojson_to_img()

from pathlib import Path
import pandas as pd
import plotly.express as px
from step_1_1 import OUT_DIR
from step_3_1 import OUT_3_1

OUT_3_2 = OUT_DIR / f"{Path(__file__).stem}.png"

if __name__ == "__main__":
    df_raw = pd.read_csv(OUT_3_1)
    fig = px.treemap(
        df_raw,
        path=["종목명"],
        values="조단위"
    )
    fig.update_traces(
        marker=dict(
            cornerradius=5,  # 모서리 둥글게 
            colorscale='Plasma',  # 색상
            pad=dict(t=10, r=10, b=10, l=10),  #여백 지정
        ),
        texttemplate="<b>%{label}</b><br>%{value:,.0f}조원",  # label= 종목명, values 포맷지정
        textfont_size=30,
    )
    fig.update_layout(margin=dict(t=10, r=10, b=10, l=10)) # 이미지 여백 지정
    fig.write_image(OUT_3_2, width=1600, height=900, scale=2)  # 이미지 저장

from pathlib import Path
import pandas as pd
import plotly.express as px
from set_path import OUT_DIR
from json_to_csv import OUT_CSV

OUT_IMG = OUT_DIR / f"{Path(__file__).stem}.png"

if __name__ == "__main__":
    df_raw = pd.read_csv(OUT_CSV)
    fig = px.treemap(
        df_raw,
        path=["직업"],
        values="채용수"
    )
    fig.update_traces(
        marker=dict(
            cornerradius=5,  # 모서리 둥글게 
            colorscale='Plasma',  # 색상
            pad=dict(t=10, r=10, b=10, l=10),  #여백 지정
        ),
        texttemplate="<b>%{label}</b><br>%{value}개",  # label= 종목명, values 포맷지정
        textfont_size=30,
    )
    fig.update_layout(margin=dict(t=10, r=10, b=10, l=10)) # 이미지 여백 지정
    fig.write_image(OUT_IMG, width=1600, height=900, scale=2)  # 이미지 저장

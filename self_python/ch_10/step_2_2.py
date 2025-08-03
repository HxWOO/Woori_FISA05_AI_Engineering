import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import pandas as pd
import seaborn as sns
from step_1_1 import IMG_DIR
from step_2_1 import OUT_2_1

sns.set_theme(context="poster", style="whitegrid", font="Malgun Gothic")
sns.set_style({"grid.linestyle": ":", "grid.color": "#CCCCCC"})

def indicators_to_png():
    with pd.ExcelFile(OUT_2_1) as xlsx:
        #fig, axes = plt.subplots(5, 1, figsize=(10, 15))
        #idx = 0
        for idx, sheet_name in enumerate(xlsx.sheet_names):
            #ax: plt.Axes = axes[idx]
            df_raw = pd.read_excel(xlsx, sheet_name=sheet_name)
            df_raw['TIME'] = pd.to_datetime(df_raw['TIME'], format='%Y%m')
            df_raw.set_index('TIME', inplace=True)  # 시간을 인덱스로 삼음
            df_raw = df_raw.tail(24)  # 24개월
            x_value = df_raw.index  # x축
            y_value = df_raw["DATA_VALUE"]  # y축
            y_min = y_value.min()
            change = y_value.iloc[-1] - y_value.iloc[0]
            color = ("red" if change > 0 else "blue" if change < 0 else "black")  # 24개월전 vs 최근해서 올랐으면 red, 떨어졌음 blue, 안변했음 black
            fig, ax = plt.subplots(figsize=(9,3), dpi=100)  # 얘 삭제
            ax.plot(x_value, y_value, color=color, linewidth=3)
            ax.fill_between(x_value, y_value, y_min, color=color, alpha=0.10)  # 색 및 라인 그래프 아래부분 채우기
            ax.spines['top'].set_visible(False)
            ax.spines['right'].set_visible(False)
            ax.tick_params(axis='y', labelsize=10)
            ax.xaxis.set_major_locator(mdates.MonthLocator(interval=6))
            ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m'))
            ax.tick_params(axis='x', labelsize=10, rotation=0)
            # ax.set_title(f"{sheet_name}")
            fig.set_layout_engine("tight")
            fig.savefig(IMG_DIR / f"{sheet_name}.png")

if __name__ == "__main__":
    indicators_to_png()
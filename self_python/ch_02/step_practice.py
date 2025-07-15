from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from step_1 import OUT_DIR
from step_3_2 import OUT_3_2

plt.rcParams['font.family'] = 'Malgun Gothic'      # 한글 폰트 지정
plt.rcParams['axes.unicode_minus'] = False         # 마이너스 기호 깨짐 방지

def load_data2(n: int = 4) -> pd.DataFrame:
    df_raw = pd.read_excel(OUT_3_2)
    df_head, df_tail = df_raw[:n], df_raw[n:]
    df_sum = df_tail.drop(columns="분류").sum().to_frame().T
    df_sum["분류"] = "기타"
    return pd.concat((df_head, df_sum), ignore_index=True)

def custom_y_tick(x):
    return f"x:,"


if __name__ == "__main__":
    df = load_data2()
    labels, values = df["분류"], df["누적금액"]
    f, ax = plt.subplots(figsize=(16, 9), dpi=100)

    sns.set_theme(context="poster", font="Malgun Gothic")
    ax.bar(
        labels,
        values,
        width=0.3
    )

    ax.yaxis.grid(True, linestyle='--', linewidth=1, color='gray')  # y축 점선 그리드
    # y축 눈금 위치와 레이블 설정
    ax.set_yticks(values)
    ax.set_yticklabels(values.apply(lambda x: f"{x:,}"))

    ax.set_title("분류별 누적 사용금액")
    f.savefig(OUT_DIR/f"{Path(__file__).stem}.png")
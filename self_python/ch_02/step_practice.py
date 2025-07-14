from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from step_1 import OUT_DIR
from step_3_2 import OUT_3_2

df_raw = pd.read_excel(OUT_3_2)
df_raw.columns
labels, values = df_raw["분류"], df_raw["누적금액"]

sns.set_theme(context="poster", font="Malgun Gothic")
sns.barplot(df_raw, x="분류", y="누적금액")
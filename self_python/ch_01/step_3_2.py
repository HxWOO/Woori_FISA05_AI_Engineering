from pathlib import Path
import matplotlib.pyplot as plt
from step_2_1 import OUT_DIR
from step_3_1 import load_plot_data

plot_data = load_plot_data()
fig, ax = plt.subplots()
ax.barh(plot_data["stem"], plot_data["size"])
fig.savefig(OUT_DIR / f"{Path(__file__).stem}.png")

#  데이터 시각화 첫걸음
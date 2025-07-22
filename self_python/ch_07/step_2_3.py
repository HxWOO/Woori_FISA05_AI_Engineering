import json
from pathlib import Path
import pandas as pd
from step_1_1 import OUT_DIR
from step_2_2 import OUT_2_2
from step_1_4 import table_to_dataframe

OUT_2_3 = OUT_DIR / f"{Path(__file__).stem}.csv"

if __name__ == "__main__":
    parsed = json.loads(OUT_2_2.read_text(encoding="UTF-8"))  # JSON 파일 부르기
    header, body = parsed["header"], parsed["body"]
    df_raw = table_to_dataframe(header, body)
    df_raw.to_csv(OUT_2_3, index=False)
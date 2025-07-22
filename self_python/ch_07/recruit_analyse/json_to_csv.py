import json
from pathlib import Path
import pandas as pd
from set_path import OUT_DIR
from pre_process import OUT_PRE

OUT_CSV = OUT_DIR / f"{Path(__file__).stem}.csv"

def table_to_dataframe(data) -> pd.DataFrame:
    df = pd.DataFrame(data)
    return df


if __name__ == "__main__":
    data = json.loads(OUT_PRE.read_text(encoding="UTF-8"))  # JSON 파일 부르기
    df = table_to_dataframe(data)
    df.to_csv(OUT_DIR / f"{Path(__file__).stem}.csv", index=False)
import pandas as pd
from step_1 import IN_DIR

df_raw = pd.read_excel(IN_DIR/"2024년1월.xlsx", sheet_name="Sheet1", usecols="B:E", skiprows=2)
df_raw

# input 디렉토리에서 2024년1월.xlsx 파일을 읽어옴
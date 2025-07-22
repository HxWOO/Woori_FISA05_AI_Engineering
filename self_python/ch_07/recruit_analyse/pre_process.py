import json
import re
from pathlib import Path
from set_path import OUT_DIR
from job_recruit_count import OUT_JOB_REC

OUT_PRE = OUT_DIR / f"{Path(__file__).stem}.json"

# 기존 json 파일 불러오기
with open(OUT_JOB_REC, encoding="utf-8") as f:
    raw_data = json.load(f)

raw_body = raw_data["body"]

# 직업명 + 채용수는 두 줄씩 이므로 2개씩 묶기
data_pairs = list(zip(raw_body[0::2], raw_body[1::2]))

# 변환된 데이터를 저장할 리스트
cleaned_data = []

# 데이터 정리
for job, count in data_pairs:
    job_name = job[0].strip()
    count_number = int(re.sub(r"[^\d]", "", count[0]))  # 괄호 및 쉼표 제거
    cleaned_data.append({
        "직업": job_name,
        "채용수": count_number
    })

# 출력 (또는 저장)
OUT_PRE.write_text(json.dumps(cleaned_data, ensure_ascii=False, indent=2), encoding="utf-8")

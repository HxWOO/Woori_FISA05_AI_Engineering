from pathlib import Path

WORK_DIR = Path(__file__).parent
OUT_DIR = WORK_DIR / "output"

if __name__ == "__main__":
    OUT_DIR.mkdir(exist_ok=True)

# 폴더에 output 파일이 없으면 생성하는 코드

from pathlib import Path
from dotenv import load_dotenv
import os

WORK_DIR = Path(__file__).parent
OUT_DIR = WORK_DIR / WORK_DIR / "output"
load_dotenv()
ECOS_API_KEY = os.getenv("ECOS_API_KEY")

if __name__ == "__main__":
    OUT_DIR.mkdir(exist_ok=True)
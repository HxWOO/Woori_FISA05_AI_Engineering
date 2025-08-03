from pathlib import Path
from dotenv import load_dotenv
import os

WORK_DIR = Path(__file__).parent
IMG_DIR, OUT_DIR = WORK_DIR/"img", WORK_DIR/"output"
load_dotenv()
FSS_API_KEY = os.getenv("FSS_API_KEY")
ECOS_API_KEY = os.getenv("ECOS_API_KEY")

if __name__ == "__main__":
    IMG_DIR.mkdir() if not IMG_DIR.exists() else None
    OUT_DIR.mkdir() if not OUT_DIR.exists() else None
from pathlib import Path
from dotenv import load_dotenv
import os

load_dotenv()

WORK_DIR = Path(__file__).parent
IN_DIR, OUT_DIR = WORK_DIR / "input", WORK_DIR / "output"
DATAGO_KEY=os.getenv("DATAGO_KEY")
SGIS_KEY=os.getenv("SGIS_KEY")
SGIS_SECRET=os.getenv("SGIS_SECRET")

if __name__ == "__main__":
    IN_DIR.mkdir(exist_ok=True)
    OUT_DIR.mkdir(exist_ok=True)
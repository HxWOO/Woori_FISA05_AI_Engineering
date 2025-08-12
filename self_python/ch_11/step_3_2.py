from pathlib import Path

from datakart import Sgis

from step_1_1 import OUT_DIR, SGIS_KEY, SGIS_SECRET

OUT_3_2 = OUT_DIR / f"{Path(__file__).stem}.geojson"


def adm_cd_to_geojson(adm_cd: str = None, low_search: str = "1") -> None:
    sgis = Sgis(SGIS_KEY, SGIS_SECRET)
    resp: str = sgis.hadm_area(adm_cd=adm_cd, low_search=low_search)
    OUT_3_2.write_text(resp, encoding="utf-8")

if __name__ == "__main__":
    adm_cd, low_search = "11", "1"
    adm_cd_to_geojson(adm_cd, low_search)

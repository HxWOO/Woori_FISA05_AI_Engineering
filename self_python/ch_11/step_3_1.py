import geopandas as gpd
from datakart import Sgis
from step_1_1 import SGIS_KEY, SGIS_SECRET

sgis = Sgis(SGIS_KEY, SGIS_SECRET)
resp: str = sgis.hadm_area(adm_cd="11", low_search="1")
gdf_resp: gpd.GeoDataFrame = gpd.read_file(resp)
gdf_resp.head(3)  # 첫 3개 행 출력

gdf_resp.plot()

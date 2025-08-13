
import logging
import json
from elasticsearch import Elasticsearch, helpers
from shapely.geometry import shape, mapping
from shapely.ops import transform
import pyproj

logger = logging.getLogger(__name__)

def create_seoul_boundary_index(es_client, index_name="seoul-boundaries"):
    """
    서울시 경계 인덱스 생성
    """
    if es_client.indices.exists(index=index_name):
        logger.info(f"인덱스 '{index_name}'가 이미 존재합니다.")
        return

    mapping_body = {
        "mappings": {
            "properties": {
                "location": {"type": "geo_shape"},
                "adm_cd": {"type": "keyword"},
                "adm_nm": {"type": "text"},
                "addr_en": {"type": "text"},
                "x": {"type": "float"},
                "y": {"type": "float"}
            }
        },
        "settings": {
            "number_of_shards": 1,
            "number_of_replicas": 1
        }
    }
    es_client.indices.create(index=index_name, body=mapping_body)
    logger.info(f"'{index_name}' 인덱스 생성 완료")


def convert_coords_to_wgs84(geom):
    """
    SGIS 좌표계(EPSG:5179) → WGS84(EPSG:4326) 변환
    """
    project = pyproj.Transformer.from_crs("EPSG:5179", "EPSG:4326", always_xy=True).transform
    shapely_geom = shape(geom)
    # self-intersection 제거
    shapely_geom = shapely_geom.buffer(0)
    return mapping(transform(project, shapely_geom))


def index_geojson_features(es_client, index_name, geojson_features):
    """
    GeoJSON feature들을 Elasticsearch에 bulk로 적재
    """
    def gen_actions():
        for feature in geojson_features:
            geom = feature.get("geometry")
            props = feature.get("properties", {})
            adm_cd = props.get("adm_cd")
            if not geom or not adm_cd:
                continue
            try:
                clean_geom = convert_coords_to_wgs84(geom)
            except Exception as e:
                logger.warning(f"{adm_cd} geometry 변환 실패: {e}")
                continue
            yield {
                "_index": index_name,
                "_id": adm_cd,
                "_source": {
                    "location": clean_geom,
                    "adm_cd": adm_cd,
                    "adm_nm": props.get("adm_nm"),
                    "addr_en": props.get("addr_en"),
                    "x": props.get("x"),
                    "y": props.get("y")
                }
            }

    # 🔍 샘플 문서 로그
    try:
        first_doc = next(gen_actions())
        logger.info(f"샘플 문서: {json.dumps(first_doc, ensure_ascii=False)[:300]}")
    except StopIteration:
        logger.error("GeoJSON features가 비어 있음")
        return

    # bulk 적재
    success, failed = helpers.bulk(es_client, gen_actions(), raise_on_error=False)
    logger.info(f"성공 처리 문서 수: {success}, 실패 처리 문서 수: {len(failed)}")
    if failed:
        logger.warning(f"실패 문서 예시: {failed[:5]}")
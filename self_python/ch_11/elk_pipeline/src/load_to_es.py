import xml.etree.ElementTree as ET
import logging
from elasticsearch import Elasticsearch, helpers
import time

logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)s] %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
logger = logging.getLogger(__name__)

def get_es_client():
    for i in range(6):
        try:
            logger.info(f"Elasticsearch 연결 시도 ({i+1}/6)...")
            client = Elasticsearch("http://elasticsearch:9200", request_timeout=10)
            if client.ping():
                logger.info("Elasticsearch에 성공적으로 연결되었습니다.")
                return client
            else:
                logger.warning("Elasticsearch ping 실패")
        except Exception as e:
            logger.error(f"연결 중 오류 발생: {e}")

        if i < 5:
            logger.info("5초 후 재시도합니다...")
            time.sleep(5)

    logger.error("Elasticsearch에 연결할 수 없습니다.")
    return None

def index_data_to_es(es_client, index_name, data_generator):
    if not es_client:
        logger.error("Elasticsearch 클라이언트가 없습니다. 데이터 적재 중단")
        return

    try:
        logger.info(f"'{index_name}' 인덱스에 데이터 적재를 시작합니다...")
        success, errors = helpers.bulk(es_client, data_generator, raise_on_error=False)
        logger.info(f"성공 처리 문서 수: {success}")
        if errors:
            logger.warning(f"실패한 문서 수: {len(errors)}")
            logger.debug(f"실패 문서 상세: {errors}")
    except Exception as e:
        logger.error(f"데이터 적재 중 오류 발생: {e}")

def xml_to_json_generator(xml_data, index_name):
    if not xml_data:
        logger.warning("빈 XML 데이터를 받았습니다.")
        return

    try:
        root = ET.fromstring(xml_data)
    except ET.ParseError as e:
        logger.error(f"XML 파싱 실패: {e}")
        return

    items = root.findall('.//item')
    for item in items:
        source_data = {}
        for child in item:
            text = child.text.strip() if child.text else None
            if child.tag == '거래금액':
                try:
                    value = int(text.replace(',', '')) if text else None
                except ValueError:
                    logger.warning(f"거래금액 변환 오류: {text}")
                    value = None
            else:
                value = text
            source_data[child.tag] = value

        yield {
            "_index": index_name,
            "_source": source_data
        }

def parse_lawd_codes_xml(xml_data):
    """
    법정동 코드용 XML 파서 — row 단위로 파싱 후 리스트 반환
    """
    try:
        root = ET.fromstring(xml_data)
    except ET.ParseError as e:
        logger.error(f"법정동 코드 XML 파싱 실패: {e}")
        return []

    rows = root.findall('.//row')
    lawd_codes = []
    for row in rows:
        sido_cd = row.findtext('sido_cd')
        sgg_cd = row.findtext('sgg_cd')
        lawd_cd = (sido_cd or '') + (sgg_cd or '')
        lawd_nm = row.findtext('locallow_nm') or row.findtext('lawd_nm')
        if lawd_cd and lawd_nm:
            lawd_codes.append({'lawd_cd': lawd_cd, 'lawd_nm': lawd_nm})
    return lawd_codes


def geojson_to_es_generator(geojson, index_name):
    """
    행정구역경계 API에서 받은 GeoJSON 데이터를 Elasticsearch bulk 적재용으로 변환하는 제너레이터

    :param geojson: API 응답 JSON(dict)
    :param index_name: 저장할 ES 인덱스명
    :yield: bulk API용 dict
    """
    if not geojson:
        logger.warning("빈 GeoJSON 데이터를 받았습니다.")
        return
    
    features = geojson.get("features", [])
    for feature in features:
        properties = feature.get("properties", {})
        geometry = feature.get("geometry", {})
        
        # 고유 ID로 행정구역 코드 사용 (없으면 None)
        adm_cd = properties.get("adm_cd")
        
        # Elasticsearch geo_shape 필드로 geometry를 넣는다
        doc = {
            "adm_cd": adm_cd,
            "adm_nm": properties.get("adm_nm"),
            "addr_en": properties.get("addr_en"),
            "x": properties.get("x"),
            "y": properties.get("y"),
            "location": {  # geo_shape 필드명 예시, ES mapping에 맞춰 수정 가능
                "type": geometry.get("type"),
                "coordinates": geometry.get("coordinates"),
            }
        }
        
        yield {
            "_index": index_name,
            "_id": adm_cd,
            "_source": doc
        }
# kibana_map_import.py
import json
import requests
import logging
from datetime import datetime

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

def generate_map_ndjson(map_json, title="서울 아파트 거래 Map"):
    """
    Kibana Map Saved Object용 NDJSON 생성
    :param map_json: visualize_to_map.generate_kibana_map_json() 결과 dict
    :param title: Kibana Map 제목
    :return: NDJSON 문자열
    """
    obj = {
        "id": f"map-{int(datetime.now().timestamp())}",
        "type": "map",
        "attributes": {
            "title": title,
            "description": "",
            "layerListJSON": json.dumps(map_json.get("layers", [])),
            "uiStateJSON": "{}",
            "optionsJSON": "{}",
            "mapStateJSON": "{}"
        },
        "references": [],
        "migrationVersion": {},
        "updated_at": datetime.utcnow().isoformat(),
        "version": "1"
    }
    ndjson_str = json.dumps(obj, ensure_ascii=False) + "\n"
    return ndjson_str

def import_map_to_kibana(ndjson_str, kibana_url="http://kibana:5601", kibana_user=None, kibana_pass=None):
    """
    NDJSON을 Kibana Saved Objects API로 import
    :param ndjson_str: NDJSON 문자열
    :param kibana_url: Kibana URL (Docker 내부는 http://kibana:5601)
    :param kibana_user: Kibana 인증 계정
    :param kibana_pass: Kibana 인증 비밀번호
    """
    url = f"{kibana_url}/api/saved_objects/_import?overwrite=true"
    headers = {"kbn-xsrf": "true"}
    files = {"file": ("map.ndjson", ndjson_str)}

    auth = (kibana_user, kibana_pass) if kibana_user and kibana_pass else None

    logger.info("Kibana Saved Objects API 호출 시작")
    resp = requests.post(url, headers=headers, files=files, auth=auth)
    if resp.status_code == 200:
        logger.info("✅ Kibana Map 시각화 import 성공")
    else:
        logger.error(f"❌ Kibana import 실패: {resp.status_code} {resp.text}")

if __name__ == "__main__":
    # 테스트용
    JSON_FILE = "kibana_map_layers.json"
    with open(JSON_FILE, "r", encoding="utf-8") as f:
        map_json = json.load(f)

    ndjson_str = generate_map_ndjson(map_json)
    import_map_to_kibana(ndjson_str, kibana_url="http://kibana:5601", kibana_user="elastic", kibana_pass="changeme")
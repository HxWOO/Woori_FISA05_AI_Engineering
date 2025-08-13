# visualize_to_map.py
import json
import logging
import io
import requests
from requests.auth import HTTPBasicAuth

logger = logging.getLogger(__name__)

def generate_kibana_map_json(apt_index, boundary_index):
    """
    Elasticsearch 아파트 거래 데이터와 서울시 경계 데이터를 이용해 Kibana Map Saved Object 구조 생성
    """
    # Kibana Saved Object 기본 구조
    map_attributes = {
        "title": "서울 아파트 거래 Map",
        "description": "",
        "layers": [
            {
                "layerType": "Documents",
                "sourceDescriptor": {
                    "indexPatternId": boundary_index,
                    "geoField": "location"
                },
                "style": {
                    "fillColor": {"type": "static", "value": "rgba(0,0,0,0)"},
                    "lineColor": {"type": "static", "value": "#0055FF"},
                    "lineWidth": 2
                },
                "label": "서울시 행정동 경계",
                "alpha": 1
            },
            {
                "layerType": "ESGeoGrid",
                "sourceDescriptor": {
                    "indexPatternId": apt_index,
                    "geoField": "location",
                    "metrics": [{"type": "avg", "field": "거래금액"}],
                    "requestType": "geo_grid",
                    "gridResolution": "high"
                },
                "style": {
                    "fillColor": {"type": "interval", "field": "avg_거래금액",
                                  "stops": [
                                      {"value": 0, "color": "#f2f0f7"},
                                      {"value": 500000000, "color": "#cbc9e2"},
                                      {"value": 1000000000, "color": "#9e9ac8"},
                                      {"value": 1500000000, "color": "#6a51a3"}
                                  ]},
                    "iconSize": {"type": "interval", "field": "avg_거래금액",
                                 "stops": [
                                     {"value": 0, "size": 2},
                                     {"value": 500000000, "size": 5},
                                     {"value": 1000000000, "size": 8}
                                 ]}
                },
                "label": "서울 아파트 거래",
                "alpha": 1
            }
        ],
        "zoom": 11,
        "center": {"lon": 126.9784, "lat": 37.5665}
    }

    return map_attributes


def import_kibana_map(map_attributes,
                       kibana_url="http://kibana:5601",
                       username=None,
                       password=None):
    """
    Kibana Saved Objects Import API를 이용해 Map JSON을 직접 Kibana에 등록
    """
    ndjson_content = io.StringIO()
    ndjson_obj = {
        "type": "map",
        "id": map_attributes.get("title", "seoul-map").replace(" ", "-").lower(),
        "attributes": map_attributes
    }
    ndjson_content.write(json.dumps(ndjson_obj, ensure_ascii=False) + "\n")
    ndjson_content.seek(0)

    import_url = f"{kibana_url}/api/saved_objects/_import?overwrite=true"
    headers = {"kbn-xsrf": "true"}
    files = {"file": ("kibana_map_layers.ndjson", ndjson_content)}

    auth = HTTPBasicAuth(username, password) if username and password else None

    try:
        resp = requests.post(import_url, headers=headers, files=files, auth=auth)
        resp.raise_for_status()
        logger.info(f"✅ Kibana에 Map Saved Object import 완료: {resp.status_code}")
        logger.debug(f"Kibana 응답: {resp.text}")
    except Exception as e:
        logger.error(f"❌ Kibana import 실패: {e}")

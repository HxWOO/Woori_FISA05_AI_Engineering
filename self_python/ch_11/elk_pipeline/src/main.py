# main_optimized.py
from . import config, fetch_data, load_to_es, make_geo_info, visualize_to_map, fetch_from_es
import logging

logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)s] %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
logger = logging.getLogger(__name__)

def main():
    es_client = load_to_es.get_es_client()
    if not es_client:
        logger.error("Elasticsearch 연결 실패. 종료합니다.")
        return

    # 1. 법정동 코드 확인/적재
    lawd_index = "lawd-codes"
    if es_client.indices.exists(index=lawd_index):
        logger.info(f"'{lawd_index}' 인덱스가 이미 존재합니다. API 호출 및 적재 생략")
        lawd_docs = fetch_from_es.fetch_lawd_codes_from_es(es_client, lawd_index)
        lawd_codes = [doc["_source"] for doc in lawd_docs]
    else:
        logger.info("서울시 법정동 코드 API 호출")
        sido_cd = "11"
        lawd_xml = fetch_data.fetch_lawd_codes(sido_cd)
        if not lawd_xml:
            logger.error("법정동 코드 API 호출 실패")
            return
        lawd_codes = load_to_es.parse_lawd_codes_xml(lawd_xml)
        if not lawd_codes:
            logger.error("법정동 코드 파싱 실패")
            return
        def lawd_gen():
            for code in lawd_codes:
                yield {"_index": lawd_index, "_id": code['lawd_cd'], "_source": code}
        load_to_es.index_data_to_es(es_client, lawd_index, lawd_gen())

    # 2. 아파트 거래 데이터 확인/적재
    target_yyyymm = "202503"
    apt_index = f"apartment-trade-{target_yyyymm}"
    if es_client.indices.exists(index=apt_index):
        logger.info(f"'{apt_index}' 인덱스가 이미 존재합니다. API 호출 생략")
    else:
        for code in lawd_codes:
            lawd_cd = code['lawd_cd']
            apt_xml = fetch_data.fetch_apartment_trade_data(target_yyyymm, lawd_cd)
            if not apt_xml:
                continue
            apt_data_gen = load_to_es.xml_to_json_generator(apt_xml, apt_index)
            load_to_es.index_data_to_es(es_client, apt_index, apt_data_gen)

    # 3. 서울시 경계 확인/적재
    geo_index = "seoul-boundaries"
    # if es_client.indices.exists(index=geo_index):
    #     logger.info(f"'{geo_index}' 인덱스가 이미 존재합니다. 적재 생략")
    # else:
    geojson_data = fetch_data.fetch_hadmarea_boundary(adm_cd="11", year="2024", low_search="2")
    if not geojson_data:
        logger.error("서울시 경계 데이터 호출 실패")
        return
    geojson_features = geojson_data.get("features", [])
    if not geojson_features:
        logger.error("서울시 경계 데이터가 비어있음")
        return
    make_geo_info.create_seoul_boundary_index(es_client)
    make_geo_info.index_geojson_features(es_client, geo_index, geojson_features)
    logger.info("서울시 경계 데이터 Elasticsearch 적재 완료")

    # 4. Elasticsearch에서 데이터 가져와 바로 Kibana Map JSON 생성
    logger.info("Kibana Map JSON 생성 시작")
    map_json = visualize_to_map.generate_kibana_map_json(
        apt_index=apt_index,
        boundary_index=geo_index
    )

    visualize_to_map.import_kibana_map(
        map_json,
        kibana_url="http://kibana:5601",  # Docker 내부 URL
        username="elastic",
        password="changeme"
    )
    logger.info("전체 파이프라인 + Kibana Map import 완료")

if __name__ == "__main__":
    if not config.API_KEY:
        logger.error("`src/config.py`에 API_KEY를 설정하세요.")
    else:
        main()
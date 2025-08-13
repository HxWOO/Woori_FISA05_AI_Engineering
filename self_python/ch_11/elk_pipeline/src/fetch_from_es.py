import logging

logger = logging.getLogger(__name__)

from elasticsearch import Elasticsearch

def get_es_client(host="http://elasticsearch:9200"):
    return Elasticsearch(hosts=[host])

def fetch_all_documents(es_client, index_name, scroll='2m', size=10000):
    """
    Elasticsearch에서 지정한 인덱스의 모든 문서를 scroll API를 사용해 조회합니다.

    :param es_client: Elasticsearch 클라이언트 객체
    :param index_name: 조회할 인덱스명
    :param scroll: scroll 컨텍스트 유지 시간 (기본 '2m')
    :param size: 한번에 가져올 문서 수 (기본 10000)
    :return: 문서 리스트
    """
    all_docs = []
    try:
        query = {
            "size": size,
            "query": {"match_all": {}}
        }
        resp = es_client.search(index=index_name, body=query, scroll=scroll)
        scroll_id = resp['_scroll_id']
        hits = resp['hits']['hits']
        all_docs.extend(hits)

        while hits:
            resp = es_client.scroll(scroll_id=scroll_id, scroll=scroll)
            scroll_id = resp['_scroll_id']
            hits = resp['hits']['hits']
            all_docs.extend(hits)

        logger.info(f"{index_name} 인덱스에서 총 {len(all_docs)}건의 문서를 조회했습니다.")
    except Exception as e:
        logger.error(f"{index_name} 인덱스 문서 조회 중 오류 발생: {e}")

    return all_docs

def fetch_lawd_codes_from_es(es_client, index_name='lawd-codes'):
    """
    법정동 코드 인덱스에서 모든 문서를 조회합니다.

    :param es_client: Elasticsearch 클라이언트 객체
    :param index_name: 법정동 코드 인덱스명 (기본 'lawd-codes')
    :return: 문서 리스트
    """
    return fetch_all_documents(es_client, index_name)

import requests
import logging
import time
from . import config

logger = logging.getLogger(__name__)

APT_TRADE_API_URL = "http://apis.data.go.kr/1613000/RTMSDataSvcAptTrade/getRTMSDataSvcAptTrade"
LAW_CODE_API_URL = "http://apis.data.go.kr/1741000/StanReginCd/getStanReginCdList"
_access_token_cache = {"token": None, "expires_at": 0}

def get_access_token():
    """
    SGIS API 인증키 발급 (GET 방식)
    캐싱해서 재사용, 만료되면 자동 갱신
    """
    now = time.time()
    if _access_token_cache["token"] and now < _access_token_cache["expires_at"]:
        return _access_token_cache["token"]

    url = "https://sgisapi.kostat.go.kr/OpenAPI3/auth/authentication.json"
    params = {
        "consumer_key": config.CONSUMER_KEY,
        "consumer_secret": config.CONSUMER_SECRET
    }

    try:
        resp = requests.get(url, params=params, timeout=10)
        resp.raise_for_status()
        parsed = resp.json()

        if parsed.get("errCd") != 0:
            logger.error(f"SGIS 인증 실패: {parsed}")
            return None

        result = parsed.get("result", {})
        token = result.get("accessToken")
        timeout_sec = int(result.get("accessTimeout", 0))

        if token:
            _access_token_cache["token"] = token
            _access_token_cache["expires_at"] = now + timeout_sec - 60
            logger.info(f"새로운 accessToken 발급 (유효기간 {timeout_sec}초)")
            return token
        else:
            logger.error("accessToken이 응답에 없습니다.")
            return None

    except requests.RequestException as e:
        logger.error(f"SGIS 인증키 발급 요청 실패: {e}")
        return None


def fetch_apartment_trade_data(yyyymm, lawd_cd):
    """
    특정 연월, 특정 지역의 아파트 매매 실거래가 데이터를 요청하여 반환합니다.
    """
    params = {
        "serviceKey": config.API_KEY,
        "pageNo": "1",
        "numOfRows": "1000",  # 충분히 큰 값으로 설정하여 모든 데이터 가져오기
        "LAWD_CD": lawd_cd,
        "DEAL_YMD": yyyymm
    }
    try:
        logger.info(f"API 요청: {yyyymm} / {lawd_cd}")
        response = requests.get(APT_TRADE_API_URL, params=params, timeout=10)
        response.raise_for_status()
        logger.info("API 요청 성공")
        logger.info(f"아파트 거래 데이터 응답 길이: {len(response.text) if response else 0}")
        logger.debug(f"아파트 거래 데이터 샘플: {response.text[:500] if response else '없음'}")
        return response.text
    except requests.exceptions.RequestException as e:
        logger.error(f"API 요청 중 오류 발생: {e}")
        return None


def fetch_lawd_codes(sido_cd):
    """
    SGIS Open API를 이용해 시도명(sido_name)에 해당하는 법정동 코드 리스트를 가져옵니다.

    :param sido_name: 시도명 예: '서울특별시'
    :return: XML 문자열 혹은 None
    """
    params = {
        "serviceKey": config.API_KEY,
        "pageNo": "1",
        "numOfRows": "1000",
        "type": "xml",
        "sido_cd": sido_cd
    }
    try:
        logger.info(f"법정동 코드 API 요청: sido_cd={sido_cd}")
        response = requests.get(LAW_CODE_API_URL, params=params, timeout=10)
        response.raise_for_status()
        logger.info("법정동 코드 API 요청 성공")
        return response.text
    except requests.exceptions.RequestException as e:
        logger.error(f"법정동 코드 API 요청 중 오류 발생: {e}")
        return None



def fetch_hadmarea_boundary(adm_cd, year="2024", low_search="1"):
    """
    행정구역경계 API 호출
    :param adm_cd: 행정구역 코드 (2자리 시도, 5자리 시군구 등)
    :param year: 기준 연도 (기본 2024)
    :param low_search: 하위 통계 여부 (0, 1, 2 단계)
    :return: GeoJSON dict 또는 None
    """
    access_token = get_access_token()
    if not access_token:
        logger.error("accessToken 획득 실패로 API 호출 불가")
        return None

    params = {
        "accessToken": access_token,
        "year": year,
        "adm_cd": adm_cd,
        "low_search": low_search
    }
    try:
        response = requests.get(
            "https://sgisapi.kostat.go.kr/OpenAPI3/boundary/hadmarea.geojson",
            params=params,
            timeout=10
        )
        response.raise_for_status()
        return response.json()
    except Exception as e:
        logger.error(f"행정구역경계 API 호출 실패: {e}")
        return None
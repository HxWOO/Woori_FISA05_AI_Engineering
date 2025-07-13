# 월별 카드 지출 내역분석

1. 준비
    - pathlib 패키지
    - openpyxl 패키지
    - pandas 패키지
    - seaborn 패키지

1. pandas 이용 데이터 취합, 수집
    - `read_excel`: 엑셀 파일을 읽어 DataFrame으로 변환합니다.
    - `to_excel`: DataFrame을 엑셀 파일로 저장
    - `concat`: 여러 개의 DataFrame을 하나로 합침

1. 데이터 분석
    - `pivot_table`: 데이터 열 중에서 두 개의 열을 각각 행과 열로 사용하여 데이터를 재구성하고, 특정 열의 값을 집계하여 요약 테이블을 생성
        
        ```python
        import pandas as pd
        
        pd.pivot_table(
        		df,  # 피벗 테이블을 만들 데이터프레임
        		index="row",  # 피벗 테이블의 행이 될 집계 기준 열
        		columns="column",  # 피벗 테이블의 열이 될 집계 기준 열
        		values="value",  # 집계할 데이터
        		aggfunc="sum",  # 집계 방식
        )
        ```
        
    - **실습 내용:**
        - `step_3_1.py`: `pivot_table`을 사용하여 '분류'별 '사용금액'의 합계를 계산하고, '거래일시'에서 '거래연월'을 추출하여 월별 사용 금액을 집계함. 마지막으로, '누적금액'을 기준으로 내림차순 정렬하여 엑셀 파일로 저장함
        - `step_3_2.py`: `step_3_1.py`의 코드를 모듈화하여 재사용성을 높임

1. 시각화
    - **바 차트**: 항목별 값을 비교하거나 시간의 흐름에 따른 데이터 변화를 보여줄 때 유용
    - **산점도**: 두 변수 간의 관계나 데이터의 분포를 파악하는 데 사용
    - **파이 차트**: 전체에 대한 각 부분의 비율을 나타낼 때 효과적

    - **실습 내용:**
        - `step_4_1.py`: `matplotlib.pyplot`을 사용하여 '누적금액'을 기준으로 파이 차트를 생성하고, 상위 4개 항목 외에는 '기타'로 분류하여 시각화
        - `step_4_2.py`: `step_4_1.py`의 데이터 전처리 및 차트 생성 부분을 함수로 만들어 모듈화
        - `step_4_3.py`: `seaborn`과 `matplotlib.pyplot`을 함께 사용하여 파이 차트를 꾸미고, `autopct`를 활용해 값과 비율을 함께 표시하도록 개선함. 또한, `legend`와 `title`을 추가하여 차트의 가독성을 높임

**미니실습**

- seaborn 패키지의 barplot()을 사용해 barchart 만들 수 있음
    1. 그래프 제목을 ‘분류별 누적 사용금액’으로 설정
    2. y축 눈금을 콤마(,)를 사용해 천 단위로 표시
    
    Axes 객체의 함수 get_yticks()와 set_yticks()를 사용해 y축 눈금 조정 가능

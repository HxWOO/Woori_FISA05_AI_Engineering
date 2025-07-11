# 📅 2주차 - 9일차

## 🐼 Pandas (Python Data Analysis Library)

- **데이터 분석**을 위한 파이썬 필수 라이브러리.
- **DataFrame**이라는 2차원 테이블 형태의 데이터 구조를 사용해, 엑셀처럼 직관적으로 데이터를 다룰 수 있음.

---

### 1. Pandas를 왜 쓸까? 🤔

- **빠른 속도**: Numpy 기반으로 만들어져 대용량 데이터를 효율적으로 처리.
- **쉬운 데이터 핸들링**: 복잡한 데이터 전처리, 정제, 분석 작업을 간결한 코드로 수행 가능.
- **다양한 포맷 지원**: CSV, Excel, SQL 등 여러 데이터 소스를 쉽게 읽고 쓸 수 있음.
- **구조적인 데이터**: **DataFrame**은 **Series(1차원 배열)**가 모인 2차원 구조로, 직관적이고 다루기 쉬움.

> **💡 Tip**: Pandas는 행(row)이 아닌 **열(column)을 기본 단위**로 다룸. `DataFrame[열][행]` 순서로 접근.

---

### 2. `DataFrame`: Pandas의 핵심 ✨

- **정의**: 인덱스(index), 컬럼(column), 값(value)으로 구성된 2차원 데이터 구조.

#### 📝 `DataFrame` 생성 및 기본 조작

```python
import numpy as np
import pandas as pd

# 딕셔너리로 DataFrame 생성
data = {
    'Name': ['S1', 'S2', 'S3'],
    'Age': [25, 28, 22],
    'Score': [95, 85, 75]
}
df = pd.DataFrame(data)

# 컬럼 접근
print(df['Name'])  # Series 형태로 반환
# print(df.Name) # 동일한 결과

# 주요 속성
print(df.columns) # 컬럼 이름 확인
print(df.index)   # 인덱스 정보 확인
print(df.values)  # Numpy 배열 형태로 값 확인

# 컬럼 추가 및 변경
df['Region'] = ['강동', '강서', None] # 새 컬럼 추가
df['Region'] = '상암' # 모든 행에 같은 값 적용 (브로드캐스팅)

# 컬럼/행 삭제
df.drop('Region', axis=1, inplace=True) # axis=1: 열 기준, inplace=True: 원본에 바로 적용
df.drop(2, axis=0, inplace=True)      # axis=0: 행 기준
```

---

### 3. 데이터 조회 및 탐색 🔍

- 데이터의 구조와 특징을 파악하기 위한 필수 메서드들.

#### 📝 주요 조회 메서드

```python
# 데이터 요약 정보
df.info() # 데이터 타입, non-null 개수 등 구조적 정보
df.describe() # 수치형 데이터의 통계 요약 (평균, 표준편차 등)

# 데이터 미리보기
df.head() # 처음 5행
df.tail() # 마지막 5행

# 고유값 확인
df['Age'].unique()   # 고유한 값들을 배열로 반환
df['Age'].nunique()  # 고유한 값의 개수
```

---

### 4. 데이터 합치기 🤝

- 여러 DataFrame을 다양한 방식으로 결합.

| 메서드 | 설명 | 특징 |
| :--- | :--- | :--- |
| **`concat()`** | 데이터프레임을 그대로 이어 붙임 | `axis=0` (행), `axis=1` (열) 기준. 중복 처리 안 함. |
| **`merge()`** | 공통된 열(key)을 기준으로 병합 | SQL의 `JOIN`과 유사. 중복된 열은 하나로 합침. |
| **`join()`** | 인덱스를 기준으로 병합 | `merge()`와 유사하지만, 인덱스 기반으로 동작. |

---

### 5. 인덱싱과 슬라이싱: `loc` vs `iloc` 🎯

- **`loc`**: **라벨(이름)** 기반으로 데이터에 접근. (e.g., `df.loc[0, 'Name']`)
- **`iloc`**: **정수 인덱스(위치)** 기반으로 데이터에 접근. (e.g., `df.iloc[0, 0]`)

```python
# loc: 라벨 기반 슬라이싱 (끝점 포함)
df.loc[0:1, 'Name':'Age']

# iloc: 정수 인덱스 기반 슬라이싱 (끝점 미포함)
df.iloc[0:2, 0:2]

# 조건부 필터링
df.loc[df['Age'] > 23, ['Name', 'Score']] # 나이가 23세 초과인 사람의 이름과 점수
```

---

### 6. 주요 기능 및 메서드 ⚙️

#### ✨ 정렬 (`sort_values`)
- 특정 열을 기준으로 데이터를 정렬.

```python
# 'Age' 컬럼 기준 오름차순 정렬
df.sort_values('Age')

# 'Age' 내림차순, 'Name' 오름차순으로 다중 정렬
df.sort_values(['Age', 'Name'], ascending=[False, True])
```

#### ✨ 그룹화 (`groupby`)
- 특정 열의 값들을 기준으로 데이터를 그룹으로 묶어 집계 함수(sum, mean 등)를 적용.

```python
# 'Class' 별 점수 평균 계산
df.groupby('Class')['Score'].mean()
```

#### ✨ 함수 적용 (`apply`)
- DataFrame의 행이나 열에 복잡한 함수를 일괄적으로 적용.

```python
def get_grade(score):
    if score >= 90:
        return 'A'
    elif score >= 80:
        return 'B'
    else:
        return 'C'

df['Grade'] = df['Score'].apply(get_grade)
```

#### ✨ 파일 입출력
- CSV, Excel 등 다양한 형식의 파일을 쉽게 다룰 수 있음.

```python
# CSV 파일로 저장 (인덱스 제외)
df.to_csv('my_data.csv', index=False)

# CSV 파일 읽기
new_df = pd.read_csv('my_data.csv')
```

---

### 7. 실습 예제 💻

- 아래 데이터프레임을 사용하여 다음 문제들을 해결해 보세요.

```python
import numpy as np
import pandas as pd

# 예제 데이터프레임 생성
data = {'country': ['Belgium', 'France', 'Germany', 'Netherlands', 'United Kingdom'],
        'population': [11.3, 64.3, 81.3, 16.9, 64.9],
        'area': [30510, 671308, 357050, 41526, 244820],
        'capital': ['Brussels', 'Paris', 'Berlin', 'Amsterdam', 'London']}
countries = pd.DataFrame(data)
```

---

#### 📝 실습 1: 인구 밀도(`density`) 칼럼 추가
- **문제**: 인구 밀도를 계산하여 `density` 칼럼을 추가하세요. (주의: `population`은 100만 단위입니다.)
- **풀이**:
```python
countries['density'] = (countries['population'] * 1000000) / countries['area']
```

---

#### 📝 실습 2: 특정 조건의 데이터 선택
- **문제**: 인구 밀도가 300을 초과하는 국가의 수도(`capital`)와 인구(`population`)를 선택하세요.
- **풀이**:
```python
countries.loc[countries['density'] > 300, ['capital', 'population']]
```

---

#### 📝 실습 3: 파생 변수 추가
- **문제**: `density_ratio` 칼럼을 추가하세요. (값 = 인구 밀도 / 평균 인구 밀도)
- **풀이**:
```python
countries['density_ratio'] = countries['density'] / countries['density'].mean()
```

---

#### 📝 실습 4: 특정 값 변경
- **문제**: 영국(United Kingdom)의 수도(`capital`)를 'Cambridge'로 변경하세요.
- **풀이**:
```python
countries.loc[countries['country'] == 'United Kingdom', 'capital'] = 'Cambridge'
```

---

#### 📝 실습 5: 다중 조건 필터링
- **문제**: 인구 밀도가 100 초과, 300 미만인 국가들을 표시하세요.
- **풀이**:
```python
countries.loc[(countries['density'] > 100) & (countries['density'] < 300)]
```

---

#### 📝 실습 6: 문자열 길이 조건
- **문제**: 수도(`capital`) 이름이 7글자 이상인 국가들을 표시하세요.
- **풀이**:
```python
countries.loc[countries['capital'].str.len() >= 7]
```

---

#### 📝 실습 7: 문자열 포함 조건
- **문제**: 수도(`capital`) 이름에 'am'이 포함되는 국가들을 표시하세요.
- **풀이**:
```python
countries.loc[countries['capital'].str.contains('am')]
```

---

#### 📝 실습 8: 파일 입출력
- **문제**: `countries` 데이터프레임을 `countries.csv`로 저장한 후, `country` 열을 인덱스로 하여 `countries_final` 변수로 다시 불러오세요.
- **풀이**:
```python
# 파일로 저장
countries.to_csv("countries.csv", index=False)

# 인덱스를 지정하여 파일 불러오기
countries_final = pd.read_csv("countries.csv", index_col='country')
print(countries_final)
```
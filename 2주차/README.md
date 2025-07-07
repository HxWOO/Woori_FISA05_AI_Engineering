# 2주차 5일차 정리 ✨

## 함수형 프로그래밍 🧩

함수형 프로그래밍은 **순수 함수**와 **불변성**을 중심으로, 부수 효과를 최소화하고 예측 가능한 코드를 작성하는 패러다임입니다.  
Python도 함수형 프로그래밍의 주요 기능을 지원합니다.

### 특징

- 🟢 **순수 함수**: 동일한 입력에 대해 항상 동일한 출력, 외부 상태 변화 없음
- 🟢 **불변 데이터**: 데이터는 한 번 생성되면 변경 불가
- 🟢 **고차 함수**: 함수를 인자로 받거나 반환 (예: `map`, `filter`)
- 🟢 **Lazy Evaluation**: 필요할 때만 계산 (대표: generator)

## List Comprehension 📝

> 기존 리스트를 바탕으로 새로운 리스트를 쉽고 빠르게 생성하는 문법  
> for + append보다 메모리와 속도 면에서 효율적

```python
li = [수식 for 변수 in 반복가능객체]
li2 = [수식 for 변수1 in 반복1 for 변수2 in 반복2 if 조건]
```

## 내장 함수 모음 🛠️

### map

- 🔹 시퀀스의 각 요소에 동일한 함수 적용  
- 🔹 반환값은 iterable 객체(메모리 효율적)

```python
map(func, iterable)
```

### filter

- 🔹 iterable의 각 요소에 대해 함수가 True인 값만 반환

```python
filter(func, iterable)
```

### enumerate

- 🔹 반복 가능한 객체를 순회할 때 **인덱스와 값**을 동시에 반환  
- 🔹 기본 인덱스는 0, `start`로 변경 가능

```python
for i, v in enumerate(['a', 'b', 'c'], start=1):
    print(i, v)  # 1 a, 2 b, 3 c
```

### zip

- 🔹 여러 iterable을 병렬로 묶어 튜플의 iterable로 반환  
- 🔹 가장 짧은 iterable 기준으로 동작

```python
zip(list1, list2)
```

### reduce

- 🔹 누적 함수. 두 요소씩 차례로 함수 적용해 하나의 값으로 축약  
- 🔹 functools에서 import 필요

```python
from functools import reduce
reduce(lambda x, y: x + y, range(1, 11))  # 1~10 합
```

## Generator ⚡

- `yield`를 사용해 **필요할 때마다 하나씩 값 생성**
- 전체 데이터를 한 번에 메모리에 올리지 않아 효율적 (lazy evaluation)

```python
def generate_squares():
    for x in range(10):
        yield x * x

squares = generate_squares()
print(next(squares))  # 0
print(next(squares))  # 1
```

## 파일 입출력 📂

### 파일 열기/닫기

```python
with open('filename', 'r') as f:
    # 파일 작업
# with 블록 종료 시 자동 close

# 또는
f = open('filename', 'r')
# 파일 작업
f.close()
```

### 파일 읽기

- 📖 `read()`: 전체 내용 반환
- 📖 `readline()`: 한 줄씩 반환
- 📖 `readlines()`: 각 줄을 리스트로 반환

### 파일 쓰기

- ✏️ `write("문자열")`
- ✏️ `writelines(["문자열1", "문자열2"])`
- ✏️ `print("내용", file=f)`

> 파일에 쓴 내용은 flush() 또는 close() 시 실제 반영

## 문자열 다루기 💬

### 대소문자 변환

| 메서드         | 설명                                | 예시                        |
| -------------- | ----------------------------------- | --------------------------- |
| `upper()`      | 대문자 변환                         | `"abc".upper()` → `"ABC"`   |
| `lower()`      | 소문자 변환                         | `"ABC".lower()" → "abc"`    |
| `capitalize()` | 첫 글자만 대문자                    | `"hello world".capitalize()`|
| `title()`      | 각 단어 첫 글자 대문자              | `"hello world".title()`     |
| `swapcase()`   | 대소문자 반전                       | `"AbC".swapcase()`          |

### 검색/개수 세기

| 메서드         | 설명                                | 예시                        |
| -------------- | ----------------------------------- | --------------------------- |
| `find(sub)`    | 부분 문자열 첫 인덱스(-1 없으면)     | `"apple".find("p")`         |
| `rfind(sub)`   | 오른쪽부터 첫 인덱스                | `"apple".rfind("p")`        |
| `count(sub)`   | 부분 문자열 등장 횟수                | `"apple".count("p")`        |

### 변경/치환

| 메서드         | 설명                                | 예시                        |
| -------------- | ----------------------------------- | --------------------------- |
| `replace(a,b)` | a를 b로 모두 치환                   | `"aabb".replace("a","c")`   |
| `strip()`      | 양쪽 공백 제거                      | `" abc ".strip()`           |
| `lstrip()`     | 왼쪽 공백 제거                      | `" abc ".lstrip()`          |
| `rstrip()`     | 오른쪽 공백 제거                    | `" abc ".rstrip()`          |

### 분리/결합

| 메서드         | 설명                                | 예시                        |
| -------------- | ----------------------------------- | --------------------------- |
| `split(sep)`   | sep 기준 분리, 리스트 반환           | `"a,b,c".split(",")`        |
| `splitlines()` | 줄바꿈 기준 분리, 리스트 반환        | `"a\nb".splitlines()`       |
| `join(iter)`   | iterable 요소 문자열로 결합          | `",".join(['a','b'])`       |

### 기타

| 메서드           | 설명                              | 예시                          |
| ---------------- | --------------------------------- | ----------------------------- |
| `len(s)`         | 문자열 길이 반환                  | `len("abc")`                  |
| `startswith()`   | 접두사로 시작 여부                | `"hello".startswith("he")`    |
| `endswith()`     | 접미사로 끝나는지                 | `"hello".endswith("lo")`      |
| `isalpha()`      | 알파벳만으로 구성 여부            | `"abc".isalpha()`             |
| `isdigit()`      | 숫자만으로 구성 여부              | `"123".isdigit()"             |
| `isalnum()`      | 알파벳/숫자만으로 구성 여부       | `"abc123".isalnum()`          |

## Collections 모듈 📦

파이썬 내장 자료형을 확장한 **특수 컨테이너** 제공 (집계, 큐/스택, 순서 보존, 기본값 등).

| 클래스/함수         | 설명                                   | 대표 메서드/특징                  |
| ------------------- | -------------------------------------- | ---------------------------------- |
| `namedtuple()`      | 이름 붙은 필드의 튜플                   | `_fields`, `_asdict()`, `_replace()`|
| `deque`             | 양쪽 끝에서 빠른 추가/삭제              | `append()`, `appendleft()`, `pop()`|
| `Counter`           | 해시 가능한 객체 개수 셈                | `most_common()`, `elements()`      |
| `OrderedDict`       | 삽입 순서 기억 딕셔너리                 | `move_to_end()`, `popitem()`       |
| `defaultdict`       | 기본값 지정 가능한 딕셔너리             | `default_factory`                  |
| `ChainMap`          | 여러 딕셔너리 묶어 하나의 뷰 제공       | `maps`, `new_child()`, `parents`   |
| `UserDict` 등       | 내장 자료형 래퍼, 상속/커스터마이징 용  |                                   |

**Counter 예시**

```python
from collections import Counter
c = Counter('banana')
print(c)  # Counter({'a': 3, 'n': 2, 'b': 1})
print(c.most_common(1))  # [('a', 3)]
```

## 정규식(re) 모듈 🔍

정규표현식은 문자열에서 패턴을 찾거나, 치환, 분리 등에 사용합니다.

### 주요 함수

| 함수/메서드         | 설명                                      | 예시 코드/결과                      |
| ------------------- | ----------------------------------------- | -------------------------------------|
| `re.match()`        | 문자열 **시작**에서 패턴 일치              | `re.match(r'\d+', '123abc')`         |
| `re.search()`       | 전체에서 패턴 **처음 등장** 위치 검색       | `re.search(r'\d+', 'abc123')`        |
| `re.findall()`      | 패턴에 **모두 일치**하는 부분 리스트 반환   | `re.findall(r'\d+', 'a1b22c333')`    |
| `re.finditer()`     | 모두 일치하는 부분을 **이터레이터**로 반환  | `for m in re.finditer(r'\d+', ...)`  |
| `re.split()`        | 패턴 기준 분리, 리스트 반환                 | `re.split(r'\s+', 'a b c')`          |
| `re.sub()`          | 패턴 일치 부분을 **치환**                  | `re.sub(r'\d+', '#', 'a1b22c')`      |

### 주요 메타문자

| 메타문자 | 의미                              |
| -------- | --------------------------------- |
| `.`      | 임의의 한 문자                    |
| `*`      | 앞 문자가 0회 이상 반복           |
| `+`      | 앞 문자가 1회 이상 반복           |
| `?`      | 앞 문자가 0회 또는 1회 등장       |
| `[]`     | 대괄호 안 문자 중 하나와 일치      |
| `()`     | 그룹화 및 추출                    |
| `^`      | 문자열의 시작                     |
| `$`      | 문자열의 끝                       |

```python
[a-zA-Z가-힣]  # 모든 영어, 한글
^[], [^]       
# ~로 시작하는 것, [] 안에 없는 것 찾기
```
- 정규식 패턴 찾기 사이트: https://regex101.com/

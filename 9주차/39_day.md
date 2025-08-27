# 🤖 PyCaret으로 다중 분류기 만들기

AutoML(자동화 머신러닝) 라이브러리인 `PyCaret`을 사용해봤다. 단 몇 줄의 코드로 전체 머신러닝 워크플로우를 자동화할 수 있었다.

## 🎯 목차
1.  [PyCaret, 너는 누구냐?](#1-pycaret-너는-누구냐-🤔)
2.  [PyCaret 핵심 워크플로우 5단계](#2-pycaret-핵심-워크플로우-5단계-🚀)
3.  [1단계: 실험 준비 (setup)](#3-1단계-실험-준비-setup-⚙️)
4.  [2단계: 모든 모델 비교 (compare_models)](#4-2단계-모든-모델-비교-compare_models-📊)
5.  [3단계: 모델 생성 및 튜닝 (create & tune)](#5-3단계-모델-생성-및-튜닝-create--tune-🛠️)
6.  [4단계: 모델 분석 및 예측 (analyze & predict)](#6-4단계-모델-분석-및-예측-analyze--predict-📈)
7.  [5단계: 모델 저장 및 배포 (save & deploy)](#7-5단계-모델-저장-및-배포-save--deploy-💾)
8.  [최종 정리 및 회고](#8-최종-정리-및-회고-✍️)

---

## 1. PyCaret, 너는 누구냐? 🤔

PyCaret은 Scikit-learn, XGBoost 등 여러 머신러닝 라이브러리를 감싸서 아주 쉽게 사용할 수 있게 만든 **로우코드(low-code) 라이브러리**다. 데이터 전처리, 모델 학습, 튜닝, 평가, 배포까지 모든 과정을 자동화하여, 분석가가 모델링 자체에 더 집중할 수 있게 도와준다.

## 2. PyCaret 핵심 워크플로우 5단계 🚀

PyCaret의 작업은 간단한 5단계로 요약된다.

**Setup ➡️ Compare Models ➡️ Analyze Model ➡️ Prediction ➡️ Save Model**

이 흐름만 따라가면 누구나 모델을 만들 수 있다.

## 3. 1단계: 실험 준비 (setup) ⚙️

모든 작업의 시작. `setup` 함수 하나로 모든 게 준비된다.

```python
from pycaret.classification import *
from pycaret.datasets import get_data

# 붓꽃(iris) 데이터 불러오기
data = get_data('iris')

# 실험 환경 설정
s = setup(data, target = 'species', session_id = 123)
```

이 함수는 데이터를 분석해서 자동으로 전처리 파이프라인을 만들어준다. 예를 들어, 결측치 처리, 범주형 데이터 인코딩, 데이터 분할 등을 알아서 다 해준다. 여기서 시간을 엄청나게 아낄 수 있다.

## 4. 2단계: 모든 모델 비교 (compare_models) 📊

PyCaret의 꽃이라고 할 수 있는 기능이다. 수십 개의 모델을 한 번에 학습하고, 교차 검증을 통해 성능을 비교해서 표로 보여준다.

```python
# 모든 모델을 비교하고 성능이 가장 좋은 모델을 반환
best = compare_models()
```

이 기능 덕분에 어떤 모델이 내 데이터에 가장 적합한지 빠르게 파악하고 시작할 수 있다.

## 5. 3단계: 모델 생성 및 튜닝 (create & tune) 🛠️

`compare_models`로 찾은 최고의 모델이나, 내가 원하는 특정 모델을 골라 더 깊게 파고들 수 있다.

```python
# 의사결정 나무 모델 생성
dt = create_model('dt')

# 의사결정 나무 모델 하이퍼파라미터 튜닝
tuned_dt = tune_model(dt)
```

-   `create_model()`: 특정 모델을 지정하여 교차 검증 결과와 함께 학습시킨다.
-   `tune_model()`: RandomizedSearchCV를 기반으로 최적의 하이퍼파라미터를 찾아 모델 성능을 극대화한다. Optuna 같은 다른 튜닝 라이브러리도 지정할 수 있어 확장성도 좋았다.

## 6. 4단계: 모델 분석 및 예측 (analyze & predict) 📈

모델을 만들고 끝이 아니다. PyCaret은 모델을 시각적으로 분석할 수 있는 강력한 도구들을 제공한다.

```python
# 혼동 행렬(Confusion Matrix) 그리기
plot_model(best, plot = 'confusion_matrix')

# 피처 중요도 확인
plot_model(best, plot = 'feature')

# SHAP를 이용한 모델 해석
interpret_model(lightgbm, plot = 'summary')
```

-   `plot_model()`: AUC, 혼동 행렬, 피처 중요도 등 15가지가 넘는 플롯을 그려 모델을 다각도로 분석할 수 있다.
-   `evaluate_model()`: 대시보드 형태로 모델의 성능을 인터랙티브하게 탐색할 수 있다.
-   `predict_model()`: 테스트 데이터나 새로운 데이터에 대한 예측을 쉽게 수행할 수 있다.

## 7. 5단계: 모델 저장 및 배포 (save & deploy) 💾

잘 만든 모델은 저장하고, 실제 서비스에 배포할 준비까지 할 수 있다.

```python
# 모델(파이프라인 전체) 저장
save_model(best, 'my_best_pipeline')

# API 생성
create_api(tuned_dt, api_name = 'my_iris_api')

# Dockerfile 생성
create_docker('my_iris_api')
```

-   `save_model()`: 전처리 과정까지 포함된 전체 파이프라인을 피클 파일로 저장한다.
-   `create_api()`: 모델을 서빙할 수 있는 FastAPI 코드를 자동으로 생성해준다.
-   `create_docker()`: 생성된 API를 컨테이너 환경에서 실행할 수 있도록 Dockerfile까지 만들어준다. MLOps의 시작을 이렇게 쉽게 할 수 있다는 점이 놀라웠다.

## 8. 최종 정리 및 회고 ✍️

- `compare_models()`로 모든 모델의 성능을 한눈에 비교하고 시작하는 접근법은 시간을 극적으로 단축시켜 주었다. 
- 모델의 성능 분석부터 API, Dockerfile 생성까지 PyCaret을 이용햇 생성할 수 있었다. 앞으로 머신러닝 프로젝트를 시작할 때, 
- 앞으로 PyCaret으로 빠르게 프로토타입을 만들고 데이터에 맞는 유망한 모델을 탐색할 수 있을 것 같다

# 🚀 지도학습 - 회귀 분석 (Regression Analysis)

## 🎯 목차
- [지도학습 - 회귀 분석 (Regression Analysis)](#-지도학습---회귀-분석-regression-analysis)
- [참고 : 선형 모델(Linear Models)](#-참고--선형-모델linear-models)
- [1. 데이터 생성 및 단순 회귀 🚀](#1-데이터-생성-및-단순-회귀-)
- [2. 회귀 모델 평가 지표 🧐](#2-회귀-모델-평가-지표-)
- [3. 캘리포니아 주택 가격 예측 실습 🏠](#3-캘리포니아-주택-가격-예측-실습-)
  - [데이터 로드 및 탐색](#데이터-로드-및-탐색)
  - [실험 1: Baseline 모델](#실험-1-baseline-모델)
  - [실험 2: Scaling](#실험-2-scaling)
  - [실험 3: Feature Selection](#실험-3-feature-selection)
  - [실험 4: 규제가 있는 모델 (Ridge, Lasso)](#실험-4-규제가-있는-모델-ridge-lasso)
  - [실험 5: AutoML (PyCaret)](#실험-5-automl-pycaret)
  - [실험 6: AutoML (Optuna)](#실험-6-automl-optuna)
- [✍️ 요약 정리](#️-요약-정리)

---

관찰된 **연속형 변수**들에 대해 두 변수 사이의 모형을 구한뒤 적합도를 측정해 내는 분석 방법이다.

- **단순회귀분석 (Simple Regression Analysis)**
    - 하나의 종속변수와 하나의 독립변수 사이의 관계를 분석한다.
    - `wx + b = yhat`

- **다중회귀분석 (Multiple Regression Analysis)**
   - 하나의 종속변수와 여러 독립변수 사이의 관계를 규명하고자 할 경우 사용한다.
   - `w1x1 + w2x2 + w3x3 + .... + b = yhat`

**예시**
- 주택 가격 예측
- 매출액 예측
- 주가 예측
- 온도 예측

**대표 회귀 모델:**
- 최소제곱법(Ordinary Least Squares)을 활용한 `LinearRegression`
- 경사하강법(Gradient Descent)을 활용한 `SGDRegressor`
- 선형 회귀 모델에 L1, L2 규제를 더한 `Ridge`(제곱), `Lasso`(절대값), `ElasticNet`(상호보완) 등

> **대조**: 분류(Classification)는 주어진 특성에 따라 어떤 대상을 유한한 범주(타깃값)으로 구분하는 방법으로, 범주형 데이터를 다룬다.

---

### 🧠 참고 : 선형 모델(Linear Models)

선형 모델은 입력 데이터에 대한 선형 함수를 만들어 예측을 수행한다. 회귀 분석을 위한 선형 모델은 다음과 같이 정의된다.

$$ \hat{y}(w,x) = w_0 + w_1 x_1 + ... + w_p x_p $$

- $x$: 입력 데이터
- $w$: 모델이 학습할 파라미터
- $w_0$: 편향 (bias)
- $w_1$~$w_p$: 가중치 (weights)

<img src="https://t1.daumcdn.net/cfile/tistory/997E924F5CDBC1A628" alt="Linear Model">

> 출처: https://walkingwithus.tistory.com/606

**선형 회귀분석의 4가지 기본 가정**
- **선형성**: 예측하고자 하는 종속변수 y와 독립변수 x 간에 선형성을 만족해야 한다.
- **독립성**: 독립변수 x 간에 상관관계 없이 독립성을 만족해야 한다 (다중회귀 시).
- **등분산성**: 오차의 분산이 일정해야 한다. 즉, 특정한 패턴 없이 고르게 분포해야 한다.
- **정규성**: 잔차(예측치와 실제치의 차이)가 정규분포를 따라야 한다.

![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fc2F0oL%2FbtqFrUmcmlD%2FVjSZQF79ZksxaEj8Whmcz0%2Fimg.png)
![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fb3hByu%2FbtqFtIZDYBM%2FJDksb4QoJfgyy5BLFRRG4k%2Fimg.png)

---

## 1. 데이터 생성 및 단순 회귀 🚀

`y = 2x + 5` 식을 기반으로 임의의 노이즈를 추가하여 데이터를 생성하고, `LinearRegression` 모델로 회귀선을 찾아보았다.

```python
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression

np.random.seed(0)
w1 = 2  # x의 계수
w0 = 5  # 편향 (y절편)

# 0~4 사이의 실수값 100개 생성
x = np.random.rand(100, 1) * 4 
# 노이즈 추가
noise = np.random.rand(100, 1) * 2
y = w1 * x + w0 + noise

# 모델 생성 및 학습
li_model = LinearRegression()
li_model.fit(x, y)

# 예측
y_pred = li_model.predict(x)

# 결과 시각화
plt.scatter(x, y, label='Actual Data')
plt.plot(x, y_pred, color='red', label='Regression Line')
plt.legend()
plt.show()

# 학습된 계수 및 절편 확인
print(f"Rank: {li_model.rank_}")
print(f"Intercept (b): {li_model.intercept_}")
print(f"Coefficient (w): {li_model.coef_}")
print(f"R2 Score: {li_model.score(x, y)}")
```

---

## 2. 회귀 모델 평가 지표 🧐

분류 모델과 달리, 회귀 모델은 연속형 변수를 예측하므로 다른 평가 지표를 사용한다.

```python
import numpy as np
import pandas as pd
from sklearn.metrics import r2_score, mean_squared_error, root_mean_squared_error, mean_absolute_error, mean_absolute_percentage_error

np.random.seed(20)

# 테스트용 데이터 생성
y_true = np.random.randint(low=1, high=999, size=700)
y_pred = y_true + np.round(np.random.random(700), decimals=1) * np.random.randint(low=-10, high=10, size=700)
```

### R² Score (결정계수)
- 실제 값의 분산 대비 예측 값의 분산 비율을 나타낸다.
- 1에 가까울수록 좋은 모델이며, 0에 가깝거나 음수이면 모델이 잘못되었음을 의미한다.
- `1 - (sum(((y_true - y_pred)**2)) / sum((y_true - y_true.mean())**2))`
```python
print(f"R2 Score: {r2_score(y_true, y_pred)}")
```

### MSE (Mean Squared Error)
- 예측 값과 실제 값의 차이를 제곱하여 평균을 낸 값이다.
- 오차의 크기를 나타내며 작을수록 좋다.
- $$ MSE = \frac{1}{n}\sum_{i=1}^{n}(Y_{i}-\hat{Y}_{i})^2 $$
```python
print(f"MSE: {mean_squared_error(y_true, y_pred)}")
```

### RMSE (Root Mean Squared Error)
- MSE에 루트를 씌운 값으로, MSE의 단점을 보완하고 값의 왜곡을 줄여준다.
```python
print(f"RMSE: {root_mean_squared_error(y_true, y_pred)}")
```

### MAE (Mean Absolute Error)
- 예측값과 실제값의 차이에 대한 절대값의 평균이다.
- 스케일에 의존적이라는 단점이 있다.
- $$ MAE = \frac{1}{n}\sum_{i=1}^{n}\left|Y_{i}-\hat{Y}_{i}\right| $$
```python
print(f"MAE: {mean_absolute_error(y_true, y_pred)}")
```

### MAPE (Mean Absolute Percentage Error)
- 오차를 백분율로 변환하여 스케일이 다른 데이터셋 간의 성능 비교에 유용하다.
- $$ \text{MAPE} = \frac{100\%}{n}\sum_{t=1}^{n}\left|\frac{A_t - F_t}{A_t}\right| $$
```python
# 예시 데이터
실제_아파트_가격 = np.array([1000000, 2000000])
예측_아파트_가격 = np.array([999900, 2000100])
실제_과일_가격= np.array([500, 1000])
예측_과일_가격 = np.array([400, 1100])

print(f"아파트 MAPE: {mean_absolute_percentage_error(실제_아파트_가격, 예측_아파트_가격)}")
print(f"과일 MAPE: {mean_absolute_percentage_error(실제_과일_가격, 예측_과일_가격)}")
```

---

## 3. 캘리포니아 주택 가격 예측 실습 🏠

1990년대 캘리포니아 주택 가격 데이터를 사용하여 회귀 모델의 성능을 개선해보았다.

### 데이터 로드 및 탐색

```python
import pandas as pd
from sklearn.datasets import fetch_california_housing

# 데이터 불러오기
housing = fetch_california_housing()
X = pd.DataFrame(housing.data, columns=housing.feature_names)
y = pd.Series(housing.target, name='MedHouseVal')

caliDF = pd.concat([X, y], axis=1)
print(caliDF.corr()['MedHouseVal'].sort_values())
```

### 실험 1: Baseline 모델

전처리 없이 `LinearRegression` 모델을 적용했다.

```python
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import root_mean_squared_error

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=121)

li_model = LinearRegression()
li_model.fit(X_train, y_train)

y_pred = li_model.predict(X_test)

print(f"R2 Score: {li_model.score(X_test, y_test)}")
print(f"RMSE: {root_mean_squared_error(y_test, y_pred)}")

# 결과
# R2 Score: 0.6217862024682844
# RMSE: 0.7085757875825902
```

### 실험 2: Scaling

`RobustScaler`를 사용하여 특성 스케일링을 적용했다.

```python
from sklearn.preprocessing import RobustScaler

# 데이터 분할
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=121)

# 스케일링
scaler = RobustScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# 모델 학습 및 평가
li_model.fit(X_train_scaled, y_train)
y_pred = li_model.predict(X_test_scaled)

print(f"R2 Score (RobustScaler): {li_model.score(X_test_scaled, y_test)}")
print(f"RMSE (RobustScaler): {root_mean_squared_error(y_test, y_pred)}")

# 결과 (LinearRegression의 경우 Scaling의 영향이 거의 없음)
# R2 Score (RobustScaler): 0.6217862024682844
# RMSE (RobustScaler): 0.7085757875825902
```

### 실험 3: Feature Selection

`SequentialFeatureSelector` (SFS)를 사용하여 주요 특성을 선택했다.

```python
from sklearn.feature_selection import SequentialFeatureSelector

li_model = LinearRegression()
sfs = SequentialFeatureSelector(li_model, n_features_to_select=5, direction='forward')
sfs.fit(X, y)

selected_features = list(sfs.get_feature_names_out())
print(f"Selected Features: {selected_features}")

# 선택된 특성으로 재학습
X_selected = X[selected_features]
X_train, X_test, y_train, y_test = train_test_split(X_selected, y, test_size=0.2, random_state=121)

li_model.fit(X_train, y_train)
y_pred = li_model.predict(X_test)

print(f"R2 Score (SFS): {li_model.score(X_test, y_test)}")
print(f"RMSE (SFS): {root_mean_squared_error(y_test, y_pred)}")

# 결과 (SFS 5개 선정)
# R2 Score (SFS): 0.5522249378982188
# RMSE (SFS): 0.7709879235212429
```

### 실험 4: 규제가 있는 모델 (Ridge, Lasso)

과적합을 방지하기 위해 L1(Lasso), L2(Ridge) 규제를 적용했다.

```python
from sklearn.linear_model import Ridge, Lasso
from sklearn.model_selection import RandomizedSearchCV
from scipy import stats

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=121)

param_dist = {"alpha": stats.reciprocal(1e-1, 1e1)}

# Ridge
ridge = Ridge()
ri_model_search = RandomizedSearchCV(ridge, param_distributions=param_dist, n_iter=70, scoring="neg_root_mean_squared_error", cv=5, random_state=42)
ri_model_search.fit(X_train, y_train)
ri_model = ri_model_search.best_estimator_
y_pred_ridge = ri_model.predict(X_test)

# Lasso
lasso = Lasso()
la_model_search = RandomizedSearchCV(lasso, param_distributions=param_dist, n_iter=70, scoring="neg_root_mean_squared_error", cv=5, random_state=42)
la_model_search.fit(X_train, y_train)
la_model = la_model_search.best_estimator_
y_pred_lasso = la_model.predict(X_test)

print(f"Ridge Best Alpha: {ri_model.alpha}")
print(f"Lasso Best Alpha: {la_model.alpha}")
print(f"Ridge R2: {ri_model.score(X_test, y_test)}")
print(f"Lasso R2: {la_model.score(X_test, y_test)}")
print(f"Ridge RMSE: {root_mean_squared_error(y_test, y_pred_ridge)}")
print(f"Lasso RMSE: {root_mean_squared_error(y_test, y_pred_lasso)}")

# 결과
# Ridge R2: 0.6209...
# Lasso R2: 0.6117...
```

### 실험 5: AutoML (PyCaret)

PyCaret을 사용하여 여러 모델을 자동으로 비교하고 최적의 모델을 찾았다.

```python
# !pip install pycaret
from pycaret.regression import *

# 데이터 준비
s = setup(caliDF, target='MedHouseVal', session_id=123, preprocess=False, verbose=False)

# 모델 비교
best_model = compare_models()
print(best_model)

# 모델 생성 및 평가
# 예: catboost = create_model('catboost')
# evaluate_model(catboost)
```

### 실험 6: AutoML (Optuna)

Optuna를 사용하여 `ExtraTreesRegressor` 모델의 하이퍼파라미터를 최적화했다.

```python
# !pip install optuna
import optuna
from sklearn.ensemble import ExtraTreesRegressor

def objective(trial):
    # 하이퍼파라미터 탐색 범위 설정
    n_estimators = trial.suggest_int('n_estimators', 50, 200)
    max_depth = trial.suggest_int('max_depth', 5, 50)
    min_samples_split = trial.suggest_int('min_samples_split', 2, 10)

    # 모델 생성 및 훈련
    model = ExtraTreesRegressor(n_estimators=n_estimators,
                                  max_depth=max_depth,
                                  min_samples_split=min_samples_split,
                                  random_state=42)
    model.fit(X_train, y_train)

    # 예측 및 성능 평가
    y_pred = model.predict(X_test)
    rmse = root_mean_squared_error(y_test, y_pred)
    return rmse

# 최적화 실행
study = optuna.create_study(direction='minimize')
study.optimize(objective, n_trials=30)

print(f'Best parameters: {study.best_params}')
print(f'Best RMSE: {study.best_value}')
```

---

### ✍️ 요약 정리
회귀 분석은 연속적인 값을 예측하는 지도학습 방법이다. 모델의 성능은 R², RMSE 등 다양한 지표로 평가하며, 단순히 하나의 지표만 보는 것은 위험하다. 캘리포니아 주택 가격 예측 실습을 통해 스케일링, 특성 선택, 규제(Ridge, Lasso), AutoML 등 다양한 기법으로 모델의 성능을 점진적으로 개선해나가는 과정을 학습했다. 특히 규제는 다중공선성 문제를 해결하고 과적합을 방지하는 데 효과적이었다.

```
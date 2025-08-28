# 🗺️ 비지도 학습과 PCA

## 🎯 목차
1. [차원의 저주 (The Curse of Dimensionality)](#1-🧐-차원의-저주-the-curse-of-dimensionality)
2. [주성분 분석 (Principal Component Analysis, PCA)](#2-🧠-주성분-분석-principal-component-analysis-pca)
3. [PCA 실습: 와인 데이터셋](#3-🚀-pca-실습-와인-데이터셋)
4. [요약 정리](#4-✍️-요약-정리)

---

## 1. 🧐 차원의 저주 (The Curse of Dimensionality)

- 딥러닝에서 층을 깊게 쌓아 차원이 커지면, 더 복잡한 특징을 학습하여 성능이 향상될 것으로 기대했다. 하지만 실제로는 차원이 일정 수준 이상으로 커지면 학습 데이터의 수가 차원의 수보다 부족해져 성능이 저하되는 현상이 발생했다.
- 차원이 증가할수록 각 차원 내에서 학습할 데이터의 수가 줄어드는 **희소(sparse) 현상**이 발생한다.
- 이는 학습이 제대로 이루어지지 않는 원인이 되며, 연산량 또한 기하급수적으로 증가시켜 효율성을 떨어뜨린다.

**해결책:**
- 차원을 축소한다.
- 데이터를 더 많이 확보한다.

![Curse of Dimensionality](https://images.deepai.org/glossary-terms/curse-of-dimensionality-61461.jpg)

---

## 2. 🧠 주성분 분석 (Principal Component Analysis, PCA)

- 가장 널리 사용되는 **차원 축소 기법** 중 하나다.
- 원 데이터의 분포를 최대한 보존하면서 고차원 데이터를 저차원 공간으로 변환한다.
- 여러 변수 간의 상관관계를 이용하여, 이를 대표하는 **주성분(Principal Component)** 을 추출하여 차원을 축소한다. 이 과정에서 정보 유실을 최소화한다.

![PCA](https://t1.daumcdn.net/cfile/tistory/99CB343359F2DA5E07)

### PCA의 원리

- 선형대수 관점에서 PCA는 입력 데이터의 **공분산 행렬(Covariance Matrix)** 을 **고유값 분해(Eigenvalue Decomposition)** 하는 것과 같다.
- 이때 얻어지는 **고유벡터(Eigenvector)** 가 PCA의 주성분 벡터가 되며, 이는 데이터의 분산이 가장 큰 방향을 나타낸다.

### PCA 수행 단계

1.  학습 데이터셋에서 **분산이 최대인 축**을 찾는다.
2.  첫 번째 축과 **직교(orthogonal)** 하면서 분산이 최대인 두 번째 축을 찾는다.
3.  이전 축들과 직교하면서 분산을 최대한 보존하는 다음 축을 찾는다.
4.  데이터셋의 차원(특성 수)만큼의 축을 찾을 때까지 이 과정을 반복한다.

> **추천 참고 자료:** [PCA, 제대로 이해하기](https://angeloyeo.github.io/2019/07/27/PCA.html)

---

## 3. 🚀 PCA 실습: 와인 데이터셋

### 데이터 준비 및 스케일링

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.datasets import load_wine
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

# 데이터 로드
wine = load_wine()
wine_df = pd.DataFrame(data=wine.data, columns=wine.feature_names)
wine_df['target'] = wine.target

# 데이터와 타겟 분리
X = wine_df.drop('target', axis=1)
y = wine_df['target']

# 데이터 스케일링
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)
```

### PCA 적용 및 시각화

```python
from sklearn.decomposition import PCA

# PCA 모델 생성 (2차원으로 축소)
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X_scaled)

# PCA 결과 시각화
plt.figure(figsize=(8, 6))
for i in range(len(wine.target_names)):
    plt.scatter(X_pca[y == i, 0], X_pca[y == i, 1], label=wine.target_names[i])

plt.title('PCA of Wine Dataset')
plt.xlabel('Principal Component 1')
plt.ylabel('Principal Component 2')
plt.legend()
plt.grid(True)
plt.show()
```

### 설명된 분산 (Explained Variance)

```python
# 각 주성분이 설명하는 분산의 비율
print("Explained variance ratio:", pca.explained_variance_ratio_)
# [0.36198848 0.1920749 ]

# 두 주성분으로 설명되는 총 분산
print("Sum of explained variance ratio:", np.sum(pca.explained_variance_ratio_))
# 0.5540633847175112
```
- 첫 번째 주성분(PC1)은 약 36.2%의 분산을, 두 번째 주성분(PC2)은 약 19.2%의 분산을 설명했다.
- 2개의 주성분만으로 전체 데이터 분산의 약 55.4%를 설명할 수 있었다.

### 원본 데이터와 PCA 변환 데이터의 분류 성능 비교

#### 로지스틱 회귀

```python
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

# 원본 데이터로 학습
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.3, random_state=42)
lr_original = LogisticRegression()
lr_original.fit(X_train, y_train)
pred_original = lr_original.predict(X_test)
acc_original = accuracy_score(y_test, pred_original)
print(f"원본 데이터 정확도: {acc_original:.4f}") # 1.0000

# PCA 데이터로 학습
X_train_pca, X_test_pca, y_train_pca, y_test_pca = train_test_split(X_pca, y, test_size=0.3, random_state=42)
lr_pca = LogisticRegression()
lr_pca.fit(X_train_pca, y_train_pca)
pred_pca = lr_pca.predict(X_test_pca)
acc_pca = accuracy_score(y_test_pca, pred_pca)
print(f"PCA 변환 데이터 정확도: {acc_pca:.4f}") # 0.9815
```
- **결과:** 13개의 특성을 모두 사용했을 때 정확도는 1.0이었지만, 2개의 주성분만 사용했을 때도 약 0.98의 높은 정확도를 보였다. 차원을 크게 줄였음에도 성능 저하가 거의 없음을 확인했다.

#### 결정 트리

```python
from sklearn.tree import DecisionTreeClassifier

# 원본 데이터로 학습
dt_original = DecisionTreeClassifier(random_state=42)
dt_original.fit(X_train, y_train)
pred_original_dt = dt_original.predict(X_test)
acc_original_dt = accuracy_score(y_test, pred_original_dt)
print(f"원본 데이터 정확도 (DT): {acc_original_dt:.4f}") # 0.9444

# PCA 데이터로 학습
dt_pca = DecisionTreeClassifier(random_state=42)
dt_pca.fit(X_train_pca, y_train_pca)
pred_pca_dt = dt_pca.predict(X_test_pca)
acc_pca_dt = accuracy_score(y_test_pca, pred_pca_dt)
print(f"PCA 변환 데이터 정확도 (DT): {acc_pca_dt:.4f}") # 0.9259
```
- **결과:** 결정 트리 모델에서도 PCA를 통해 차원을 축소한 데이터가 원본 데이터와 유사한 수준의 정확도를 유지하는 것을 볼 수 있었다.

---

## 4. ✍️ 요약 정리

- **차원의 저주**는 고차원 데이터에서 발생하는 희소성 문제로, 모델 성능 저하의 원인이 된다.
- **PCA**는 데이터의 분산을 최대한 보존하는 주성분을 추출하여 효과적으로 차원을 축소하는 기법이다.
- 와인 데이터셋 실습 결과, 13개 특성을 단 2개의 주성분으로 줄였음에도 분류 모델의 정확도가 거의 유지되어 PCA의 효율성을 확인했다.

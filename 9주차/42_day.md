# 🫂 K-평균(K-Means) 군집화 알고리즘

## 목차
1.  [K-평균(K-Means) 알고리즘 개요](#1-k-평균k-means-알고리즘-개요)
2.  [K-평균 vs. K-NN](#2-k-평균-vs-k-nn)
3.  [K-평균 알고리즘 동작 방식](#3-k-평균-알고리즘-동작-방식)
4.  [Scikit-learn을 이용한 K-평균 구현](#4-scikit-learn을-이용한-k-평균-구현)
5.  [최적의 클러스터 개수(K) 찾기: 엘보우 기법](#5-최적의-클러스터-개수k-찾기-엘보우-기법)
6.  [K-평균 알고리즘의 장단점](#6-k-평균-알고리즘의-장단점)
7.  [성능 향상을 위한 기법](#7-성능-향상을-위한-기법)
8.  [군집화 성능 평가](#8-군집화-성능-평가)
9.  [밀도 기반 클러스터링: DBSCAN](#9-밀도-기반-클러스터링-dbscan)

---

### 1. K-평균(K-Means) 알고리즘 개요

-   **비지도 학습(Unsupervised Learning)**: 정답(레이블)이 없는 데이터를 그룹으로 묶는 **군집화(Clustering)** 알고리즘이다.
-   **목표**: 주어진 데이터를 **K개의 군집(Cluster)**으로 묶어, 군집 내 데이터들의 유사성은 최대화하고 군집 간의 유사성은 최소화하는 것이다. ✨

    ![](https://stanford.edu/~cpiech/cs221/img/kmeansViz.png)

### 2. K-평균 vs. K-NN

| 구분 | K-평균 (K-Means) | K-최근접 이웃 (K-NN) |
| :--- | :--- | :--- |
| **학습 방식** | 비지도학습 (Clustering) | 지도학습 (Classification) |
| **목표** | 레이블 없는 데이터를 K개의 군집으로 나눔 | 새 데이터의 클래스를 K개의 이웃을 통해 결정 |
| **공통점** | K개의 점을 지정하고, 거리를 기반으로 동작하는 알고리즘 |

### 3. K-평균 알고리즘 동작 방식

K-평균은 중심점(Centroid)을 이동시켜가며 최적의 군집을 형성한다.

1.  **초기화**: K개의 중심점(Centroid)을 임의의 위치에 배치한다.
2.  **군집 할당**: 각 데이터 포인트를 가장 가까운 중심점에 할당한다.
3.  **중심점 업데이트**: 각 군집의 중심으로 중심점을 이동시킨다.
4.  **반복**: 중심점이 더 이상 이동하지 않을 때(수렴)까지 2, 3번 과정을 반복한다. 이 과정이 끝나면 최적의 군집이 만들어진다! 🎉

### 4. Scikit-learn을 이용한 K-평균 구현

붓꽃(Iris) 데이터셋을 사용하여 K-평균 군집화를 실습했다.

#### 4.1. 라이브러리 및 데이터 준비

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris
from sklearn.cluster import KMeans

# 데이터 로드
iris = load_iris()
irisDF = pd.DataFrame(iris.data, columns=iris.feature_names)
```

#### 4.2. K-평균 모델 학습

`n_clusters` 파라미터로 군집의 개수(K)를 지정했다.

```python
# K=3으로 설정하여 KMeans 객체 생성
kmeans = KMeans(n_clusters=3, random_state=121)

# 모델 학습
kmeans.fit(irisDF)

# 각 데이터 포인트가 속한 군집 레이블 확인
print(kmeans.labels_)
```

#### 4.3. 주요 속성

-   `cluster_centers_`: 각 군집의 중심점 좌표
-   `inertia_`: 관성. 클러스터 내 데이터들이 얼마나 잘 뭉쳐있는지를 나타내는 지표 (값이 작을수록 좋음)
-   `labels_`: 각 데이터 포인트가 속한 군집 레이블

```python
# 중심점 좌표 출력
print("중심점 좌표:
", kmeans.cluster_centers_)

# 관성 값 출력
print("관성(Inertia):", kmeans.inertia_)
```

> **`inertia_`** 는 클러스터 개수가 많아질수록 무조건 감소해서, 이 값만으로 좋은 군집화를 판단하기는 어렵다. 🤔

### 5. 최적의 클러스터 개수(K) 찾기: 엘보우 기법

**엘보우(Elbow) 기법**은 K값을 늘려가면서 `inertia_` 값의 변화를 관찰하여 최적의 K를 찾는 방법이다. 그래프에서 기울기가 급격히 완만해지는 지점(Elbow)을 최적의 K로 판단했다.

```python
inertias = []
K_range = range(1, 12)

for k in K_range:
    km = KMeans(n_clusters=k, random_state=121)
    km.fit(iris.data)
    inertias.append(km.inertia_)

# 그래프로 시각화
plt.plot(K_range, inertias, '-o')
plt.xlabel('Number of clusters, K')
plt.ylabel('Inertia')
plt.xticks(K_range)
plt.title('Elbow Method for Optimal K')
plt.show()
```

### 6. K-평균 알고리즘의 장단점

| 장점 | 단점 |
| :--- | :--- |
| 이해와 구현이 쉽고 직관적 | **K값을 직접 설정**해야 함 |
| 수렴성이 보장됨 | **거리 기반**이라 차원이 많아지면 복잡도 증가 |
| 대용량 데이터에 적용 가능 | **이상치(Outlier)와 스케일**에 민감함 |
| - | 초기 중심점 위치에 따라 결과가 달라질 수 있음 |

### 7. 성능 향상을 위한 기법

-   **PCA (차원 축소)**: 거리 기반 알고리즘의 계산 복잡도를 줄여주었다.
-   **스케일링 (Scaling)**: `StandardScaler` 등을 사용하여 피처의 스케일을 맞춰주니 이상치에 대한 민감도를 줄일 수 있었다. 👍

```python
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA

# 스케일링
scaler = StandardScaler()
X_scaled = scaler.fit_transform(iris.data)

# PCA로 차원 축소
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X_scaled)

# K-Means 학습
kmeans_pca = KMeans(n_clusters=3, random_state=121)
kmeans_pca.fit(X_pca)
```

### 8. 군집화 성능 평가

#### 8.1. 실루엣 계수 (Silhouette Coefficient)

-   **정답 레이블이 없는 경우** 사용했다.
-   군집 내 데이터는 얼마나 가깝고, 다른 군집과는 얼마나 멀리 떨어져 있는지를 측정하는 지표다.
-   값의 범위는 **-1에서 1 사이**이며, 1에 가까울수록 좋은 군집화로 판단했다.

```python
from sklearn.metrics import silhouette_score, silhouette_samples

# 실루엣 계수 계산 (전체 평균)
score = silhouette_score(iris.data, kmeans.labels_)
print('실루엣 점수: {0:.3f}'.format(score))
```

#### 8.2. Homogeneity, Completeness, V-measure

-   **정답 레이블이 있는 경우** 사용했다.
-   **Homogeneity (균질성)**: 각 군집이 동일한 실제 클래스로 구성된 정도 (정밀도와 유사).
-   **Completeness (완전성)**: 각 실제 클래스의 데이터들이 동일한 군집으로 구성된 정도 (재현율과 유사).
-   **V-measure**: 균질성과 완전성의 조화 평균이다.

```python
from sklearn.metrics import homogeneity_score, completeness_score, v_measure_score

# 실제값(iris.target)과 예측값(kmeans.labels_) 비교
print("균질성:", homogeneity_score(iris.target, kmeans.labels_))
print("완전성:", completeness_score(iris.target, kmeans.labels_))
print("V-measure:", v_measure_score(iris.target, kmeans.labels_))
```

### 9. 밀도 기반 클러스터링: DBSCAN

-   **DBSCAN (Density-Based Spatial Clustering of Applications with Noise)** 은 데이터가 밀집된 지역을 찾아 군집화하는 방식이다.
-   K-평균과 달리 **클러스터 개수를 미리 정할 필요가 없고**, 노이즈(이상치)를 자동으로 분류해줘서 편리했다.
-   주요 파라미터는 `eps` (이웃으로 판단하는 최대 거리)와 `min_samples` (군집을 이루는 최소 샘플 수)이다.

```python
from sklearn.cluster import DBSCAN

# DBSCAN 객체 생성 및 학습
dbscan = DBSCAN(eps=0.6, min_samples=8)
dbscan_labels = dbscan.fit_predict(iris.data)

# -1은 노이즈(이상치)로 분류된 데이터
print(np.unique(dbscan_labels, return_counts=True))
```
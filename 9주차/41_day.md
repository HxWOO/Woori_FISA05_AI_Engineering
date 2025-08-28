# 🗺️ 비지도 학습과 PCA, 그리고 매니폴드 학습

## 🎯 목차
1. [차원의 저주 (The Curse of Dimensionality)](#1-🧐-차원의-저주-the-curse-of-dimensionality)
2. [주성분 분석 (Principal Component Analysis, PCA)](#2-🧠-주성분-분석-principal-component-analysis-pca)
3. [PCA 실습: 붓꽃 데이터셋](#3-🚀-pca-실습-붓꽃-데이터셋)
4. [PCA 실습: 이미지 데이터 (MNIST)](#4-🖼️-pca-실습-이미지-데이터-mnist)
5. [매니폴드 학습 (Manifold Learning)과 t-SNE](#5-🎨-매니폴드-학습manifold-learning과-t-sne)
6. [PCA 응용: 고유 얼굴 (Eigenface)](#6-🧑-pca-응용-고유-얼굴-eigenface)
7. [PCA 응용: 위스콘신 유방암 데이터셋 (파이프라인)](#7-🩺-pca-응용-위스콘신-유방암-데이터셋-파이프라인)
8. [요약 정리](#8-✍️-요약-정리)

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

## 3. 🚀 PCA 실습: 붓꽃 데이터셋

4차원의 붓꽃 데이터를 2차원으로 압축하여 시각화하고, 원본 데이터와 PCA 변환 데이터의 분류 성능을 비교한다.

### 데이터 준비 및 스케일링

- PCA는 여러 속성의 스케일에 영향을 받으므로, **PCA 적용 전 각 속성을 동일한 스케일로 변환**하는 것이 중요하다.
- `StandardScaler`를 사용하여 모든 속성 값을 평균 0, 분산 1인 표준 정규 분포로 변환한다.

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score

# 데이터 로드
iris = load_iris()
iris_df = pd.DataFrame(iris.data, columns=iris.feature_names)
iris_df['target'] = iris.target

# 원본 데이터 시각화 (sepal length vs sepal width)
markers=['^','s','o']
for i, marker in enumerate(markers):
    x_axis_data = iris_df[iris_df['target']==i]['sepal_length']
    y_axis_data = iris_df[iris_df['target']==i]['sepal_width']
    plt.scatter(x_axis_data, y_axis_data, marker=marker, label=iris.target_names[i])

plt.legend()
plt.xlabel('sepal length')
plt.ylabel('sepal width')
plt.show()

# 데이터 스케일링
iris_scaled = StandardScaler().fit_transform(iris_df.iloc[:,:-1])
```

### PCA 적용 및 시각화

```python
# 2차원으로 PCA 변환
pca = PCA(n_components=2)
iris_pca = pca.fit_transform(iris_scaled)

# PCA 데이터프레임 생성
pca_columns=['pca_component_1','pca_component_2']
irisDF_pca = pd.DataFrame(iris_pca, columns=pca_columns)
irisDF_pca['target'] = iris.target

# PCA 결과 시각화
markers=['^','s','o']
for i, marker in enumerate(markers):
    x_axis_data = irisDF_pca[irisDF_pca['target']==i]['pca_component_1']
    y_axis_data = irisDF_pca[irisDF_pca['target']==i]['pca_component_2']
    plt.scatter(x_axis_data, y_axis_data, marker=marker, label=iris.target_names[i])

plt.legend()
plt.xlabel('pca_component_1')
plt.ylabel('pca_component_2')
plt.show()
```

### 원본 데이터와 PCA 변환 데이터의 분류 성능 비교

```python
# 랜덤 포레스트 분류기 사용
rcf = RandomForestClassifier(random_state=156)

# 원본 데이터로 교차 검증
scores = cross_val_score(rcf, iris.data, iris.target, scoring='accuracy', cv=3)
print('원본 데이터 교차 검증 개별 정확도:', scores)
print('원본 데이터 평균 정확도:', np.mean(scores))

# PCA 데이터로 교차 검증
pca_X = irisDF_pca[['pca_component_1','pca_component_2']]
scores_pca = cross_val_score(rcf, pca_X, iris.target, scoring='accuracy', cv=3)
print('PCA 변환 데이터 교차 검증 개별 정확도:', scores_pca)
print('PCA 변환 데이터 평균 정확도:', np.mean(scores_pca))
```
- **결과:** 4개의 특성을 2개의 주성분으로 줄였음에도, 원본 데이터의 평균 정확도(약 0.96)와 PCA 변환 데이터의 평균 정확도(약 0.89) 사이에 큰 차이가 나지 않았다. 이는 PCA가 정보 손실을 최소화하며 효과적으로 차원을 축소했음을 보여준다.

---

## 4. 🖼️ PCA 실습: 이미지 데이터 (MNIST)

784차원(28x28 픽셀)의 MNIST 숫자 이미지 데이터를 PCA를 이용해 저차원으로 압축하고 복원하여 시각적으로 확인한다.

### PCA 알고리즘 구현

```python
import numpy as np
import scipy
import scipy.stats
from sklearn.datasets import fetch_openml
import matplotlib.pyplot as plt

# 데이터 로드 및 정규화
MNIST = fetch_openml('mnist_784', version=1)
images = MNIST['data'].to_numpy().astype(np.double) / 255.

# 1. 정규화 (평균 제거)
def normalize(X):
    mu = np.mean(X, axis=0)
    Xbar = X - mu
    return Xbar, mu

# 2. 공분산 행렬의 고유값/고유벡터 계산
def eig(S):
    eig_vals, eig_vecs = np.linalg.eig(S)
    sort_indices = np.argsort(eig_vals)[::-1] # 내림차순 정렬
    return eig_vals[sort_indices], eig_vecs[:, sort_indices]

# 3. 주성분으로 데이터 복원 (사영)
def reconstruct(X, PC):
    return (X @ PC) @ PC.T

# PCA 알고리즘
def PCA(images, num_components, num_data=1000):
    X = images[:num_data]
    N, D = X.shape
    X_normalized, mean = normalize(X)
    S = (X_normalized.T @ X_normalized) / N
    eig_vals, eig_vecs = eig(S)
    principal_vals, principal_components = np.real(eig_vals[:num_components]), np.real(eig_vecs[:,:num_components])
    reconst_X = reconstruct(X_normalized, principal_components) + mean
    return reconst_X, mean, principal_vals, principal_components
```

### 주성분 개수에 따른 이미지 복원 및 MSE

```python
# MSE 계산 함수
def mse(predict, actual):
    return np.square(predict - actual).sum(axis=1).mean()

loss = []
reconstructions = []
X = images[:1000]

for num_component in range(1, 100, 5):
    reconst, _, _, _ = PCA(X, num_component)
    error = mse(reconst, X)
    reconstructions.append(reconst)
    print(f'n = {num_component:d}, reconstruction_error = {error:f}')
    loss.append((num_component, error))

loss = np.asarray(loss)

# MSE 시각화
fig, ax = plt.subplots()
ax.plot(loss[:,0], loss[:,1]);
ax.axhline(10, linestyle='--', color='r', linewidth=2)
ax.xaxis.set_ticks(np.arange(1, 100, 5));
ax.set(xlabel='num_components', ylabel='MSE', title='MSE vs number of principal components');
```
- **결과:** 주성분 개수가 약 41개일 때 MSE가 10 이하로 떨어지며 기울기가 완만해진다. 이는 784차원의 원본 이미지를 약 41개의 주성분만으로도 충분히 복원 가능함을 의미한다.

---

## 5. 🎨 매니폴드 학습(Manifold Learning)과 t-SNE

- **매니폴드(Manifold, 다양체)** 는 국소적으로 유클리드 공간과 닮은 위상 공간을 의미한다.
- 매니폴드 학습은 고차원 데이터가 실제로는 저차원의 매니폴드에 임베딩되어 있다고 가정하고, 이 저차원 구조를 찾아내는 비선형 차원 축소 기법이다.
- **t-SNE(t-Distributed Stochastic Neighbor Embedding)** 는 시각화를 목적으로 널리 사용되는 매니폴드 학습 알고리즘으로, 고차원 공간에서 비슷한 데이터 구조는 저차원 공간에서도 가깝게 유지되도록 맵핑한다.

### t-SNE 실습: 숫자 데이터셋

```python
from sklearn.datasets import load_digits
from sklearn.manifold import TSNE
import matplotlib.patheffects as PathEffects

# 데이터 로드
digits = load_digits()
X_digits = digits.data
y_digits = digits.target

# t-SNE 모델 생성 및 변환
tsne = TSNE(n_components=2, init='pca', random_state=123)
X_digits_tsne = tsne.fit_transform(X_digits)

# t-SNE 결과 시각화
def plot_projection(x, colors):
  f = plt.figure(figsize=(8,8))
  ax = plt.subplot(aspect='equal')
  for i in range(10):
    plt.scatter(x[colors==i, 0],
                x[colors==i, 1])
  for i in range(10):
    xtext, ytext = np.median(x[colors==i, :], axis=0)
    txt = ax.text(xtext, ytext, str(i), fontsize=24)
    txt.set_path_effects([
        PathEffects.Stroke(linewidth=5, foreground="w"),
        PathEffects.Normal()])

plot_projection(X_digits_tsne, y_digits)
plt.show()
```
- **결과:** t-SNE를 통해 64차원의 숫자 데이터를 2차원으로 시각화한 결과, 같은 숫자끼리 잘 군집을 이루는 것을 확인할 수 있다.

---

## 6. 🧑 PCA 응용: 고유 얼굴 (Eigenface)

- PCA를 얼굴 이미지에 적용하여 **고유 얼굴(Eigenface)** 이라는 주요 특성을 추출할 수 있다.
- 이는 얼굴 인식 시스템 등에서 활용된다.

```python
from sklearn.datasets import fetch_olivetti_faces

# 데이터 로드
faces_all = fetch_olivetti_faces()
K = 20 # 특정 인물 선택
faces = faces_all.images[faces_all.target == K]

# 얼굴 이미지 시각화
N = 2
M = 5
fig = plt.figure(figsize=(10, 5))
plt.subplots_adjust(top=1, bottom=0, hspace=0, wspace=0.05)
for n in range(N*M):
    ax = fig.add_subplot(N, M, n+1)
    ax.imshow(faces[n], cmap=plt.cm.bone)
    ax.grid(False)
    ax.xaxis.set_ticks([])
    ax.yaxis.set_ticks([])
plt.tight_layout()
plt.show()
```

---

## 7. 🩺 PCA 응용: 위스콘신 유방암 데이터셋 (파이프라인)

- `StandardScaler`, `PCA`, `LogisticRegression`을 `make_pipeline`으로 연결하여 데이터 전처리, 차원 축소, 모델 학습 과정을 한 번에 효율적으로 처리한다.
- 30개의 특성을 가진 유방암 데이터셋을 2개의 주성분으로 축소하여 분류 모델의 성능을 확인한다.

```python
from sklearn.datasets import load_breast_cancer
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.decomposition import PCA
from sklearn.pipeline import make_pipeline
from sklearn.model_selection import train_test_split

# 데이터 로드 및 분할
cancer = load_breast_cancer()
X_train, X_test, y_train, y_test = train_test_split(
    cancer.data, cancer.target, test_size=0.2, random_state=42
)

# 파이프라인 생성 및 학습
pipe = make_pipeline(StandardScaler(), PCA(n_components=2), LogisticRegression())
pipe.fit(X_train, y_train)

# 예측 및 평가
print("Train Score:", pipe.score(X_train, y_train))
print("Test Score:", pipe.score(X_test, y_test))

# PCA 변환 데이터 확인
pca = pipe.named_steps['pca']
X_pca = pca.transform(StandardScaler().fit_transform(cancer.data))
pca_df = pd.DataFrame(X_pca, columns=['PC1', 'PC2'])
print(pca_df.head())
```
- **결과:** 30개의 특성을 2개로 줄였음에도 불구하고, 테스트 데이터에 대해 약 97.4%의 높은 정확도를 보였다. 파이프라인을 통해 전체 워크플로우를 간결하게 구성할 수 있었다.

---

## 8. ✍️ 요약 정리

- **차원의 저주**는 고차원 데이터에서 발생하는 희소성 문제로, 모델 성능 저하의 원인이 된다.
- **PCA**는 데이터의 분산을 최대한 보존하는 주성분을 추출하여 효과적으로 차원을 축소하는 선형 기법이다.
- **매니폴드 학습(t-SNE)** 은 데이터의 국소적 구조를 보존하며 시각화에 유용한 비선형 차원 축소 기법이다.
- 붓꽃, MNIST, 유방암 데이터셋 실습 결과, PCA를 통해 특성의 수를 크게 줄여도 모델의 성능이 크게 저하되지 않거나, 시각화를 통해 데이터의 구조를 성공적으로 파악할 수 있었다.
- **파이프라인** 을 사용하면 데이터 전처리, 차원 축소, 모델 학습 과정을 체계적이고 효율적으로 관리할 수 있다. 성공! 🎉
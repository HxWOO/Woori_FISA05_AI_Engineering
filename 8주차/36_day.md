# 📖 지도학습: 분류 & Scikit-Learn 마스터하기

## 🎯 목차

- **Scikit-learn 첫걸음**: 기본 API와 퍼셉트론 훈련
- **로지스틱 회귀**: 클래스 확률 모델링과 과대적합 방지
- **서포트 벡터 머신 (SVM)**: 최대 마진과 커널 트릭의 마법
- **결정 트리**: 정보 이득과 랜덤 포레스트
- **k-최근접 이웃 (KNN)**: 게으른 학습 알고리즘

<br>

## 1. Scikit-learn, 첫 만남! 🚀

![scikit-learn logo](https://scikit-learn.org/stable/_static/scikit-learn-logo-small.png)

- **Scikit-learn**은 다양한 머신러닝 기술을 통일된 인터페이스로 제공하는 멋진 라이브러리다.
- 머신러닝 알고리즘과 개발 프레임워크, API를 모두 갖추고 있어 개발이 정말 편해진다.

### 🛠️ API 사용 5단계

1.  **Estimator 클래스 선택**: `sklearn`에서 원하는 모델의 클래스를 임포트한다.
2.  **하이퍼파라미터 선택**: 클래스 인스턴스를 만들며 하이퍼파라미터를 설정한다.
3.  **데이터 준비**: 특징 배열(X)과 대상 벡터(y)로 데이터를 나눈다.
4.  **모델 훈련**: `fit()` 메서드로 모델을 데이터에 학습시킨다. ✨
5.  **모델 적용**:
    - **지도학습**: `predict()`로 새로운 데이터의 레이블을 예측한다.
    - **비지도학습**: `transform()`이나 `predict()`로 데이터 특성을 변환/추론한다. (`fit_transform()`으로 한 번에 처리도 가능!)

---

## 2. 주요 분류 알고리즘과 핵심 이론

### (1) 퍼셉트론 (Perceptron)

- 이진 분류를 위한 가장 기본적인 선형 모델.
- `sklearn.linear_model.Perceptron` 클래스를 사용한다.

```python
from sklearn.linear_model import Perceptron
# ... (코드 생략) ...
ppn = Perceptron(eta0=0.1, random_state=1)
ppn.fit(X_train_std, y_train)
y_pred = ppn.predict(X_test_std)
print(f'정확도: {accuracy_score(y_test, y_pred):.2f}') # 성공! 🎉
```

### (2) 로지스틱 회귀 (Logistic Regression)

- 이름은 '회귀'지만, 실제로는 클래스에 속할 **확률**을 모델링하는 강력한 선형 **분류** 알고리즘이다.

#### 핵심 이론 🧐

- **시그모이드 함수**: 선형 모델의 출력을 0과 1 사이의 확률 값으로 변환한다. 이 덕분에 특정 클래스에 속할 조건부 확률을 예측할 수 있다.
- **비용 함수 (Cost Function)**: 로지스틱 회귀는 로그 가능도(log-likelihood) 함수를 최적화하는 비용 함수를 사용한다. 이 함수를 최소화하는 가중치를 찾음으로써 최적의 결정 경계를 학습한다.
- **과대적합과 규제 (Regularization)**: 모델이 훈련 데이터에 너무 복잡하게 맞춰져 새로운 데이터에 대한 성능이 떨어지는 것을 **과대적합(Overfitting)**이라고 한다.
  - **규제**는 모델의 복잡도에 페널티를 부과하여 가중치(w) 값을 작게 만드는 기술이다. 이를 통해 과대적합을 방지하고 일반화 성능을 높인다.
  - **L2 규제**: 모든 가중치의 제곱합에 페널티를 부여한다. (`penalty='l2'`)
  - **L1 규제**: 모든 가중치의 절대값 합에 페널티를 부여하며, 특정 가중치를 0으로 만들어 특징 선택 효과를 주기도 한다. (`penalty='l1'`)
  - `C` 파라미터는 규제 강도의 역수다. `C`가 작을수록 **강한 규제**가 적용된다.

#### Scikit-learn 구현

- `sklearn.linear_model.LogisticRegression` 클래스를 사용한다.
- `C`와 `penalty` 하이퍼파라미터로 규제를 제어할 수 있다.

```python
from sklearn.linear_model import LogisticRegression

# C=1.0 (기본값), L2 규제 적용
lr = LogisticRegression(C=1.0, random_state=1, solver='lbfgs', multi_class='ovr')
lr.fit(X_train_std, y_train)
# 클래스 확률 예측
proba = lr.predict_proba(X_test_std[:3, :])
print(proba.round(3))
```

### (3) 서포트 벡터 머신 (SVM)

- 클래스 간의 **마진(margin)을 최대화**하는 결정 경계를 찾는 알고리즘. 마진이 클수록 일반화 성능이 좋다고 기대할 수 있다.

#### 핵심 이론 🧐

- **최대 마진 (Maximum Margin)**: 두 클래스를 구분하는 초평면(결정 경계) 중에서, 각 클래스의 가장 가까운 데이터 샘플(서포트 벡터)과의 거리가 가장 먼 초평면을 찾는다. 이 거리가 바로 마진이다.
- **슬랙 변수 (Slack Variable)**: 선형적으로 완벽히 분리되지 않는 데이터에 대해 어느 정도의 오류를 허용하기 위해 도입된 변수다. `C` 파라미터로 이 오류 허용 수준을 조절한다. `C`가 작으면 소프트 마진(오류 허용 많음), 크면 하드 마진(오류 허용 적음)이 된다.
- **커널 트릭 (Kernel Trick)**: 저차원 공간에서 선형 분리가 어려운 데이터를 고차원 공간으로 매핑하여 선형 분리가 가능하게 만드는 기술이다. 실제로 데이터를 옮기지 않고 계산만으로 이런 효과를 내는 것이 핵심!
  - **RBF 커널 (`kernel='rbf'`)**: 가장 널리 쓰이는 커널로, 복잡한 결정 경계를 만들 수 있다. `gamma` 파라미터로 영향 범위를 조절한다.

#### Scikit-learn 구현

- `sklearn.svm.SVC` 클래스를 사용한다.

```python
from sklearn.svm import SVC

# SVM 훈련 (RBF 커널)
# gamma가 너무 크면 과대적합 위험이 있다.
svm = SVC(kernel='rbf', random_state=1, gamma=0.10, C=10.0)
svm.fit(X_train_std, y_train)
```

### (4) 결정 트리 (Decision Tree)

- 데이터의 특징을 기반으로 **스무고개**처럼 질문을 던져가며 클래스를 예측하는 모델. 모델 내부를 쉽게 해석할 수 있다는 큰 장점이 있다.

#### 핵심 이론 🧐

- **정보 이득 (Information Gain)**: 어떤 특징으로 데이터를 분할했을 때, 불순도(impurity)가 얼마나 감소했는지를 나타내는 지표다. 결정 트리는 매 분기마다 정보 이득이 최대가 되는 특징과 분할 지점을 찾는다.
- **불순도 지표**:
  - **지니 불순도 (Gini Impurity)**: 잘못 분류될 확률을 최소화하는 방향으로 분기. (기본값)
  - **엔트로피 (Entropy)**: 정보의 불확실성을 최소화하는 방향으로 분기.

#### Scikit-learn 구현

- `sklearn.tree.DecisionTreeClassifier` 클래스를 사용한다.
- `max_depth`로 트리의 최대 깊이를 제한하여 과대적합을 막는 것이 중요하다.

```python
from sklearn.tree import DecisionTreeClassifier

# 결정 트리 훈련
tree = DecisionTreeClassifier(criterion='gini', max_depth=4, random_state=1)
tree.fit(X_train, y_train)
```

### (5) 랜덤 포레스트 (Random Forest)

- 여러 개의 결정 트리를 묶어 예측 성능을 높인 **앙상블** 모델.
- 각 트리는 데이터의 일부(부트스트랩 샘플)와 특징의 일부를 무작위로 선택해 학습한다.
- 개별 트리의 단점(과대적합)을 보완하여 일반적으로 매우 안정적이고 높은 성능을 보인다. 역시 집단지성의 힘! 🧠

### (6) K-최근접 이웃 (KNN)

- 새로운 데이터가 들어오면 가장 가까운 **k개**의 이웃 데이터의 클래스를 보고 자신의 클래스를 결정하는 알고리즘.
- 모델을 미리 훈련하지 않고 예측 시점에 계산을 시작해서 **게으른 학습(lazy learning)**이라고도 불린다.
- 특징을 표준화(Standardization)하는 전처리가 매우 중요하다.

```python
from sklearn.neighbors import KNeighborsClassifier

# KNN 훈련
knn = KNeighborsClassifier(n_neighbors=5, p=2, metric='minkowski')
knn.fit(X_train_std, y_train)
```

---

이제 각 알고리즘의 핵심 이론까지 더해져서 훨씬 깊이 있는 학습 노트가 완성되었다. 뿌듯하다! 😊

---
### ✍️ 요약 정리
이 학습 노트는 Scikit-learn의 일관된 API를 사용하여 퍼셉트론, 로지스틱 회귀, SVM, 결정 트리, KNN과 같은 주요 분류 알고리즘을 다루었다. 각 모델의 Scikit-learn 구현 방법과 함께, 과대적합을 막기 위한 규제(Regularization), SVM의 최대 마진, 결정 트리의 정보 이득 같은 핵심 이론을 정리했다. 이를 통해 분류 모델의 이론과 실제 적용법을 균형 있게 학습할 수 있었다.

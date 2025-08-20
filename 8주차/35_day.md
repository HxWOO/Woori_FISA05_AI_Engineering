## 🧠 간단한 분류 알고리즘 훈련

이번 학습에서는 머신러닝의 기초인 분류(Classification) 알고리즘을 직접 구현하고 훈련해보았습니다. 특히 퍼셉트론과 아달린(ADALINE)이라는 선형 분류 알고리즘을 중심으로, 이들이 어떻게 동작하고 학습하는지를 코드와 함께 살펴보았습니다. 이 알고리즘들은 복잡한 딥러닝 모델의 근간이 되는 개념들을 포함하고 있어, 머신러닝의 입문자에게 매우 중요한 내용입니다.

> ### 💡 분류 알고리즘, 왜 중요할까?
> 분류는 머신러닝의 핵심 작업 중 하나로, 주어진 입력 데이터를 특정한 카테고리(클래스)로 분류하는 것을 목표로 합니다. 예를 들어 이메일이 스팸인지 아닌지, 종양이 양성인지 악성인지 판단하는 것이 바로 분류 작업입니다. 이러한 작업은 산업 전반에서 널리 사용되므로, 그 원리를 이해하는 것은 매우 중요합니다.

---

### 🧮 인공 뉴런: 퍼셉트론과 아달린

#### 수학적 정의
- 퍼셉트론과 아달린은 모두 **입력 신호의 가중합**을 계산합니다.
- 수식: $ z = w_1x_1 + w_2x_2 + \cdots + w_mx_m = \boldsymbol{w}^T\boldsymbol{x} $
  - $\boldsymbol{w}$: 가중치 벡터
  - $\boldsymbol{x}$: 입력 벡터
  - $z$: 최종 입력 (net input)

#### 결정 함수 (퍼셉트론)
- 퍼셉트론은 계단 함수(Unit Step Function)를 사용합니다.
- 수식: $\phi(z)=\begin{cases}1 & z \ge 0 \\ -1 & \text{그 외} \end{cases}$
- 이 함수는 최종 입력 $z$가 임계값 0보다 크면 1, 작으면 -1을 출력합니다.

#### 활성화 함수 (아달린)
- 아달린은 선형 활성화 함수(Identity Function)를 사용합니다.
- 수식: $\phi(z) = z$
- 이는 최종 입력 $z$를 그대로 출력합니다. 이 값을 기준으로 클래스를 나눕니다.

#### 학습 규칙 (퍼셉트론)
- 퍼셉트론의 학습 규칙은 다음과 같습니다.
- 수식: $\Delta w_j = \eta(y^{(i)} - \hat{y}^{(i)})x_j^{(i)}$
  - $\eta$: 학습률
  - $y^{(i)}$: 실제 값
  - $\hat{y}^{(i)}$: 예측 값
  - $x_j^{(i)}$: $j$번째 특성의 $i$번째 샘플 값
- 이 규칙은 예측이 틀렸을 때만 가중치를 업데이트합니다.

#### 비용 함수 (아달린)
- 아달린은 연속적인 출력을 사용하므로, 연속적인 오차를 줄이는 방식으로 학습합니다.
- 이에 사용되는 것이 **비용 함수 (Cost Function)** 입니다.
- 수식: $J(\boldsymbol{w}) = \dfrac{1}{2}\sum_i\left(y^{(i)} - \phi(z^{(i)})\right)^2$
- 이 함수는 실제 값과 예측 값의 차이(오차)의 제곱합입니다. 이 값을 최소화하는 방향으로 학습합니다.

---

### 🐍 파이썬으로 퍼셉트론 학습 알고리즘 구현

#### 객체 지향 퍼셉트론 API

```python
class Perceptron:
    def __init__(self, eta=0.001, n_iter=50, random_state=1):
        self.eta = eta
        self.n_iter = n_iter
        self.random_state = random_state

    def fit(self, X, y):
        rgen = np.random.RandomState(self.random_state)
        self.w_ = rgen.normal(loc=0.0, scale=0.01, size=1 + X.shape[1])
        self.errors_ = []

        for _ in range(self.n_iter):
            errors = 0
            for xi, target in zip(X, y):
                update = self.eta * (target - self.predict(xi))
                self.w_[1:] += update * xi
                self.w_[0] += update
                errors += int(update != 0.0)
            self.errors_.append(errors)
        return self

    def net_input(self, X):
        return np.dot(X, self.w_[1:]) + self.w_[0]

    def predict(self, X):
        return np.where(self.net_input(X) >= 0.0, 1, -1)
```

#### 붓꽃 데이터셋에서 퍼셉트론 훈련

- `Iris-setosa`와 `Iris-versicolor` 두 클래스를 선택하여 이진 분류 문제로 만들었습니다.
- `sepal length`와 `petal length` 두 가지 특성만 사용했습니다.
- 퍼셉트론 모델을 훈련시킨 후, 결정 경계(Decision Boundary)를 시각화했습니다.
- 데이터가 선형 분리 가능했기 때문에, 퍼셉트론은 잘 작동했습니다.

| 코드 | 설명 | 특징 |
| :--- | :--- | :--- |
| **`ppn = Perceptron()`** | 퍼셉트론 모델을 생성합니다. | 학습률, 에포크 수 등을 지정할 수 있습니다. |
| **`ppn.fit(X, y)`** | 모델을 훈련합니다. | 훈련 과정에서 오류가 줄어드는지 확인할 수 있습니다. |
| **`ppn.predict(X_new)`** | 새로운 데이터에 대해 예측합니다. | 1 또는 -1을 반환합니다. |

---

### 📈 적응형 선형 뉴런 (ADALINE)과 학습의 수렴

#### 경사 하강법 (Gradient Descent)

- 아달린은 연속적인 오차를 최소화하기 위해 **경사 하강법**을 사용합니다.
- **비용 함수** $J(\boldsymbol{w})$의 기울기(Gradient)를 따라 가중치 $\boldsymbol{w}$를 업데이트합니다.
- 수식: $\boldsymbol{w} := \boldsymbol{w} + \Delta \boldsymbol{w}$, where $\Delta \boldsymbol{w} = \eta \sum_i (y^{(i)} - \phi(z^{(i)}))x^{(i)}$

#### 파이썬으로 아달린 구현

```python
class AdalineGD:
    def __init__(self, eta=0.001, n_iter=50, random_state=1):
        self.eta = eta
        self.n_iter = n_iter
        self.random_state = random_state

    def fit(self, X, y):
        rgen = np.random.RandomState(self.random_state)
        self.w_ = rgen.normal(loc=0.0, scale=0.01, size=1 + X.shape[1])
        self.cost_ = []

        for i in range(self.n_iter):
            net_input = self.net_input(X)
            output = self.activation(net_input)
            errors = (y - output)
            self.w_[1:] += self.eta * X.T.dot(errors)
            self.w_[0] += self.eta * errors.sum()
            cost = (errors**2).sum() / 2.0
            self.cost_.append(cost)
        return self

    def net_input(self, X):
        return np.dot(X, self.w_[1:]) + self.w_[0]

    def activation(self, X):
        return X # 선형 활성화

    def predict(self, X):
        return np.where(self.activation(self.net_input(X)) >= 0.0, 1, -1)
```

#### 특성 스케일 조정 (Feature Scaling)

- 경사 하강법은 입력 특성의 **스케일**에 매우 민감합니다.
- 특성 간 스케일이 차이가 크면 학습이 느려지거나 수렴하지 않을 수 있습니다.
- 이를 해결하기 위해 **표준화 (Standardization)** 를 사용합니다.
- 수식: $x'_j = \dfrac{x_j - \mu_j}{\sigma_j}$
  - $\mu_j$: $j$번째 특성의 평균
  - $\sigma_j$: $j$번째 특성의 표준 편차

#### 확률적 경사 하강법 (Stochastic Gradient Descent, SGD)

- 배치 경사 하강법은 모든 훈련 샘플을 사용해 한 번의 업데이트를 수행합니다.
- **확률적 경사 하강법**은 한 번에 하나의 샘플만 사용해 업데이트를 수행합니다.
- 이는 더 빠르고, 대용량 데이터에 적합하며, 온라인 학습(실시간 학습)도 가능하게 합니다.

```python
class AdalineSGD:
    # ... (위 코드 참조)
    def _update_weights(self, xi, target):
        """SGD 학습 규칙을 적용하여 가중치를 업데이트합니다"""
        output = self.activation(self.net_input(xi))
        error = (target - output)
        self.w_[1:] += self.eta * xi.dot(error)
        self.w_[0] += self.eta * error
        cost = 0.5 * error**2
        return cost
```

---

### ✨ 오늘 배운 것 요약

- **퍼셉트론**은 이진 분류를 위한 가장 기본적인 선형 분류기입니다. 계단 함수를 사용하며, 오분류된 데이터에 대해서만 가중치를 업데이트합니다.
- **아달린**은 퍼셉트론의 확장 버전으로, 연속적인 활성화 함수와 비용 함수를 사용하여 경사 하강법으로 학습합니다.
- **비용 함수**는 모델의 예측 오차를 수치화한 것으로, 이 값을 최소화하는 방향으로 모델이 학습됩니다.
- **경사 하강법**은 비용 함수의 기울기를 따라 가중치를 업데이트하여 최솟값을 찾는 최적화 알고리즘입니다.
- **특성 스케일 조정**(표준화)은 경사 하강법의 수렴 속도를 높이고 안정성을 확보하는 데 매우 중요합니다.
- **확률적 경사 하강법**(SGD)은 데이터를 하나씩 사용하여 가중치를 업데이트하므로, 빠르고 메모리 효율적이며 대용량 데이터에 적합합니다.
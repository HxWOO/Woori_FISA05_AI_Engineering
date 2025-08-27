# 🪄 전처리 기법과 모델의 성능을 평가하는 다양한 지표

## 🎯 목차
1.  [과대적합과 과소적합](#1-과대적합과-과소적합-🤔)
2.  [교차 검증 (Cross-Validation)](#2-교차-검증-cross-validation-🚀)
3.  [데이터 전처리 (Preprocessing)](#3-데이터-전처리-preprocessing-✨)
4.  [분류 모델 성능 측정 지표](#4-분류-모델-성능-측정-지표-📊)
5.  [요약 정리](#5-✍️-요약-정리)

---

## 1. 과대적합과 과소적합 🤔

-   **과대적합 (Overfitting)**: 모델이 학습 데이터에만 너무 잘 맞춰져서, 새로운 데이터에는 오히려 예측 성능이 떨어지는 현상. 암기만 하고 응용을 못하는 학생 같았다.
-   **과소적합 (Underfitting)**: 모델이 너무 단순해서 데이터의 패턴을 제대로 학습하지 못하는 상태. 공부를 너무 안 한 느낌!

이런 문제를 피하려면 **교차 검증**이 필수라는 걸 배웠다.

## 2. 교차 검증 (Cross-Validation) 🚀

데이터를 여러 조각으로 나눠서, 모델을 여러 번 테스트하고 평균적인 성능을 평가하는 아주 스마트한 방법이었다.

### K-폴드 교차 검증 (K-Fold Cross-Validation)

데이터를 K개의 덩어리(폴드)로 나누고, 하나씩 돌아가며 테스트용으로 사용하는 방식. 덕분에 데이터가 부족해도 신뢰도 높은 검증을 할 수 있었다.

```python
# K-Fold로 교차 검증을 직접 구현해봤다.
from sklearn.model_selection import KFold
import numpy as np

kfold = KFold(n_splits=5)
cv_accuracy = []

for train_index, test_index in kfold.split(X):
    X_train, X_test = X[train_index], X[test_index]
    y_train, y_test = y[train_index], y[test_index]

    dt_clf.fit(X_train, y_train)
    pred = dt_clf.predict(X_test)

    accuracy = np.round(accuracy_score(y_test, pred), 4)
    cv_accuracy.append(accuracy)

print(f'K-Fold 평균 정확도: {np.mean(cv_accuracy):.4f} ')
```

## 3. 데이터 전처리 (Preprocessing) ✨

좋은 모델은 좋은 데이터에서 나온다는 말을 체감했다. (Garbage in Garbage Out 🚯)

### 레이블 인코딩 (Label Encoding)

'TV', '냉장고' 같은 문자열 데이터를 숫자로 바꿔주는 간단한 방법. 하지만 숫자 크기에 의미가 부여될 수 있어 조심해야 한다.

```python
from sklearn.preprocessing import LabelEncoder

items = ['TV', '냉장고', '전자레인지', '컴퓨터', '선풍기', '선풍기', '믹서', '믹서']
encoder = LabelEncoder()
labels = encoder.fit_transform(items)
# 인코딩 변환값: [0 1 4 5 3 3 2 2]
```

### 원-핫 인코딩 (One-Hot Encoding)

레이블 인코딩의 단점을 보완하는 방법. 각 카테고리를 새로운 피처(열)로 만들고, 해당하면 1, 아니면 0으로 표시한다. 피처가 많아지는 단점은 있다.

```python
from sklearn.preprocessing import OneHotEncoder

# 2차원 배열로 변환해야 했다.
items_2d = np.array(items).reshape(-1, 1)
oh_encoder = OneHotEncoder()
oh_labels = oh_encoder.fit_transform(items_2d)
# 결과는 희소 행렬이라 toarray()로 봐야 눈에 잘 들어온다.
# print(oh_labels.toarray())
```

### 피처 스케일링 (Feature Scaling)

각 피처의 값 범위를 맞춰주는 것. 키와 몸무게처럼 단위가 다를 때 필수적이다.

-   **StandardScaler**: 평균 0, 분산 1로 만들어 정규분포처럼 바꿔준다.
-   **MinMaxScaler**: 모든 값을 0과 1 사이로 꾸겨 넣는다.

```python
# 붓꽃 데이터로 스케일링을 직접 해보니 데이터 분포가 바뀌는 게 신기했다.
from sklearn.preprocessing import StandardScaler, MinMaxScaler

std_scaler = StandardScaler()
iris_scaled_std = std_scaler.fit_transform(iris.data)

minmax_scaler = MinMaxScaler()
iris_scaled_minmax = minmax_scaler.fit_transform(iris.data)
```

## 4. 분류 모델 성능 측정 지표 📊

정확도만 믿으면 안 된다는 걸 뼈저리게 느꼈다.

-   **정확도 (Accuracy)**: 가장 기본적이지만, 데이터가 불균형하면 모델을 잘못 평가할 수 있다.
-   **오차 행렬 (Confusion Matrix)**: 모델이 뭘 헷갈리는지 한눈에 보여주는 표. TP, FP, FN, TN이 모든 것의 시작이었다.
-   **정밀도 (Precision) & 재현율 (Recall)**: 정밀도는 "모델이 맞다고 한 것 중 진짜 정답 비율", 재현율은 "실제 정답 중 모델이 맞춘 비율". 둘은 보통 반비례 관계(Trade-off)다.
-   **F1 스코어 (F1 Score)**: 정밀도와 재현율의 조화 평균. 둘 다 중요할 때 사용한다.
-   **ROC 곡선과 AUC**: 모델이 얼마나 정답과 오답을 잘 구분하는지 보여주는 곡선과 그 면적. AUC가 1에 가까울수록 완벽한 모델이다.

## 5. ✍️ 요약 정리

- **과대적합**을 피하기 위한 **교차 검증**의 중요성과, 데이터의 특성에 맞는 **전처리** 기법을 적용하는 법을 배웠다.
- **정확도**만으로는 알 수 없는 모델의 진짜 성능을 **오차 행렬**, **정밀도**, **재현율**, **AUC** 등 다양한 지표로 다각적으로 평가해야 한다는 점을 배웠다.
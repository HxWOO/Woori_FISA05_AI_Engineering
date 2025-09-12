# Isolation Forest

-   **Summary:** 이 문서는 비지도 이상치 탐지 알고리즘인 Isolation Forest의 핵심 개념과 한계, 그리고 이를 보완하기 위한 SMOTE 오버샘플링 및 AutoML(PyCaret)을 활용한 지도학습 분류 모델(Random Forest) 적용 사례를 정리했다.

---

## 1. 개요 (Overview)

**Isolation Forest**는 Unsupervised Anomaly Detection (비지도 이상치 탐지) 알고리즘 중 하나로, 데이터셋 내에서 **이상치(Anomaly)**를 탐지하는 데 사용된다.

이름에서 알 수 있듯이 Tree 기반 모델이며, 랜덤으로 데이터를 분할하여 모든 관측치를 **고립(isolate)**시키는 방식으로 동작한다.

## 2. 핵심 개념 (Core Concepts)

Isolation Forest는 "이상치는 정상 데이터보다 고립시키기 쉽다"는 기본 가정에서 출발한다.

-   **정상 데이터**: 데이터 분포에 따라 밀집되어 있어, 개별 데이터를 분리하려면 트리의 깊은 레벨까지 내려가야 한다. 즉, **경로 길이(Path Length)가 길다.**
-   **이상치**: 데이터 분포에서 멀리 떨어져 있어, 트리의 상단부에서 쉽게 분리된다. 즉, **경로 길이(Path Length)가 짧다.**

![Isolation Forest Concept](https://velog.velcdn.com/images%2Fvvakki_%2Fpost%2F053cffc6-0c51-448d-ac80-37c2bd9226bf%2Fimage.png)

이러한 경로 길이의 차이를 기준으로 이상치 점수(Anomaly Score)를 계산하여 정상과 이상을 판별한다.

## 3. 장점 및 한계

-   **장점**: 계산량이 매우 적고, 데이터 스케일에 영향을 받지 않아 대용량 데이터에 효과적이다.
-   **한계**: 비지도 학습이므로, 레이블이 있는 데이터에서는 지도 학습 분류 모델보다 성능이 낮을 수 있다. 특히 클래스 불균형이 심한 경우, 성능 개선을 위해 다른 접근법을 함께 고려해야 했다.

## 4. 클래스 불균형 문제 해결: SMOTE

신용카드 사기 거래와 같은 데이터는 정상 거래가 대부분이고 사기 거래는 극소수인 **클래스 불균형**이 매우 심각했다. 😭 이 경우, 모델이 다수 클래스(정상)에만 치우쳐 학습될 수 있다.

**SMOTE (Synthetic Minority Over-sampling Technique)**는 이러한 문제를 해결하기 위한 오버샘플링 기법으로, 소수 클래스(사기)의 데이터를 합성하여 새로운 샘플을 생성한다. 이를 통해 데이터의 클래스 분포를 균형 있게 만들어 모델이 소수 클래스의 특징을 더 잘 학습하도록 도울 수 있다.

### SMOTE 적용 코드

`imblearn` 라이브러리를 사용하여 SMOTE를 적용하면, 소수 클래스의 데이터 수가 다수 클래스와 동일하게 증강된다. 성공! 🎉

```python
from imblearn.over_sampling import SMOTE

# 원본 데이터 (X: 특성, y: 레이블)
X = val_df.drop(columns=['ID', 'Class'])
y = val_df['Class']

print("Original class distribution:\n", y.value_counts())
# Original class distribution:
# 0    28432
# 1       30
# Name: Class, dtype: int64

# SMOTE 적용
smote = SMOTE(random_state=42)
X_resampled, y_resampled = smote.fit_resample(X, y)

print("\nResampled class distribution:\n", y_resampled.value_counts())
# Resampled class distribution:
# 0    28432
# 1    28432
# Name: Class, dtype: int64
```

## 5. AutoML(PyCaret)을 이용한 최적 모델 탐색

**PyCaret**과 같은 AutoML 라이브러리는 모델링 프로세스를 자동화하여 최적의 모델을 효율적으로 찾아준다. 특히 `setup` 함수 내 `fix_imbalance=True` 옵션을 통해 SMOTE와 같은 기법을 손쉽게 적용할 수 있었다.

실험 결과, `compare_models()` 함수를 통해 여러 모델을 비교했을 때 **Random Forest (`rf`)** 모델이 사기 거래 탐지(Recall: 0.83, Precision: 0.89)에서 매우 우수한 성능을 보여주었다. 👍

## 6. 최종 모델: SMOTE + Random Forest

PyCaret에서 확인한 결과를 바탕으로, SMOTE로 오버샘플링된 데이터에 Random Forest 모델을 직접 적용하여 높은 성능을 재현할 수 있었다.

### 6.1. 모델 학습 및 평가 코드

```python
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix, ConfusionMatrixDisplay
import matplotlib.pyplot as plt

# 1. SMOTE 적용 데이터 분할
X_train, X_test, y_train, y_test = train_test_split(
    X_resampled, y_resampled, test_size=0.2, random_state=42
)

# 2. Random Forest 모델 학습
rf_clf = RandomForestClassifier(n_estimators=1000, random_state=42)
rf_clf.fit(X_train, y_train)

# 3. 예측 및 성능 평가
y_pred = rf_clf.predict(X_test)
print("### Random Forest Classification Report ###\n")
print(classification_report(y_test, y_pred))

# 4. Confusion Matrix 시각화
cm = confusion_matrix(y_test, y_pred)
ConfusionMatrixDisplay(cm, display_labels=['정상', '사기']).plot(cmap="Blues")
plt.title("Confusion Matrix - SMOTE + Random Forest")
plt.show()
```

### 6.2. 성능 분석

-   **높은 재현율(Recall)**: SMOTE와 Random Forest를 함께 사용한 모델은 사기 거래(Class 1)에 대해 매우 높은 `recall` 점수를 기록했다. 이는 실제 사기 거래의 대부분을 놓치지 않고 탐지했음을 의미하여 이상 탐지 모델의 핵심 목표를 성공적으로 달성했음을 보여준다. 🎉
-   **균형 잡힌 성능**: `precision`과 `f1-score` 역시 준수하여, 모델이 무분별하게 모든 거래를 사기로 판단하는 것이 아니라 합리적인 수준에서 예측하고 있음을 알 수 있었다.

## 7. 참고 자료

-   [Velog: Isolation Forest (미완성)](https://velog.io/@vvakki_/Isolation-Forest-%EB%AF%B8%EC%99%84%EC%84%B1)
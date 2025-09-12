# 🕸️CNN (Convolutional Neural Network)

---

## 🎯 목차
1. [CNN 핵심 개념 🧐](#1-cnn-핵심-개념-)
2. [Fashion MNIST 분류 실습 🚀](#2-fashion-mnist-분류-실습-)
3. [모델 성능 개선 기법 ✨](#3-모델-성능-개선-기법-)
4. [최종 요약 ✍️](#4-최종-요약-️)

---

## 1. CNN 핵심 개념 🧐

**컨볼루션 신경망(CNN)** 은 이미지의 **공간적 특징(Spatial Feature)** 을 유지한 채 학습하기 위해 고안된 딥러닝 모델이다. 기존의 딥러닝 모델이 이미지를 1차원으로 펼치면서 공간 정보를 잃는 단점을 **컨볼루션(Convolution)** 과 **풀링(Pooling)** 연산으로 보완한다.

### **컨볼루션 연산 (Convolution Operation)**
- **필터(Filter, 또는 커널)** 를 입력 데이터에 순차적으로 적용하며 **특징 맵(Feature Map)** 을 생성한다.
- 필터는 이미지의 특정 패턴(예: 윤곽선, 질감)을 감지하는 역할을 하며, 학습을 통해 최적의 값을 찾는다.
- **출력 데이터 크기**: `(n - f + 1) x (n - f + 1)`
  - `n`: 입력 크기, `f`: 필터 크기

<img src="https://www.researchgate.net/profile/Ihab_S_Mohamed/publication/324165524/figure/fig3/AS:611103423860736@1522709818959/An-example-of-convolution-operation-in-2D-2.png" width="500">

### **패딩(Padding) & 스트라이드(Stride)**
- **패딩**: 컨볼루션 연산 후 특징 맵의 크기가 줄어드는 것을 방지하고, 이미지 가장자리 정보를 보존하기 위해 입력 데이터 주변을 특정 값(주로 0)으로 채운다.
  - `same`: 패딩을 적용하여 입력과 출력의 크기를 동일하게 유지한다.
- **스트라이드**: 필터를 한 번에 이동시키는 간격을 의미한다. 스트라이드 값이 크면 특징 맵의 크기는 작아진다.

### **풀링 (Pooling)**
- 컨볼루션 연산으로 얻은 특징 맵의 크기를 줄여(Sub-sampling) 연산량을 감소시키고, 주요 특징을 강조하는 과정이다.
- **맥스 풀링(Max Pooling)**: 필터 영역 내에서 가장 큰 값만 추출한다. 모델이 이동, 회전 등 변화에 강인한 특징(이동 불변성)을 학습하도록 돕는다.
- 일반적으로 `kernel_size=2`, `stride=2`를 사용하여 특징 맵의 크기를 절반으로 줄인다.

<img src="https://cs231n.github.io/assets/cnn/maxpool.jpeg" width="600">

---

## 2. Fashion MNIST 분류 실습 🚀

Fashion MNIST 데이터셋을 사용하여 CNN 모델의 성능 발전 과정을 단계별로 실습했다.

### **데이터 준비**
- `torchvision`을 사용하여 Fashion MNIST 데이터셋을 로드하고, `DataLoader`를 통해 배치 단위로 데이터를 공급한다.

```python
import torch
import torch.nn as nn
import torch.optim as optim
import torchvision.datasets as dsets
import torchvision.transforms as transforms
from torch.utils.data import DataLoader

# 하이퍼파라미터 설정
batch_size = 64
learning_rate = 0.001
num_epochs = 20
device = 'cuda' if torch.cuda.is_available() else 'cpu'

# Fashion-MNIST 데이터셋 로드
train_dataset = dsets.FashionMNIST(root='DATA_URL', train=True, transform=transforms.ToTensor(), download=True)
test_dataset = dsets.FashionMNIST(root='DATA_URL', train=False, transform=transforms.ToTensor(), download=True)

# 데이터 로더 설정
train_loader = DataLoader(dataset=train_dataset, batch_size=batch_size, shuffle=True, drop_last=True)
test_loader = DataLoader(dataset=test_dataset, batch_size=batch_size, shuffle=False, drop_last=True)
```

### **1) Baseline: DNN 모델**
- 이미지를 1차원으로 펼쳐 완전 연결 계층(Dense Layer)만으로 구성한 기본 모델이다.
- **결과**: Test Accuracy `88.66%`

### **2) CNN (Convolution Layers)**
- DNN 모델 앞에 컨볼루션 레이어를 추가하여 공간적 특징을 추출했다.
- **결과**: Test Accuracy `88.37%` (DNN과 비슷하지만, 학습 과정이 더 안정적이다.)

### **3) CNN + Max Pooling**
- 컨볼루션 레이어 뒤에 맥스 풀링 레이어를 추가하여 특징을 압축하고 연산 효율을 높였다.
- **결과**: Test Accuracy `91.22%` (성능이 크게 향상되었다! 🎉)

### **4) CNN + Max Pooling + Deeper DNN**
- 특징 추출 후, 더 깊은 완전 연결 계층을 추가하여 복잡한 패턴을 학습하도록 했다.
- **결과**: Test Accuracy `91.97%` (정확도가 소폭 상승했지만, 과적합의 위험이 보인다.)

---

## 3. 모델 성능 개선 기법 ✨

과적합을 방지하고 모델의 안정성과 성능을 높이기 위해 다음과 같은 기법들을 적용했다.

### **Dropout (드롭아웃)**
- 학습 과정에서 **무작위로 뉴런의 일부를 비활성화**하여 모델이 특정 뉴런에 과도하게 의존하는 것을 막는다. 이는 과적합을 방지하는 규제(Regularization) 효과를 준다.

### **Batch Normalization (배치 정규화)**
- 각 레이어의 입력 데이터 분포를 미니배치 단위로 정규화하여 학습 과정을 안정시키고 속도를 높인다.
- **내부 공변량 변화(Internal Covariate Shift)** 문제를 완화하여 기울기 소실/폭주를 방지하고, 모델이 더 안정적으로 수렴하도록 돕는다.

### **최종 모델 (CNN + Pooling + Dropout + Batch Norm + Early Stopping)**
- 위의 모든 기법을 적용하고, 검증 손실이 더 이상 개선되지 않으면 학습을 조기 종료(Early Stopping)하는 콜백을 추가하여 불필요한 학습을 막았다.

```python
class CNN(nn.Module):
  def __init__(self):
    super(CNN, self).__init__()
    # CNN Layers
    self.layer1 = nn.Sequential(
        nn.Conv2d(1, 32, kernel_size=3, padding=1),
        nn.BatchNorm2d(32),
        nn.ReLU(),
        nn.MaxPool2d(2),
        nn.Dropout(0.3)
    )
    self.layer2 = nn.Sequential(
        nn.Conv2d(32, 64, kernel_size=3, padding=1),
        nn.BatchNorm2d(64),
        nn.ReLU(),
        nn.MaxPool2d(2),
        nn.Dropout(0.3)
    )
    # DNN Layers
    self.fc1 = nn.Linear(64 * 7 * 7, 256)
    self.bn1 = nn.BatchNorm1d(256)
    self.relu1 = nn.ReLU()
    self.dropout1 = nn.Dropout(0.3)
    # ... (이후 DNN 레이어 생략) ...
    self.fc4 = nn.Linear(64, 10)

  def forward(self, x):
    x = self.layer1(x)
    x = self.layer2(x)
    x = x.view(x.size(0), -1) # flatten
    # ... (이후 DNN 레이어 forward 과정 생략) ...
    x = self.fc4(x)
    return x
```
- **최종 결과**: Test Accuracy **`~93%`** (모델이 안정적으로 높은 성능을 달성했다. 👍)

---

## 4. 최종 요약 ✍️
- **CNN**은 컨볼루션과 풀링 연산을 통해 이미지의 공간 정보를 효과적으로 학습한다.
- **맥스 풀링**은 모델의 성능과 연산 효율을 높이는 데 핵심적인 역할을 한다.
- **드롭아웃**과 **배치 정규화**는 과적합을 방지하고 학습을 안정화시켜 더 깊고 복잡한 모델을 훈련할 수 있게 돕는다.
- 단순한 DNN에서 시작하여 CNN의 여러 구성 요소를 점진적으로 추가하며 각 기법이 모델 성능에 미치는 영향을 확인하는 체계적인 실험을 통해, 최종적으로 93%에 가까운 높은 정확도를 달성할 수 있었다.

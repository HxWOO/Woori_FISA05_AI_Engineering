# 📈PyTorch 시계열 예측

## Summary
1. **시계열 데이터의 이해:** 시계열 데이터의 4가지 주요 특징(트렌드, 계절성, 자기 상관, 잡음)을 학습했다.
2. **기초 예측 모델:** 단순 예측, 이동 평균 등 통계적 기반의 시계열 예측 방법을 알아보았다.
3. **DNN을 이용한 예측:** 윈도우 데이터셋을 구성하고, DNN 모델을 구축하여 시계열을 예측하는 방법을 학습했다.
4. **CNN을 이용한 예측:** 1D CNN을 활용하여 시계열 데이터의 패턴을 추출하고 예측하는 모델을 구현했다.
5. **RNN을 이용한 예측:** 순환 신경망(RNN)의 구조를 이해하고, 주식 데이터(AAPL)를 이용해 시계열을 예측하는 모델을 구축했다.
6. **LSTM을 이용한 예측:** RNN의 장기 의존성 문제를 해결하는 LSTM의 구조와 구현 방법을 학습했다.

## 1. 시계열(Time Series) 데이터의 이해

시간 간격을 두고 있는 일련의 데이터로, 주가, 날씨 예보 등이 대표적인 예시다.

### 시계열의 4가지 공통 특징
- **트렌드 (Trend):** 데이터가 장기적으로 상승하거나 하강하는 등의 특정 방향성을 갖는 것이다.
- **계절성 (Seasonality):** 주, 월, 년 등 특정 주기로 패턴이 반복되는 것이다.
- **자기 상관 (Autocorrelation):** 이전 시점의 데이터가 이후 시점의 데이터에 영향을 미치는 것이다.
- **잡음 (Noise):** 예측 불가능한 임의의 변동이다.

![시계열 특징](https://i.imgur.com/Sl7inQd.png)

## 2. 시계열 데이터 생성 및 분할

- **데이터 생성:** `Numpy`를 사용하여 트렌드, 계절성, 잡음을 포함한 인공 시계열 데이터를 생성했다.
- **데이터 분할:** 생성된 데이터를 훈련 데이터(train)와 검증 데이터(test)로 분할하여 모델 학습 및 평가에 사용했다.

```python
# 시계열 데이터 생성을 위한 함수 정의
import numpy as np
import matplotlib.pyplot as plt

def trend(time, slope=0):
    return slope * time

def seasonal_pattern(season_time):
    return np.where(season_time < 0.4,
                    np.cos(season_time * 2 * np.pi),
                    1 / np.exp(3 * season_time))

def seasonality(time, period, amplitude=1, phase=0):
    season_time = ((time + phase) % period) / period
    return amplitude * seasonal_pattern(season_time)

def noise(time, noise_level=1, seed=None):
    rnd = np.random.RandomState(seed)
    return rnd.randn(len(time)) * noise_level

# 4년치 시계열 데이터 생성
time = np.arange(4 * 365 + 1, dtype="float32")
baseline = 10
amplitude = 15
noise_level = 6
series = baseline + trend(time, 0.05) + seasonality(time, period=365, amplitude=amplitude)
series += noise(time, noise_level, seed=42)

# 훈련/검증 데이터 분할 (3년 / 1년)
train_len = int(len(series) * 3/4)
train_series = series[:train_len]
test_series = series[train_len:]
```

## 3. 기초 예측 모델

### 가. 단순 예측 (Naive Forecast)
- **정의:** `t-1` 시점의 값으로 `t` 시점의 값을 예측하는 가장 간단한 방법이다.
- **평가:** MSE: 78.34, MAE: 6.99. 역시 단순해서 성능은 별로다. 😥

### 나. 이동 평균 (Moving Average)
- **정의:** 특정 기간(`window_size`) 동안의 데이터 평균으로 다음 시점의 값을 예측한다.
- **평가 (window_size=7):** MSE: 31.83, MAE: 4.52. 단순 예측보다는 훨씬 낫다! 👍

### 다. 개선된 이동 평균
- **정의:** 계절성을 고려하여 `t` 시점의 값에서 `t-365`의 값을 빼 트렌드와 계절성을 줄인 후 이동 평균을 적용했다.
- **평가:** MSE: 25.79, MAE: 0.26. 성능이 대폭 개선되었다. 🎉

## 4. 딥러닝을 이용한 시계열 예측

### 가. 윈도우 데이터셋 (Windowed Dataset)
- **정의:** 시계열 데이터를 일정 길이의 `window`로 잘라 입력(X)과 타겟(y)을 만든다.
- **PyTorch `Dataset` 활용:** `torch.utils.data.Dataset`을 상속받아 윈도우 데이터셋을 생성하고, `DataLoader`로 배치 처리를 수행한다.

```python
from torch.utils.data import Dataset, DataLoader

class WindowedDataset(Dataset):
    def __init__(self, data, window_size, shift):
        self.data = data
        self.window_size = window_size
        self.shift = shift
        # 데이터를 윈도우 크기에 맞게 잘라 리스트로 저장
        self.windows = [data[i:i+window_size+1] for i in range(0, len(data)-window_size, shift)]

    def __len__(self):
        return len(self.windows)

    def __getitem__(self, idx):
        window = self.windows[idx]
        # 윈도우의 마지막 값을 레이블로, 그 이전까지를 데이터로 반환
        return window[:-1], window[-1:]

# 파라미터 설정 및 DataLoader 생성
window_size = 20
batch_size = 16
train_dataloader = DataLoader(WindowedDataset(train_series, window_size, 1), batch_size, shuffle=False)
```

### 나. DNN (Deep Neural Network) 모델
- **구조:** 여러 개의 `Linear` 레이어와 `ReLU` 활성화 함수로 구성된 간단한 심층 신경망이다.
- **학습:** `MSELoss`를 손실 함수로, `Adam` 옵티마이저를 사용하여 모델을 훈련했다.
- **평가:** MSE: 42.65, MAE: 5.20. 생각보다 성능이 좋지는 않았다. 🤔

```python
import torch.nn as nn
import torch.optim as optim

class DNN(nn.Module):
    def __init__(self, window_size):
        super(DNN, self).__init__()
        self.fc1 = nn.Linear(window_size, 128)
        self.relu1 = nn.ReLU()
        self.fc2 = nn.Linear(128, 64)
        self.relu2 = nn.ReLU()
        self.fc3 = nn.Linear(64, 1)

    def forward(self, x):
        x = self.relu1(self.fc1(x))
        x = self.relu2(self.fc2(x))
        return self.fc3(x)
```

### 다. 1D CNN (Convolutional Neural Network) 모델
- **구조:** `Conv1d` 레이어를 사용하여 시계열 데이터에서 지역적인 패턴을 추출하고, `MaxPool1d`로 특징을 압축한다.
- **특징:** 시계열의 복잡한 패턴을 효과적으로 학습할 수 있다.
- **평가:** MSE: 44.18, MAE: 5.32. DNN과 비슷한 수준의 성능을 보였다.

```python
class CNN1DModel(nn.Module):
    def __init__(self, window_size):
        super(CNN1DModel, self).__init__()
        self.conv1d1 = nn.Conv1d(1, 32, 3)
        self.relu1 = nn.ReLU()
        self.pool1 = nn.MaxPool1d(kernel_size=2)
        self.conv1d2 = nn.Conv1d(32, 64, 3)
        self.relu2 = nn.ReLU()
        self.pool2 = nn.MaxPool1d(kernel_size=2)
        self.fc1 = nn.Linear(64 * 3, 32)
        self.fc2 = nn.Linear(32, 1)

    def forward(self, x):
        x = x.unsqueeze(1) # 채널 차원 추가
        x = self.pool1(self.relu1(self.conv1d1(x)))
        x = self.pool2(self.relu2(self.conv1d2(x)))
        x = x.view(x.size(0), -1) # Flatten
        x = self.fc1(x)
        return self.fc2(x)
```

### 라. RNN (Recurrent Neural Network) 모델
- **구조:** 순서가 있는 데이터를 처리하기 위한 신경망으로, 이전 스텝의 출력이 다음 스텝의 입력으로 사용되는 '되먹임 구조'를 가진다.
- **활용:** 시계열, 자연어 처리 등 순차적인 데이터에 적합하다.
- **AAPL 주식 예측:** `yfinance` 라이브러리로 AAPL 주식 데이터를 받아와 종가를 예측하는 RNN 모델을 구현했다. 📈

![RNN 구조](https://colah.github.io/posts/2015-08-Understanding-LSTMs/img/RNN-unrolled.png)

```python
# AAPL 주식 데이터셋 클래스
class Apple(Dataset):
    def __init__(self):
        self.csv = pd.read_csv('./aapl.csv')
        # 데이터 정규화
        self.data = self.csv.iloc[:, :3].values / np.max(self.csv.iloc[:, :3].values)
        self.label = self.csv['Close'].values / np.max(self.csv['Close'].values)

    def __len__(self):
        return len(self.data) - 30 # window_size

    def __getitem__(self, i):
        data = self.data[i:i+30]
        label = self.label[i+30]
        return data, label

# RNN 모델 정의
class RNN(nn.Module):
    def __init__(self, input_size, hidden_size, num_layers, seq_size):
        super(RNN, self).__init__()
        self.rnn = nn.RNN(input_size, hidden_size, num_layers, batch_first=True)
        self.fc1 = nn.Linear(seq_size * hidden_size, 64)
        self.output = nn.Linear(64, 1)
        self.relu = nn.ReLU()

    def forward(self, x, h0=None):
        if h0 is None:
            h0 = torch.zeros(self.rnn.num_layers, x.size(0), self.rnn.hidden_size).to(x.device)
        x, hn = self.rnn(x, h0)
        x = torch.reshape(x, (x.shape[0], -1))
        x = self.relu(self.fc1(x))
        x = self.output(x)
        return torch.flatten(x)
```

## 5. LSTM (Long Short-Term Memory) 모델

- **정의:** LSTM은 RNN의 장기 의존성 문제(기울기 소실/폭주)를 해결하기 위해 제안된 모델이다. '셀 상태(Cell State)'라는 명시적인 메모리 유닛과 '게이트(Gate)' 메커니즘을 도입하여 정보의 흐름을 효과적으로 제어한다.

- **핵심 구조:**
    - **셀 상태 (Cell State):** 컨베이어 벨트처럼 네트워크 전체를 관통하며 정보를 전달하는 핵심 부분이다.
    - **게이트 (Gates):** 셀 상태에 정보를 추가하거나 제거하는 역할을 하는 신경망 레이어들이다.
        - **망각 게이트 (Forget Gate):** 과거 정보 중 어떤 것을 잊을지 결정한다.
        - **입력 게이트 (Input Gate):** 새로 들어온 정보 중 어떤 것을 셀 상태에 저장할지 결정한다.
        - **출력 게이트 (Output Gate):** 셀 상태를 기반으로 어떤 값을 출력할지 결정한다.

![LSTM 구조](https://colah.github.io/posts/2015-08-Understanding-LSTMs/img/LSTM3-chain.png)

### LSTM 모델 구현

- **PyTorch `nn.LSTM`:** `nn.RNN`과 유사하게 `nn.LSTM` 모듈을 사용하여 LSTM 레이어를 구성할 수 있다.
- **`h0`, `c0`:** RNN과 달리 LSTM은 은닉 상태(`h0`)와 셀 상태(`c0`) 두 가지를 초기화해야 한다.

```python
import torch.nn as nn

class LSTM(nn.Module):
    def __init__(self, input_size, hidden_size, num_layers, seq_size):
        super(LSTM, self).__init__()
        self.lstm = nn.LSTM(input_size=input_size,
                            hidden_size=hidden_size,
                            num_layers=num_layers,
                            batch_first=True)
        self.fc1 = nn.Linear(in_features=seq_size * hidden_size, out_features=64)
        self.fc2 = nn.Linear(in_features=64, out_features=1)
        self.relu = nn.ReLU()

    def forward(self, x, h0, c0):
        # (h0, c0)를 함께 전달
        x, (hn, cn) = self.lstm(x, (h0, c0))
        x = torch.reshape(x, (x.shape[0], -1))
        x = self.relu(self.fc1(x))
        x = self.fc2(x)
        return x

# 학습 시 h0와 c0를 모두 초기화
# h0 = torch.zeros(num_layers, batch_size, hidden_size).to(device)
# c0 = torch.zeros(num_layers, batch_size, hidden_size).to(device)
# preds = model(data, h0, c0)
```

## 추가 정보
- **데이터 정규화:** RNN/LSTM과 같은 모델에서는 기울기 소실/폭주를 방지하기 위해 입력 데이터를 스케일링(e.g., Min-Max Scaling)하는 것이 중요하다.
- **`batch_first=True`:** PyTorch의 RNN/LSTM 레이어에서 이 옵션을 사용하면 입력 텐서의 차원을 `(배치 크기, 시퀀스 길이, 특징 차원)` 순서로 처리할 수 있어 편리하다.
- **조기 종료 (Early Stopping):** 검증 손실(validation loss)이 더 이상 개선되지 않을 때 학습을 조기에 중단시키는 기법으로, 불필요한 학습을 방지하고 과적합을 줄일 수 있다.

```python
class EarlyStopping:
    def __init__(self, patience=5, min_delta=0):
        self.patience = patience
        self.min_delta = min_delta
        self.counter = 0
        self.best_loss = None
        self.early_stop = False

    def __call__(self, val_loss):
        if self.best_loss is None:
            self.best_loss = val_loss
        elif val_loss < self.best_loss - self.min_delta:
            self.best_loss = val_loss
            self.counter = 0
        else:
            self.counter += 1
            if self.counter >= self.patience:
                self.early_stop = True
```
# 📅 3주차 - 11일차

## 📊 Plotly: 인터랙티브 시각화의 강자

- **정의**: 사용자와 상호작용할 수 있는(인터랙티브) 동적 그래프를 손쉽게 만들어주는 파이썬 시각화 라이브러리.

---

### 1. Plotly의 주요 특징 ✨

| 특징 | 설명 |
| :--- | :--- |
| **인터랙티브** | 마우스를 올리면 데이터가 표시(Hover)되고, 특정 부분을 확대(Zoom)하거나, 범례를 클릭해 데이터를 숨기고 볼 수 있음. |
| **다양한 차트** | 기본적인 막대, 선, 산점도부터 3D, 지도, 통계, 금융 차트까지 폭넓게 지원. |
| **JSON 기반** | 모든 그래프는 JSON 데이터 구조로 표현됨. 웹 환경에서 데이터를 다루기 용이. |
| **쉬운 Export** | 그래프를 HTML, PNG, JPG, SVG, PDF 등 다양한 형식으로 쉽게 저장하고 공유할 수 있음. |
| **오픈 소스** | 무료로 사용 가능하며, 커뮤니티가 활발해 지속적으로 발전하고 있음. |

---

### 2. Plotly 핵심 모듈 임포트 📦

- Plotly는 기능에 따라 여러 하위 모듈로 나뉘어 있음. 목적에 맞게 필요한 모듈을 불러와 사용.

```python
# Plotly 핵심 모듈
import plotly.io as pio            # 그래프 입출력 (저장, 표시)
import plotly.express as px        # 빠르고 간결한 고수준 인터페이스 (추천)
import plotly.graph_objects as go  # 세밀한 제어가 가능한 저수준 인터페이스
import plotly.figure_factory as ff # 복잡한 템플릿 차트 (덴드로그램 등)
from plotly.subplots import make_subplots # 여러 그래프를 한 번에 그리기
```

---

### 3. Plotly로 그래프 그리는 3가지 방법 🎨

#### 1) `dict` 형식 (저수준)
- 그래프의 데이터와 레이아웃을 파이썬 딕셔너리 형태로 직접 정의.
- 구조가 복잡해 거의 사용하지 않지만, Plotly의 기본 데이터 구조를 이해하는 데 도움됨.

```python
fig = dict({
    "data": [{"type": "bar", 'x': [1, 2, 3], 'y': [1, 3, 2]}],
    "layout": {"title": {"text": "딕셔너리로 그린 막대 그래프"}}
})
pio.show(fig)
```

#### 2) `plotly.express` (고수준, **강력 추천**)
- `px`라는 별칭으로 사용하며, 가장 쉽고 빠르게 그래프를 만드는 방법.
- 적은 코드로 직관적이고 아름다운 그래프를 만들 수 있어 데이터 탐색(EDA)에 매우 유용.

```python
import plotly.express as px
tips = px.data.tips()
fig = px.scatter(tips, x='total_bill', y='tip', color='sex',
                 title='팁 데이터 산점도',
                 hover_data=['day', 'size'])
fig.show()
```

#### 3) `plotly.graph_objects` (저수준)
- `go`라는 별칭으로 사용하며, 그래프의 모든 요소를 객체로 다루어 세밀하게 제어할 수 있음.
- 여러 그래프를 겹쳐 그리거나, 복잡한 맞춤형 시각화가 필요할 때 사용.

```python
import plotly.graph_objects as go
fig = go.Figure(
    data=[go.Bar(x=[1, 2, 3], y=[3, 1, 2])],
    layout=go.Layout(title=go.layout.Title(text="Graph Objects로 그린 막대 그래프"))
)
fig.show()
```

---

### 4. `Figure` 객체: 그래프의 모든 것 🖼️

- Plotly에서 그려지는 모든 그래프는 `Figure` 객체에 의해 관리됨.
- `Figure`는 크게 **데이터(Data)**와 **레이아웃(Layout)** 두 부분으로 구성됨.

| 구분 | 역할 | 주요 메서드 |
| :--- | :--- | :--- |
| **`data`** | 실제 그래프를 구성하는 데이터. (e.g., `go.Scatter`, `go.Bar`) | `add_trace()`: 새 그래프(trace) 추가 |
| **`layout`** | 그래프의 제목, 축, 범례, 폰트 등 시각적 요소를 설정. | `update_layout()`: 레이아웃 속성 업데이트 |

---

### 5. 다양한 차트 종류 📈

| 차트 종류 | `plotly.express` 함수 | 설명 |
| :--- | :--- | :--- |
| **산점도 (Scatter Plot)** | `px.scatter()` | 두 변수 간의 관계를 점으로 표현. |
| **선 그래프 (Line Plot)** | `px.line()` | 시간의 흐름에 따른 데이터 변화(시계열)에 적합. |
| **막대 그래프 (Bar Chart)** | `px.bar()` | 범주형 데이터의 크기를 비교. |
| **히스토그램 (Histogram)** | `px.histogram()` | 연속형 데이터의 분포를 구간별로 확인. |
| **박스 플롯 (Box Plot)** | `px.box()` | 데이터의 사분위수, 이상치 등 통계적 분포를 요약. |
| **파이 차트 (Pie Chart)** | `px.pie()` | 전체에 대한 각 부분의 비율을 표시. |
| **지도 (Maps)** | `px.choropleth()` | 지리적 데이터 시각화. |
| **트리맵 (Treemap)** | `px.treemap()` | 계층 구조 데이터를 사각형으로 표현. |
| **선버스트 (Sunburst)** | `px.sunburst()` | 계층 구조를 원형으로 표현. |

---

### 📚 오늘 배운 것 요약

- **Plotly**는 사용자와 상호작용하는 **인터랙티브 그래프**를 만드는 데 특화된 라이브러리.
- 그래프는 주로 `plotly.express` (빠르고 쉬움) 또는 `plotly.graph_objects` (세밀한 제어)를 사용해 만듦.
- 모든 Plotly 그래프는 `Figure` 객체이며, 이는 **`data`**와 **`layout`**으로 구성됨.
- 산점도, 선, 막대 그래프 외에도 지도, 트리맵 등 복잡한 시각화까지 폭넓게 지원함.

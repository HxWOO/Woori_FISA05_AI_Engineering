# 📅 2주차 - 6일차

---
## 🐍 파이썬 모듈과 패키지: 깔끔한 코드 관리를 위한 핵심

 - 파이썬은 **모듈(Module)**과 **패키지(Package)**라는 두 가지 핵심적인 기능을 제공함
 -  이 둘을 사용하면 코드의 구조를 체계적으로 만들고, 유지보수를 쉽게 할 수 있습니다.

---

### 1. 모듈 (Module) 📦

모듈은 간단히 말해 **하나의 파이썬 파일 (`.py`)**. 관련된 함수, 클래스, 변수들을 하나의 파일에 모아놓은 것

#### ✨ 특징
- **코드 재사용성**: 한번 만들어 둔 모듈은 어떤 파이썬 프로그램에서든 `import` 키워드를 통해 가져와 사용할 수 있음
- **네임스페이스(Namespace) 관리**: 모듈을 사용하면 다른 모듈의 코드와 이름이 겹치는 것을 방지할 수 있습니다. 예를 들어, `my_module.py` 안의 `my_function()`은 `my_module.my_function()`으로 호출되므로 다른 파일의 `my_function()`과 충돌하지 않음
- **단순성**: 기능별로 코드를 파일 단위로 분리하므로 전체 프로젝트 구조가 단순하고 명확해짐

#### 📝 사용 예시

1.  **`my_math.py` 모듈 파일 생성**
    ```python
    # 파일명: my_math.py

    PI = 3.14159

    def add(a, b):
        """두 숫자를 더합니다."""
        return a + b

    def subtract(a, b):
        """두 숫자를 뺍니다."""
        return a - b
    ```

2.  **`main.py`에서 모듈 사용**
    ```python
    # 파일명: main.py
    import my_math

    # 모듈의 변수와 함수 사용
    print(f"원주율: {my_math.PI}")
    print(f"5 + 3 = {my_math.add(5, 3)}")
    print(f"5 - 3 = {my_math.subtract(5, 3)}")

    # 출력:
    # 원주율: 3.14159
    # 5 + 3 = 8
    # 5 - 3 = 2
    ```

---

### 2. 패키지 (Package) 🗂️

패키지는 **모듈들을 모아놓은 디렉토리**입니다. 관련된 여러 모듈들을 하나의 디렉토리 구조로 묶어 관리할 때 사용한다.

#### ✨ 특징
- **계층적 구조**: 패키지는 디렉토리와 서브 디렉토리를 이용해 코드를 계층적으로 구성할 수 있음 (예: `game.sound.echo`)
- **모듈화 강화**: 기능이 복잡하고 규모가 큰 프로젝트에서 관련된 모듈들을 하나의 패키지로 묶어 관리하므로, 코드의 응집도를 높이고 다른 패키지와의 결합도를 낮춤
- **배포 용이성**: 패키지 단위로 코드를 배포하고 관리하기 편리

> **참고**: 파이썬이 특정 디렉토리를 패키지로 인식하게 하려면, 해당 디렉토리 안에 `__init__.py` 라는 파일이 있는 것이 좋다. (Python 3.3 이상부터는 필수는 아니지만, 하위 호환성과 명확성을 위해 포함하는 것이 좋다.)

#### 📝 사용 예시

1.  **`my_calculator` 패키지 구조 생성**
    ```
    my_calculator/
    ├── __init__.py       # 이 디렉토리가 패키지임을 알림 (내용은 비어있어도 됨)
    ├── addition.py       # 덧셈 모듈
    └── subtraction.py    # 뺄셈 모듈
    ```

2.  **각 모듈 파일 작성**
    ```python
    # 파일명: my_calculator/addition.py
    def add(a, b):
        return a + b
    ```
    ```python
    # 파일명: my_calculator/subtraction.py
    def subtract(a, b):
        return a - b
    ```

3.  **`main.py`에서 패키지 사용**
    ```python
    # 파일명: main.py
    from my_calculator import addition, subtraction

    # 패키지 내의 모듈 함수 사용
    result_add = addition.add(10, 5)
    result_sub = subtraction.subtract(10, 5)

    print(f"10 + 5 = {result_add}")
    print(f"10 - 5 = {result_sub}")

    # 출력:
    # 10 + 5 = 15
    # 10 - 5 = 5
    ```

---

### 🚀 모듈과 패키지 사용의 장점

- **코드 재사용성 및 생산성 향상**: 이미 만들어진 코드를 다시 사용하므로 개발 속도가 증진
- **유지보수 용이성**: 기능별로 코드가 분리되어 있어 특정 기능을 수정하거나 개선할 때 해당 파일만 보면 되므로 유지보수가 편리
- **가독성 및 협업 효율 증가**: 코드의 구조가 명확해져 다른 사람이 코드를 이해하기 쉽고, 여러 개발자가 각자 맡은 모듈을 개발하며 효율적으로 협업할 수 있음
- **이름 충돌 방지**: 독립된 네임스페이스를 제공하여 대규모 프로젝트에서 발생할 수 있는 변수나 함수의 이름 충돌 문제를 해결

---

### 📊 모듈 vs 패키지

| 구분 | 모듈 (Module) | 패키지 (Package) |
| :--- | :--- | :--- |
| **정의** | 하나의 파이썬 파일 (`.py`) | 모듈들을 모아놓은 디렉토리 |
| **구조** | 함수, 클래스, 변수의 모음 | `__init__.py` 파일을 포함한 디렉토리와 그 안의 모듈들 |
| **사용법**| `import module_name` | `from package_name import module_name` |
| **목적** | 코드의 재사용 및 분리 | 관련된 모듈들을 그룹화하여 계층적으로 관리 |

---

### 3. 예외 처리 (Exception Handling) 🚨

프로그램 실행 중 발생할 수 있는 오류(예외)에 대처하고, 프로그램이 비정상적으로 종료되는 것을 방지하는 기능.

#### ✨ 기본 구조 (try-except-else-finally)

```python
try:
    # 오류가 발생할 가능성이 있는 코드
    result = 10 / 0
except ZeroDivisionError as e:
    # 특정 오류가 발생했을 때 실행할 코드
    print(f"오류 발생: {e}")
except Exception as e:
    # 그 외 모든 오류가 발생했을 때 실행할 코드
    print(f"알 수 없는 오류: {e}")
else:
    # 오류가 발생하지 않았을 때 실행할 코드
    print("정상적으로 실행되었습니다.")
finally:
    # 오류 발생 여부와 상관없이 항상 실행할 코드
    print("프로그램을 종료합니다.")
```

#### 📝 주요 구문

- **try**: 예외 발생 가능성이 있는 코드 블록.
- **except**: 예외가 발생했을 때 이를 처리하는 코드 블록. 특정 예외 타입(e.g., `ValueError`, `TypeError`)을 지정할 수 있음.
- **else**: `try` 블록에서 예외가 발생하지 않았을 때만 실행되는 코드 블록.
- **finally**: 예외 발생 여부와 관계없이 항상 실행되는 코드 블록. 주로 리소스 정리(파일 닫기 등)에 사용됨.
- **raise**: 의도적으로 예외를 발생시킬 때 사용.

---

### 4. 클래스 (Class) 🏛️

**객체 지향 프로그래밍(OOP)**의 핵심 요소로, 데이터(속성)와 기능(메서드)을 하나로 묶은 **설계도**.

#### ✨ 특징
- **캡슐화(Encapsulation)**: 데이터와 기능을 클래스 안에 묶고, 외부 접근을 제한하여 정보를 보호함.
- **상속(Inheritance)**: 부모 클래스의 속성과 메서드를 자식 클래스가 물려받아 재사용하고 확장할 수 있음.
- **다형성(Polymorphism)**: 동일한 이름의 메서드가 다른 클래스에서 다른 방식으로 동작할 수 있음.

#### 📝 사용 예시

1.  **클래스 정의**
    ```python
    class Dog:
        # 클래스 변수 (모든 인스턴스가 공유)
        species = "Canis lupus familiaris"

        # 초기화 메서드 (인스턴스 생성 시 호출)
        def __init__(self, name, age):
            # 인스턴스 변수 (각 인스턴스에 고유)
            self.name = name
            self.age = age

        # 인스턴스 메서드
        def bark(self):
            return f"{self.name} says Woof!"

        def get_info(self):
            return f"{self.name} is {self.age} years old."
    ```

2.  **인스턴스 생성 및 사용**
    ```python
    # Dog 클래스의 인스턴스 생성
    my_dog = Dog("Buddy", 3)
    your_dog = Dog("Lucy", 5)

    # 메서드 호출
    print(my_dog.bark())          # Buddy says Woof!
    print(your_dog.get_info())    # Lucy is 5 years old.

    # 속성 접근
    print(my_dog.name)            # Buddy
    print(Dog.species)            # Canis lupus familiaris
    ```

#### 📊 주요 용어

| 용어 | 설명 |
| :--- | :--- |
| **클래스(Class)** | 객체를 만들기 위한 설계도 또는 틀. |
| **객체(Object)** | 클래스로부터 생성된 실체. 인스턴스(Instance)라고도 함. |
| **속성(Attribute)** | 클래스 또는 인스턴스가 가지는 데이터. (변수) |
| **메서드(Method)** | 클래스 내에 정의된 함수. 객체의 동작을 정의함. |
| **`__init__`** | 객체가 생성될 때 초기화를 위해 호출되는 특별 메서드(생성자). |
| **`self`** | 인스턴스 자기 자신을 가리키는 참조. 메서드의 첫 번째 인자로 항상 전달됨. |
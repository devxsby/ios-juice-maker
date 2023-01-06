## 쥬스메이커
> Avery, Jenna

　
# 🧃 Step1
### Fruits
|   |요약|
|:--:|:--|
|구현사항|- 재료가 되는 과일의 종류에 대한 열거형<br>- CaseIterable프로토콜 채택으로 타입변수 allCases를 생성
|고민·해결|- 역할과 상호작용을 고려하여 중첩타입에서 독립된 모델로 분리|

### Juice
|   |요약|
|:--:|:--|
|구현사항|- 과일로 만드는 쥬스의 종류에 대한 열거형<br>- 재료조합명을 String원시값으로 가짐<br>- case별로 필요한 재료의 수량을 딕셔너리로 저장(`recipe`)
|고민·해결|- 역할과 상호작용을 고려하여 중첩타입에서 독립된 모델로 분리|

### FruitStore
|   |요약|
|:--:|:--|
|구현사항|- 과일의 재고를 관리하는 클래스<br>- 생성 시, 딕셔너리 `stocks`에 `Fruits`의 `allCases`요소들을 key로, 기본값(10)을 value로 갖는 재고 쌍을 저장<br>- 싱글턴 패턴 적용: 통일된 단 하나의 창고객체가 필요하므로 과일저장소를 싱글턴 클래스로 구현
|고민·해결|- final 싱글턴 클래스로 변경<br>- 행위는 메서드에 위임하고 프로퍼티를 private화|

### JuiceMaker
|   |요약|
|:--:|:--|
|구현사항|- 주문이 들어온 쥬스를 만들 수 있는지 확인하고 제조하는 구조체<br>- FruitStore의 유일한 인스턴스(`fruitStore`)를 소유<br>- 현재 단계에서는 외부에서 호출될 일이 없는 속성과 메서드를 `private`으로 선언
|고민·해결|- MVC 각각이 가져갈 작업의 범위에 대한 고민|

 　

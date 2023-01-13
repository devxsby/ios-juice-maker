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

 　
  
# 🧃 Step2~3
## 폴더링
- M, V, C의 역할을 고려하여 아래와 같이 폴더링했습니다.
- 같은 모델 중에서도 비즈니스로직에 관련된 기능을 분담하고 있는 FruitStore, JuiceMaker는 Service로서 분리했습니다.
   <img width="252" alt="image" src="https://user-images.githubusercontent.com/67406889/212217813-dd4a446f-ab02-4481-8500-2cfc602bd559.png">

## 에러와 얼럿
### 1. 에러
- 유의미하게 다뤄야 할 에러가 1종류(필요한 재고가 충분치 않을 경우)뿐이며, 이 에러의 용도나 시점은 얼럿으로 대체 가능했습니다.
- 에러구현을 위한 에러를 지양하기 위해 별도의 에러 정의 없이 '주문 실패 시 얼럿'으로 구현했습니다.<br>
(+ 사용자 편의성을 위해 주문이 불가능한 메뉴의 버튼이 회색으로 표시되도록 하였습니다)

   <img width="700" alt="image" src="https://user-images.githubusercontent.com/67406889/212219790-49872b60-23dc-4957-8572-22fc2069cbe2.png">

### 2. 얼럿
얼럿은 요구사항에 따라 2가지로 구현했습니다.
   - `presentSuccessAlert(menu:)` - 주문성공(=쥬스제조완료)안내
   - `presentFailAlert()` - 주문실패안내 & 재고수정묻기

　
## 화면전환과 데이터전달
### 1. 화면전환
`push-pop` → `present-dismiss`
- push-pop으로 했던 이유) 기본적으로 스택으로 쌓이는 네비게이션 컨트롤러가 임베드 된 StoreVC와 연결하여 navigationBarItem 의 backButtonItem과 추후에 생길 완료버튼을 넣을 rightButtonItem을 사용하기 위함
- present-dismiss로 변경한 이유) 위 생각이 크게 달라지지는 않았지만, 재고수정은 '주문하기'에서 잠시 벗어났다가 작업을 끝내면 되돌아오는 흐름을 전제로 하는 뷰라는 점 & '반영하지 않고 돌아가기(backButtonItem)' 버튼을 만들 필요가 없게 되었음을 고려하여 변경

### 2. 데이터전달 
`OrderVC`가 `OrderDelegate`를, `StoreVC`가 `StoreDelegate`를 각각 채택
- 델리게이트 패턴을 사용해 FruitStore 싱글턴 인스턴스의 `stocks`(과일재고)의 변동사항을 각 VC에서 공유받도록 했습니다.
- 각 VC의 특정 메서드나 화면전환 시점이 아니라(VC를 기준으로 하지 않고), stocks의 속성감시자 내에 각 VC의 대리자를 심어둠으로써 실시간 연동에 초점을 맞춰 구현했습니다.

　
 　
# 🧃 구현 결과
## 실행 영상
https://user-images.githubusercontent.com/67406889/212216165-120f1579-b29d-40d5-a8fc-2a2fa4da1239.mp4

　
## UML
(View 제외)<br>
<img width="805" alt="image" src="https://user-images.githubusercontent.com/67406889/212247333-783c57fa-41d7-4d06-9f8c-5f4e4b9c26b4.png">


　
 　

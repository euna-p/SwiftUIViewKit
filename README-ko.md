
# SwiftUIViewKit

조금 더 **손쉽게** UI를 작성하도록 돕는 프레임워크 입니다.

![](https://raw.githubusercontent.com/fallenlonelie/SwiftUIViewKit/main/Resources/preview.png)

## _UIView_ 클래스를 **SwiftUIViewKit**을 사용해 작성 해보세요.

```
import UIKit
import SwiftUIViewKit
class MyView: SwiftUIView {
    func body: UIView {
        UIVStackView {
            UILabel("blah")
            UIHStackView {
                UILabel("some title")
                    .priority(.required)
                UILabel("some description")
            }
        }
    }
}
```
> `UIVstackView`, `UIHStackView` 를 사용하여 수직 또는 수평의 선형 스택에 뷰 구성을 할 수 있습니다.
---
```
UIVStackView(alignment: .center, spacing: 12.0) {
    /* ANYTHING */
}
.distribution(.fillEqually)
```
> 스택 안에 들어갈 SubView 구성에 `UIStrackView`가 제공하는 `.spacing`, `.alignment`, 또는 `.distribution` 옵션을 적용할 수 있습니다.
---
```
UIView.spacer()
    .frame(maxWidth: .greatestFiniteMagnitude, horizontalAlignment: .right)
    .padding(.top, 12.0)
```
> 모든 `UIView`(상속된 자식 포함)는 `.frame`을 통해 크기를 조정할 수 있습니다. 또는 `.padding`을 사용하면 여백을 지정할 수 있습니다.
---
```
UIVScrollView {
    /*Any UIView*/
}
```
```
UIHScrollView {
    /*Any UIView*/
)
```
> `UIVScrollView` 또는 `UIHScrollView` 로 감싼 뷰는 스크롤이 가능해 집니다.
---
```
UILabel(
    UILabel(image: "ImageName(String literal) or UIImage object.")
    + UILabel("Big").font(.systemFont(ofSize: 20.0, weight: .regular))
    + UILabel("Small").font(.systemFont(ofSize: 10.0, weight: .regular))
)
```
> `UILabel`에 `+` 연산자를 함께 사용하면 손쉽게 서식있는 텍스트를 작성할 수 있습니다.
---
```
UIVScrollView {
    UILabel("some text")
    UIImageView(named: "imageName").renderingMode(.alwaysTemplate)
)
.color(.cyan)
```
> `.color`는 해당 `UIView`를 포함하여 내부에 포함된 모든 `UIView`를 찾고 색상 값을 적용합니다.
---
```
private let disposeBag = DisposeBag()
private let text      = BehaviorRelay<String>(value: "Now loading...")
private let imageName = BehaviorRelay<String>(value: "icn_default_place_holder")
private let color     = BehaviorRelay<Color>(value: .red)

var body: UIView {
    UIVScrollView {
        UILabel(self.text)
        UIImageView(named: self.imageName)
    )
    .color(self.color)
}
```
> Rx를 사용하면 반응형 UI를 쉽게 만들 수 있습니다.
---
```
someView.subscribe(someObservable) {view, element in
    /* blah */
}
```
> `.subscribe`를 통해 `Observable` 및 `Relay`를 수신한 후 뷰의 모습을 바꿔줄 수 있습니다.
---
```
someView.configure {view in
    /* blah */
}
```
> 아직 지원되지 않는 기능은 `UIView`의 `.configure`를 사용하여 사용자 정의할 수 있습니다.
---

# SwiftUIViewKit

Can more **EASILY** made UI.

![](https://raw.githubusercontent.com/fallenlonelie/SwiftUIViewKit/main/Resources/preview.png)

## Make _UIView_ class with **SwiftUIViewKit**.

```
import UIKit
import SwiftUIViewKit
class MyView: SwiftUIViewKit {
    func body: UIView {
        UIStackView.vstack(
            UILabel("blah"),
            UIStackView.hstack(
                UILabel("some title")
                    .priority(.required),
                UILabel("some description")
            )
        )
    }
}
```
> By default, layouts can be configured with Vertical or Horizontal and Linear using *UIStackView*.
---
```
UIStackView.vstack(
    /* ANYTHING */
)
.spacing(12.0)
.alignment(.center)
.distribution(.fillEqually)
```
> At this time, you can obtain the layout you want by utilizing the *.spacing*, *.alignment*, and *.distribution* of *UIStrackView*.
---
```
UIView.spacer()
    .frame(maxWidth: .greatestFiniteMagnitude, horizontalAlignment: .right)
    .padding(.top, 12.0)
```
> All UIViews (including inherited children) can be sized through *.frame*, or *.padding* allows you to specify margins.
---
```
UIScrollView.vscroll(
    /*Any UIView*/
)
```
```
UIScrollView.hscroll(
    /*Any UIView*/
)
```
> *UIScrollView* is also easy to use.
---
```
UILabel(
    UILabel("Big").font(.systemFont(ofSize: 20.0, weight: .regular))
    + UILabel("Small").font(.systemFont(ofSize: 10.0, weight: .regular))
)
```
> The `+` operator in *UILabel* makes it easy to formatted text.
---
```
UIStackView.vstack(
    UILabel("some text"),
    UIImageView(named: "imageName").renderingMode(.alwaysTemplate)
)
.color(.cyan)
```
> *.color* finds all the *UIView*s contained within, including the corresponding *UIView*, and applies the color value.
---
```
private let disposeBag = DisposeBag()
private let text      = BehaviorRelay<String>(value: "Now loading...")
private let imageName = BehaviorRelay<String>(value: "icn_default_place_holder")
private let color     = BehaviorRelay<Color>(value: .red)

var body: UIView {
    UIStackView.vstack(
        UILabel(self.text, by: self.disboseBag),
        UIImageView(named: self.imageName, by: disboseBag),
    )
    .color(self.color, by: self.disposeBag)
}
```
> Use Rx then You can easily made responsive UI.
---
```
someView.configure {view in
    /* blah */
}
```
> Features not yet supported can be customized using the *.configure* in UIView.
---
```
someView.subscribe(someObservable, by: disposeBag) {view, element in
    /* blah */
}
```
> Similarly, you can customize the behavior after receiving the *Observable*.
---

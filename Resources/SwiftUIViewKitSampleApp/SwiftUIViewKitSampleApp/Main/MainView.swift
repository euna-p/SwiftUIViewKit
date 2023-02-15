//
//  MainView.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/10.
//

import UIKit

import SwiftUIViewKit
import RxSwift
import RxRelay

class MainView: SwiftUIView {
    private let disposeBag = DisposeBag()
    private let viewModel = BehaviorRelay<MainViewModel>(value: .init())
    private let currentText = BehaviorRelay<String>(value: "")
}

//MARK: - SwiftUIViewKit
extension MainView {
    var body: UIView {
        UIStackView.vstack(
            UIImageView(named: "11213734")
                .contentMode(.scaleAspectFit)
                .priority(.required),
            UILabel(
                UILabel("Awesome!\n")
                    .font(.systemFont(ofSize: 20.0, weight: .bold))
                    .lineHeight(26.0)
                + UILabel("It's a Label...")
                    .font(.systemFont(ofSize: 14.0, weight: .thin))
                    .lineHeight(20.0)
            )
            .alignment(.center)
            .lineLimit(0)
            .color(.darkGray),
            DottedDivider(),
            UIScrollView.vscroll(
                UIStackView.vstack(
                    UILabel(self.viewModel.map({ $0.userText }), by: self.disposeBag)
                        .font(.systemFont(ofSize: 14.0, weight: .thin))
                        .lineLimit(0)
                        .lineHeight(20.0)
                        .color(.magenta),
                    UIStackView.hstack(
                        UITextField()
                            .bind(to: self.currentText, by: self.disposeBag)
                            .configuration {(tf: UITextField) in
                                tf.placeholder = "Input some text and click button!"
                            }
                            .padding(.all, 4.0)
                            .border(width: 1.0)
                            .border(color: .lightGray)
                            .corner(radius: 6.0)
                            .priority(.defaultHigh),
                        self.button(text: "CLICK!")
                            .onTapGesture(by: self.disposeBag) {[unowned self] in
                                self.viewModel.unwrappedValue.userText = self.currentText.value
                            }
                    )
                    .spacing(8.0),
                    Divider(),
                    UIStackView.hstack(
                        UILabel("CLICKER")
                            .font(.systemFont(ofSize: 16.0, weight: .bold)),
                        UIStackView.hstack(
                            self.button(text: "-")
                                .onTapGesture(by: self.disposeBag) {[unowned self] in
                                    self.viewModel.unwrappedValue.clickedCount -= 1
                                },
                            UILabel(self.viewModel.map({ String(format: "%lld", $0.clickedCount) }), by: self.disposeBag)
                                .font(.systemFont(ofSize: 14.0, weight: .thin))
                                .alignment(.center)
                                .color(self.viewModel.map({ $0.clickedCount < 0 ? .red : .green }), by: self.disposeBag),
                            self.button(text: "+")
                                .onTapGesture(by: self.disposeBag) {[unowned self] in
                                    self.viewModel.unwrappedValue.clickedCount += 1
                                }
                        )
                        .spacing(8.0)
                        .alignment(.center)
                        .priority(.required)
                    )
                    .spacing(8.0)
                    .alignment(.center),
                    Divider()
                )
                .spacing(16.0)
            )
        )
        .spacing(26.0)
        .padding(.top, 20.0)
        .padding(.horizontal, 16.0)
        .padding(.bottom, 12.0)
    }
    
    private func button(text: String) -> UIView {
        UILabel(text)
            .font(.systemFont(ofSize: 16.0, weight: .semibold))
            .color(.white)
            .alignment(.center)
            .priority(.required)
            .padding(.horizontal, 20.0)
            .padding(.vertical, 8.0)
            .background(.darkGray)
            .corner(radius: 6.0)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        MainView.view
            .previewDevice("iPhone 12 mini")
    }
}
#endif

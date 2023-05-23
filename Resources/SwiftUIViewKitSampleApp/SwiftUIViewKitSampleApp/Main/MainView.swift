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

    private let viewModel = MainViewModel.relay

    private let topIconSize        = BehaviorRelay<CGSize>(value: .zero)
    private let isTextFieldFocused = BehaviorRelay<Bool>(value: false)
    private let currentText        = BehaviorRelay<String>(value: "")
    
    let didTappedNavigateToSecondView = PublishRelay<Void>()
    
    var body: UIView {
        UIVScrollView {
            UIVStackView(spacing: 26.0) {
                self.topView
                UIDottedDivider()
                    .setPattern(line: 8.0, space: 2.0)
                UIVStackView(spacing: 16.0) {
                    self.textFieldSampleView
                    UIDivider(lineWeight: 1.0)
                    self.clickerSampleView
                    UIDivider(lineWeight: 1.0)
                    self.navigateToSecondViewButton
                    
                    //NOTE: - Use "for~in" and "if~else".
                    UIDivider(lineWeight: 1.0).color(.red)
                    UIHStackView {
                        for i in 1...10 {
                            if i == 1 || i == 10 {
                                UILabel("\(i)")
                                    .font(.systemFont(ofSize: 12.0, weight: .bold))
                            } else {
                                UILabel("\(i)")
                                    .font(.systemFont(ofSize: 12.0, weight: .thin))
                            }
                        }
                    }
                    .distribution(.equalSpacing)
                    .color(.lightGray)
                    
                    Subscriber(self.isTextFieldFocused, by: self.disposeBag) {
                        if $0 {
                            UILabel("Textfield is Focused!")
                        } else {
                            UILabel("...")
                        }
                    }
                }
            }
            .padding(.top, 20.0)
            .padding(.horizontal, 16.0)
            .padding(.bottom, 12.0)
        }
    }
}

//MARK: - Subviews
extension MainView {
    private var topView: UIView {
        UIVStackView(spacing: 24.0) {
            UIImageView(named: "11213734")
                .contentMode(.scaleAspectFit)
                .onResize(to: self.topIconSize, by: self.disposeBag)
                .corner(radius: self.topIconSize.map({ $0.width / 2.0 }), by: self.disposeBag)
                .border(width: 3.0)
                .border(color: .magenta)
                .priority(.required)
                .frame(maxWidth: .greatestFiniteMagnitude)
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
            .color(.darkGray)
        }
    }
    
    private var textFieldSampleView: UIView {
        UIVStackView(spacing: 12.0) {
            UIHStackView(spacing: 8.0) {
                UIView()
                    .background(.gray)
                    .frame(width: 4.0)
                UILabel(
                    self.viewModel
                        .map { $0.userText }
                        .map { $0.isEmpty ? "Nothing..." : $0 },
                    by: self.disposeBag
                )
                .font(.systemFont(ofSize: 14.0, weight: .thin))
                .lineLimit(0)
                .lineHeight(20.0)
                .color(self.viewModel.map({ $0.userText.isEmpty ? .gray : .magenta }), by: disposeBag)
            }
            UILabel(self.currentText.map({ String(format: "Realtime Text = \"%@\"", $0) }), by: self.disposeBag)
                .font(.systemFont(ofSize: 12.0, weight: .thin))
                .lineLimit(0)
                .lineHeight(14.0)
                .lineBreak(.byCharWrapping)
                .color(.gray)
            UIHStackView(spacing: 8.0) {
                UITextField()
                    .bind(to: self.currentText, by: self.disposeBag)
                    .configuration {(tf: UITextField) in
                        tf.placeholder = "Input some text and click button!"
                    }
                    .background(
                        UIDivider()
                            .color(self.isTextFieldFocused.map({ $0 ? .cyan : .lightGray }),
                                   by: self.disposeBag)
                            .frame(maxHeight: .greatestFiniteMagnitude,
                                   verticalAlignment: .bottom)
                    )
                    .onTapGesture(by: self.disposeBag) {gesture in
                        gesture.view?.becomeFirstResponder()
                    }
                    .addTarget(
                        by: self.disposeBag,
                        for: .editingDidBegin,
                        action: {[unowned self] in
                            self.isTextFieldFocused.accept(true)
                        }
                    )
                    .addTarget(
                        by: self.disposeBag,
                        for: [.editingDidEnd, .editingDidEndOnExit],
                        action: {[unowned self] in
                            self.isTextFieldFocused.accept(false)
                        }
                    )
                    .priority(.defaultHigh)
                self.button(text: "CLICK!")
                    .onTapGesture(by: self.disposeBag) {[unowned self] in
                        self.endEditing(false)
                        self.viewModel.unwrappedValue.userText = self.currentText.value
                    }
            }
        }
    }
    
    private var clickerSampleView: UIView {
        UIVStackView(spacing: 12.0) {
            UIHStackView(alignment: .center, spacing: 8.0) {
                UILabel("CLICKER")
                    .font(.systemFont(ofSize: 16.0, weight: .bold))
                UIHStackView(alignment: .center, spacing: 8.0) {
                    self.button(text: "-")
                        .onTapGesture(by: self.disposeBag) {[unowned self] in
                            self.viewModel.decreaseCount()
                        }
                    UILabel(self.viewModel
                                .map { String(format: "%lld", $0.clickedCount) }
                                .distinctUntilChanged(),
                            by: self.disposeBag)
                        .font(.systemFont(ofSize: 14.0, weight: .thin))
                        .alignment(.center)
                        .color(self.viewModel
                                   .map { $0.clickedCount < 0 ? .red : .green }
                                   .distinctUntilChanged(),
                               by: self.disposeBag)
                    self.button(text: "+")
                        .onTapGesture(by: self.disposeBag) {[unowned self] in
                            self.viewModel.increaseCount()
                        }
                }
                .priority(.required)
            }
        }
    }
    
    private var navigateToSecondViewButton: UIView {
        self.button(text: "Move to SecondView!")
            .onTapGesture(by: self.disposeBag, publish: self.didTappedNavigateToSecondView)
    }
    
    private func button(text: String) -> UIView {
        UILabel(text)
            .font(.systemFont(ofSize: 16.0, weight: .semibold))
            .color(.white)
            .alignment(.center)
            .priority(.required)
            .padding(.horizontal, 20.0)
            .padding(.vertical, 8.0)
            .background(.lightGray)
            .corner(radius: 6.0)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        MainView.view
            .previewDevice("iPhone 12 mini")
    }
}
#endif

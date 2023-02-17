//
//  RxKeyboardResponder.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/17.
//

import UIKit

import RxSwift
import RxRelay

class RxKeyboardResponder {
    typealias `Self` = RxKeyboardResponder
    
    static let shared: Self = .init()
    
    private let disposeBag = DisposeBag()
    let willShow = PublishRelay<CGRect>()
    let didShow  = PublishRelay<CGRect>()
    let willHide = PublishRelay<Void>()
    let didHide  = PublishRelay<Void>()
    
    init() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: {[unowned self] notification in
                guard let userInfo     = notification.userInfo,
                      let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
                else { return }
                self.willShow.accept(keyboardInfo.cgRectValue)
            })
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardDidShowNotification)
            .subscribe(onNext: {[unowned self] notification in
                guard let userInfo     = notification.userInfo,
                      let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
                else { return }
                self.didShow.accept(keyboardInfo.cgRectValue)
            })
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: {[unowned self] _ in
                self.willHide.accept()
            })
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardDidHideNotification)
            .subscribe(onNext: {[unowned self] _ in
                self.didHide.accept()
            })
            .disposed(by: self.disposeBag)
    }
}

//
//  SUVK+Rx+UITextField.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa

extension UITextField {

}

#if canImport(RxRelay)
import RxRelay

extension UITextField {
    @discardableResult
    public func bind(to observer: BehaviorRelay<String>, by disposeBag: DisposeBag) -> Self {
        self.rx.text
            .orEmpty
            .distinctUntilChanged()
            .skip(1)
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        observer
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] in
                self?.text = $0
            })
            .disposed(by: disposeBag)
        
        return self
    }
}
#endif
#endif

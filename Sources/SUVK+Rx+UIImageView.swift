//
//  SUVK+Rx+UIImageView.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa

extension UIImageView {
    public convenience init(named observer: Observable<String>, by disposeBag: DisposeBag) {
        self.init(image: nil)
        observer
            .subscribe(onNext: {[weak self] in
                var image = UIImage(named: $0)
                if let renderingMode = self?.image?.renderingMode {
                    image = image?.withRenderingMode(renderingMode)
                }
                self?.image = image
            })
            .disposed(by: disposeBag)
    }
    
    public convenience init(image observer: Observable<UIImage?>, by disposeBag: DisposeBag) {
        self.init(image: nil)
        observer
            .subscribe(onNext: {[weak self] in
                var image = $0
                if let renderingMode = self?.image?.renderingMode {
                    image = image?.withRenderingMode(renderingMode)
                }
                self?.image = image
            })
            .disposed(by: disposeBag)
    }
}

#if canImport(RxRelay)
import RxRelay

extension UIImageView {
    public convenience init(named observer: BehaviorRelay<String>, by disposeBag: DisposeBag) {
        self.init(named: observer.asObservable(), by: disposeBag)
    }
    
    public convenience init(image observer: BehaviorRelay<UIImage?>, by disposeBag: DisposeBag) {
        self.init(image: observer.asObservable(), by: disposeBag)
    }
}
#endif
#endif

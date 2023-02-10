//
//  SUVK+Rx+UIScrollView.swift
//  ParkingShare
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa

extension UIScrollView {
    public func scroll(to observable: Observable<CGPoint>, by disposeBag: DisposeBag) -> Self {
        observable
            .bind(to: self.rx.contentOffset)
            .disposed(by: disposeBag)
        return self
    }
    
    @discardableResult
    public func contentOffset<T: UIScrollView>(onNext block: @escaping ((T, CGPoint)->Void), by disposeBag: DisposeBag) -> Self {
        if let view = self as? T {
            self.rx.contentOffset
                .skip(1)
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: {offset in
                    block(view, offset)
                })
                .disposed(by: disposeBag)
        }
        return self
    }
    
    @discardableResult
    public func didEndScroll<T: UIScrollView>(onNext block: @escaping ((T)->Void), by disposeBag: DisposeBag) -> Self {
        if let view = self as? T {
            self.rx.didEndScroll
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: {
                    block(view)
                })
                .disposed(by: disposeBag)
        }
        return self
    }
    
    @discardableResult
    public func didScrollLast<T: UIScrollView>(onNext block: @escaping ((T)->Void), by disposeBag: DisposeBag) -> Self {
        if let view = self as? T {
            self.rx.didScrollLast
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: {
                    block(view)
                })
                .disposed(by: disposeBag)
        }
        return self
    }
}

#if canImport(RxRelay)
import RxRelay

extension UIScrollView {
    public func scroll(bind behaviorRelay: BehaviorRelay<CGPoint>, by disposeBag: DisposeBag) -> Self {
        behaviorRelay
            .bind(to: self.rx.contentOffset)
            .disposed(by: disposeBag)
        self.rx.contentOffset
            .filter { $0.x != behaviorRelay.value.x || $0.y != behaviorRelay.value.y }
            .bind(to: behaviorRelay)
            .disposed(by: disposeBag)
        return self
    }
    
    public func scroll(to publishRelay: PublishRelay<CGPoint>, by disposeBag: DisposeBag) -> Self {
        publishRelay
            .bind(to: self.rx.contentOffset)
            .disposed(by: disposeBag)
        return self
    }
}
#endif
#endif

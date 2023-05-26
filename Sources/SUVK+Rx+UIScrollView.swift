//
//  SUVK+Rx+UIScrollView.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa

extension UIScrollView {
    @discardableResult
    public func scroll(to observer: Observable<CGPoint>) -> Self {
        self.scroll(to: observer, by: self.disposeBag)
    }
    
    @discardableResult
    public func contentOffset<T: UIScrollView>(onNext block: @escaping ((T, CGPoint)->Void),
                                               on scheduler: ImmediateSchedulerType = MainScheduler.instance)
    -> Self {
        self.contentOffset(onNext: block, on: scheduler, by: self.disposeBag)
    }
    
    @discardableResult
    public func didEndScroll<T: UIScrollView>(onNext block: @escaping ((T)->Void),
                                              on scheduler: ImmediateSchedulerType = MainScheduler.instance)
    -> Self {
        self.didEndScroll(onNext: block, on: scheduler, by: self.disposeBag)
    }
    
    @discardableResult
    public func didScrollLast<T: UIScrollView>(onNext block: @escaping ((T)->Void),
                                               on scheduler: ImmediateSchedulerType = MainScheduler.instance)
    -> Self {
        self.didScrollLast(onNext: block, on: scheduler, by: self.disposeBag)
    }
    
    @discardableResult
    public func scroll(to observer: Observable<CGPoint>, by disposeBag: DisposeBag) -> Self {
        observer
            .bind(to: self.rx.contentOffset)
            .disposed(by: disposeBag)
        return self
    }
    
    @discardableResult
    public func contentOffset<T: UIScrollView>(onNext block: @escaping ((T, CGPoint)->Void),
                                               on scheduler: ImmediateSchedulerType = MainScheduler.instance,
                                               by disposeBag: DisposeBag)
    -> Self {
        if let view = self as? T {
            self.rx.contentOffset
                .skip(1)
                .observe(on: scheduler)
                .subscribe(onNext: {offset in
                    block(view, offset)
                })
                .disposed(by: disposeBag)
        }
        return self
    }
    
    @discardableResult
    public func didEndScroll<T: UIScrollView>(onNext block: @escaping ((T)->Void),
                                              on scheduler: ImmediateSchedulerType = MainScheduler.instance,
                                              by disposeBag: DisposeBag)
    -> Self {
        if let view = self as? T {
            self.rx.didEndScroll
                .observe(on: scheduler)
                .subscribe(onNext: {
                    block(view)
                })
                .disposed(by: disposeBag)
        }
        return self
    }
    
    @discardableResult
    public func didScrollLast<T: UIScrollView>(onNext block: @escaping ((T)->Void),
                                               on scheduler: ImmediateSchedulerType = MainScheduler.instance,
                                               by disposeBag: DisposeBag)
    -> Self {
        if let view = self as? T {
            self.rx.didScrollLast
                .observe(on: scheduler)
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
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func scroll(bind behaviorRelay: BehaviorRelay<CGPoint>, by disposeBag: DisposeBag) -> Self {
        self.scroll(bind: behaviorRelay)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func scroll(to publishRelay: PublishRelay<CGPoint>, by disposeBag: DisposeBag) -> Self {
        self.scroll(to: publishRelay)
    }
    
    @discardableResult
    public func scroll(bind behaviorRelay: BehaviorRelay<CGPoint>) -> Self {
        behaviorRelay
            .bind(to: self.rx.contentOffset)
            .disposed(by: self.disposeBag)
        self.rx.contentOffset
            .filter { $0.x != behaviorRelay.value.x || $0.y != behaviorRelay.value.y }
            .bind(to: behaviorRelay)
            .disposed(by: self.disposeBag)
        return self
    }
    
    @discardableResult
        public func scroll(to publishRelay: PublishRelay<CGPoint>) -> Self {
        publishRelay
            .bind(to: self.rx.contentOffset)
            .disposed(by: self.disposeBag)
        return self
    }
}
#endif
#endif

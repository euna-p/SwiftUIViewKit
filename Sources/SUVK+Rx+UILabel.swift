//
//  SUVK+Rx+UILabel.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa

extension UILabel {
    public convenience init(_ observer: Observable<NSAttributedString?>, by disposeBag: DisposeBag) {
        self.init(frame: .zero)
        observer
            .distinctUntilChanged()
            .subscribe(onNext: {value in
                self.attributedText = value
                if let lineHeight = self.lineHeight {
                    _ = self.lineHeight(lineHeight)
                }
            })
            .disposed(by: disposeBag)
    }
    public convenience init(_ observer: Observable<NSAttributedString>, by disposeBag: DisposeBag) {
        let optionalObserver: Observable<Optional<NSAttributedString>> = observer.map { $0 }
        self.init(optionalObserver, by: disposeBag)
    }
    
    public convenience init(_ observer: Observable<String?>, by disposeBag: DisposeBag) {
        self.init(frame: .zero)
        observer
            .distinctUntilChanged()
            .subscribe(onNext: {value in
                self.text = value
                if let lineHeight = self.lineHeight {
                    _ = self.lineHeight(lineHeight)
                }
            })
            .disposed(by: disposeBag)
    }
    public convenience init(_ observer: Observable<String>, by disposeBag: DisposeBag) {
        let optionalObserver: Observable<Optional<String>> = observer.map { $0 }
        self.init(optionalObserver, by: disposeBag)
    }
}

extension UILabel {
    @discardableResult
    public func underLine(by disposeBag: DisposeBag) -> Self {
        self.rx.observe(String.self, "text")
            .map {_ in }
            .subscribe(onNext: {[weak self] in
                self?.underLine()
            })
            .disposed(by: disposeBag)
        return self
    }
    
    @discardableResult
    public func underLine(_ flag: Observable<Bool>, by disposeBag: DisposeBag) -> Self {
        flag.distinctUntilChanged()
            .subscribe(onNext: {[weak self] in
                self?.underLine($0)
            })
            .disposed(by: disposeBag)
        return self
    }
    
    @discardableResult
    public func lineLimit(_ numberOfLines: Observable<Int?>, by disposeBag: DisposeBag) -> Self {
        numberOfLines
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] in
                self?.lineLimit($0)
            })
            .disposed(by: disposeBag)
        return self
    }
    @discardableResult
    public func lineLimit(_ numberOfLines: Observable<Int>, by disposeBag: DisposeBag) -> Self {
        self.lineLimit(numberOfLines.asOptional, by: disposeBag)
    }
}

#if canImport(RxRelay)
import RxRelay

extension UILabel {
    public convenience init(_ observer: BehaviorRelay<NSAttributedString?>, by disposeBag: DisposeBag) {
        self.init(observer.asObservable(), by: disposeBag)
    }
    public convenience init(_ observer: BehaviorRelay<NSAttributedString>, by disposeBag: DisposeBag) {
        self.init(observer.asObservable(), by: disposeBag)
    }
    
    public convenience init(_ observer: BehaviorRelay<String?>, by disposeBag: DisposeBag) {
        self.init(observer.asObservable(), by: disposeBag)
    }
    public convenience init(_ observer: BehaviorRelay<String>, by disposeBag: DisposeBag) {
        self.init(observer.asObservable(), by: disposeBag)
    }
}

extension UILabel {
    @discardableResult
    public func underLine(_ flag: BehaviorRelay<Bool>, by disposeBag: DisposeBag) -> Self {
        self.underLine(flag.asObservable(), by: disposeBag)
    }
    
    @discardableResult
    public func lineLimit(_ numberOfLines: BehaviorRelay<Int?>, by disposeBag: DisposeBag) -> Self {
        self.lineLimit(numberOfLines.asObservable(), by: disposeBag)
    }
    @discardableResult
    public func lineLimit(_ numberOfLines: BehaviorRelay<Int>, by disposeBag: DisposeBag) -> Self {
        self.lineLimit(numberOfLines.asObservable(), by: disposeBag)
    }
}
#endif
#endif

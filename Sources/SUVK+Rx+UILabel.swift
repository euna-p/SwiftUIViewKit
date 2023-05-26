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
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    public convenience init(_ observer: Observable<NSAttributedString?>, by disposeBag: DisposeBag) {
        self.init(observer)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    public convenience init(_ observer: Observable<NSAttributedString>, by disposeBag: DisposeBag) {
        self.init(observer)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    public convenience init(_ observer: Observable<String?>, by disposeBag: DisposeBag) {
        self.init(observer)
    }
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    public convenience init(_ observer: Observable<String>, by disposeBag: DisposeBag) {
        self.init(observer)
    }
    
    public convenience init(_ observer: Observable<NSAttributedString?>) {
        self.init(frame: .zero)
        observer
            .distinctUntilChanged()
            .subscribe(onNext: {value in
                if let font = self.font, let textColor = self.textColor, let lineHeight = self.lineHeight {
                    self.attributedText = {
                        UILabel(attributed: value)
                            .alignment(self.textAlignment)
                            .font(font)
                            .color(textColor)
                            .lineHeight(lineHeight)
                            .attributedText
                    }()
                } else {
                    self.attributedText = value
                    if let lineHeight = self.lineHeight {
                        self.lineHeight(lineHeight)
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    public convenience init(_ observer: Observable<NSAttributedString>) {
        let optionalObserver: Observable<Optional<NSAttributedString>> = observer.map { $0 }
        self.init(optionalObserver)
    }
    
    public convenience init(_ observer: Observable<String?>) {
        self.init(frame: .zero)
        observer
            .distinctUntilChanged()
            .subscribe(onNext: {value in
                if let font = self.font, let textColor = self.textColor, let lineHeight = self.lineHeight {
                    self.attributedText = {
                        UILabel(value)
                            .alignment(self.textAlignment)
                            .font(font)
                            .color(textColor)
                            .lineHeight(lineHeight)
                            .attributedText
                    }()
                } else {
                    self.text = value
                    if let lineHeight = self.lineHeight {
                        self.lineHeight(lineHeight)
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    public convenience init(_ observer: Observable<String>) {
        let optionalObserver: Observable<Optional<String>> = observer.map { $0 }
        self.init(optionalObserver)
    }
}

extension UILabel {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func underLine(_ flag: Observable<Bool>, by disposeBag: DisposeBag) -> Self {
        self.underLine(flag)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func lineLimit(_ numberOfLines: Observable<Int?>, by disposeBag: DisposeBag) -> Self {
        self.lineLimit(numberOfLines)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func lineLimit(_ numberOfLines: Observable<Int>, by disposeBag: DisposeBag) -> Self {
        self.lineLimit(numberOfLines)
    }
    
    @discardableResult
    public func underLine(_ flag: Observable<Bool>) -> Self {
        Observable.combineLatest(
            flag,
            self.rx.observe(String.self, "text")
        )
        .map {(flag, _) in return flag  }
        .distinctUntilChanged()
        .subscribe(onNext: {[weak self] in
            self?.underLine($0)
        })
        .disposed(by: self.disposeBag)
        return self
    }
    
    @discardableResult
    public func lineLimit(_ numberOfLines: Observable<Int?>) -> Self {
        numberOfLines
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] in
                self?.lineLimit($0)
            })
            .disposed(by: self.disposeBag)
        return self
    }
    
    @discardableResult
    public func lineLimit(_ numberOfLines: Observable<Int>) -> Self {
        self.lineLimit(numberOfLines.asOptional)
    }
}

#if canImport(RxRelay)
import RxRelay

extension UILabel {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    public convenience init(_ observer: BehaviorRelay<NSAttributedString?>, by disposeBag: DisposeBag) {
        self.init(observer)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    public convenience init(_ observer: BehaviorRelay<NSAttributedString>, by disposeBag: DisposeBag) {
        self.init(observer)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    public convenience init(_ observer: BehaviorRelay<String?>, by disposeBag: DisposeBag) {
        self.init(observer)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    public convenience init(_ observer: BehaviorRelay<String>, by disposeBag: DisposeBag) {
        self.init(observer)
    }
    
    public convenience init(_ observer: BehaviorRelay<NSAttributedString?>) {
        self.init(observer.asObservable())
    }
    
    public convenience init(_ observer: BehaviorRelay<NSAttributedString>) {
        self.init(observer.asObservable())
    }
    
    public convenience init(_ observer: BehaviorRelay<String?>) {
        self.init(observer.asObservable())
    }
    
    public convenience init(_ observer: BehaviorRelay<String>) {
        self.init(observer.asObservable())
    }
}

extension UILabel {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func underLine(_ flag: BehaviorRelay<Bool>, by disposeBag: DisposeBag) -> Self {
        self.underLine(flag.asObservable(), by: disposeBag)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func lineLimit(_ numberOfLines: BehaviorRelay<Int?>, by disposeBag: DisposeBag) -> Self {
        self.lineLimit(numberOfLines.asObservable(), by: disposeBag)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func lineLimit(_ numberOfLines: BehaviorRelay<Int>, by disposeBag: DisposeBag) -> Self {
        self.lineLimit(numberOfLines.asObservable(), by: disposeBag)
    }
    
    @discardableResult
    public func underLine(_ flag: BehaviorRelay<Bool>) -> Self {
        self.underLine(flag.asObservable())
    }
    
    @discardableResult
    public func lineLimit(_ numberOfLines: BehaviorRelay<Int?>) -> Self {
        self.lineLimit(numberOfLines.asObservable())
    }
    
    @discardableResult
    public func lineLimit(_ numberOfLines: BehaviorRelay<Int>) -> Self {
        self.lineLimit(numberOfLines.asObservable())
    }
}
#endif
#endif

//
//  SUVK+Rx+UIView.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa

extension UIView {
    @discardableResult
    public func subscribe<V: UIView, T>(_ observer: Observable<T>,
                                 at when: SwiftUIView.SubscribeAt = .always,
                                 by disposeBag: DisposeBag,
                                 onNext: @escaping (V, T)->Void,
                                 file: String = #file, function: String = #function, lineNumber: Int = #line)
    -> Self {
        if let v = self as? V {
            var observer = observer
            switch when {
            case .always:
                break
            case .skip(let count):
                observer = observer.skip(count)
            case .untilChanged:
                observer = observer.distinctUntilChanged {
                    if let lhs = $0 as? (any Equatable), let rhs = $1 as? (any Equatable) {
                        return lhs.isEqual(rhs)
                    } else  {
                        if let style = Mirror(reflecting: $0).displayStyle {
                            switch style {
                            case .struct, .enum, .tuple, .optional, .collection, .dictionary:
                                return "\($0)" == "\($1)"
                            case .class, .set:
                                break
                            @unknown default:
                                break
                            }
                        }
                        let fileName = file.components(separatedBy: "/").last ?? file
                        let log = String(format: "[SwiftUIKit] ⚠️ WARNING (%@:%lld %@): %@",
                                         fileName, lineNumber, function,
                                         "An element is not `Equatable` on 'subscribe(_: at: by: onNext:)' by 'SwiftUIViewKit.SubscribeAt.untilChanged'.")
                        print(log)
                        return false
                    }
                }
            }
            
            observer
                .subscribe(onNext: { onNext(v, $0) })
                .disposed(by: disposeBag)
        }
        return self
    }
}

extension UIView {
    public func color(_ color: Observable<UIColor>, by disposeBag: DisposeBag) -> Self {
        color
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] in
                _ = self?.color($0)
            })
            .disposed(by: disposeBag)
        return self
    }
    
    public func hidden(_ flag: Observable<Bool>, by disposeBag: DisposeBag) -> Self {
        flag
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] in
                _ = self?.hidden($0)
            })
            .disposed(by: disposeBag)
        return self
    }
}

extension UIView {
    public func onLayoutSubviews(onNext block: @escaping ()->Void, by disposeBag: DisposeBag) -> Self {
        self.onLayoutSubviews(onNext: {_ in block() }, by: disposeBag)
    }
    public func onLayoutSubviews(onNext block: @escaping ([Any])->Void, by disposeBag: DisposeBag) -> Self {
        self.rx.layoutSubviews
            .subscribe(onNext: block)
            .disposed(by: disposeBag)
        return self
    }
}

#if canImport(RxRelay)
import RxRelay

extension UIView {
    @discardableResult
    public func subscribe<V: UIView, T>(_ observer: BehaviorRelay<T>,
                                 at when: SwiftUIView.SubscribeAt = .always,
                                 by disposeBag: DisposeBag,
                                 onNext: @escaping (V, T)->Void)
    -> Self {
        self.subscribe(observer.asObservable(), at: when, by: disposeBag, onNext: onNext)
        return self
    }
    
    public func color(_ color: BehaviorRelay<UIColor>, by disposeBag: DisposeBag) -> Self {
        self.color(color.asObservable(), by: disposeBag)
    }
    
    public func hidden(_ flag: BehaviorRelay<Bool>, by disposeBag: DisposeBag) -> Self {
        self.hidden(flag.asObservable(), by: disposeBag)
    }
}

extension UIView {
    @discardableResult
    public func onTapGesture(count: Int = 1, finger: Int = 1, by disposeBag: DisposeBag, publish relay: PublishRelay<UITapGestureRecognizer>) -> Self {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired    = count
        gesture.numberOfTouchesRequired = finger
        gesture.rx.event
            .bind(to: relay)
            .disposed(by: disposeBag)
        self.addGestureRecognizer(gesture)
        self.isUserInteractionEnabled = true
        return self
    }
    @discardableResult
    public func onTapGesture(count: Int = 1, finger: Int = 1, by disposeBag: DisposeBag, publish relay: PublishRelay<Void>) -> Self {
        let observer = PublishRelay<UITapGestureRecognizer>()
        observer.map({_ in }).bind(to: relay).disposed(by: disposeBag)
        return self.onTapGesture(count: count, finger: finger, by: disposeBag, publish: observer)
    }
    @discardableResult
    public func onTapGesture(count: Int = 1, finger: Int = 1, by disposeBag: DisposeBag, perform action: @escaping (UITapGestureRecognizer)->Void) -> Self {
        let observer = PublishRelay<UITapGestureRecognizer>()
        observer
            .subscribe(onNext: action)
            .disposed(by: disposeBag)
        return self.onTapGesture(count: count, finger: finger, by: disposeBag, publish: observer)
    }
    @discardableResult
    public func onTapGesture(count: Int = 1, finger: Int = 1, by disposeBag: DisposeBag, perform action: @escaping ()->Void) -> Self {
        let observer = PublishRelay<Void>()
        observer
            .subscribe(onNext: action)
            .disposed(by: disposeBag)
        return self.onTapGesture(count: count, finger: finger, by: disposeBag, publish: observer)
    }
}
#endif

extension UIView {
    @discardableResult
    public func onResize<T: UIView>(_ perform: @escaping (T, CGSize)->Void, by disposeBag: DisposeBag) -> Self {
        if let t = self as? T {
            t.rx.observe(CGRect.self, #keyPath(UIView.bounds))
                .subscribe(onNext: {
                    guard let v = $0?.size else { return }
                    perform(t, v)
                })
                .disposed(by: disposeBag)
        }
        return self
    }
}

#endif

extension Equatable {
    fileprivate func isEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}

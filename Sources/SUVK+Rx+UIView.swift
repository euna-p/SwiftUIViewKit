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

extension UIViewKitClass {
    public enum SubscribeAt {
        case always, skip(Int), untilChanged
    }
}

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
                    } else {
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
                                         "An element is not `Equatable` on 'subscribe(_: at: by: onNext:)' "
                                         + "by 'SwiftUIViewKit.SubscribeAt.untilChanged'.")
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

extension UIView {
    @discardableResult
    public func onResize<T: UIView>(_ perform: @escaping (T, CGSize)->Void, by disposeBag: DisposeBag) -> Self {
        if let t = self as? T {
            self.rx.observe(CGRect.self, #keyPath(UIView.bounds))
                .map { (t, $0?.size ?? .zero) }
                .bind(onNext: perform)
                .disposed(by: disposeBag)
        }
        return self
    }
}

extension UIControl {
    @discardableResult
    public func addTarget(by disposeBag: DisposeBag,
                          for controlEvents: UIControl.Event,
                          action: @escaping (()->Void))
    -> Self {
        self.rx.controlEvent(controlEvents)
            .subscribe(onNext: action)
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
    public func onTapGesture(count: Int = 1,
                             finger: Int = 1,
                             by disposeBag: DisposeBag,
                             publish relay: PublishRelay<UITapGestureRecognizer>)
    -> Self {
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
    public func onTapGesture(count: Int = 1,
                             finger: Int = 1,
                             by disposeBag: DisposeBag,
                             publish relay: PublishRelay<Void>)
    -> Self {
        let observer = PublishRelay<UITapGestureRecognizer>()
        observer.map({_ in }).bind(to: relay).disposed(by: disposeBag)
        return self.onTapGesture(count: count, finger: finger, by: disposeBag, publish: observer)
    }
    @discardableResult
    public func onTapGesture(count: Int = 1,
                             finger: Int = 1,
                             by disposeBag: DisposeBag,
                             perform action: @escaping (UITapGestureRecognizer)->Void)
    -> Self {
        let observer = PublishRelay<UITapGestureRecognizer>()
        observer
            .subscribe(onNext: action)
            .disposed(by: disposeBag)
        return self.onTapGesture(count: count, finger: finger, by: disposeBag, publish: observer)
    }
    @discardableResult
    public func onTapGesture(count: Int = 1,
                             finger: Int = 1,
                             by disposeBag: DisposeBag,
                             perform action: @escaping ()->Void)
    -> Self {
        let observer = PublishRelay<Void>()
        observer
            .subscribe(onNext: action)
            .disposed(by: disposeBag)
        return self.onTapGesture(count: count, finger: finger, by: disposeBag, publish: observer)
    }
}

extension UIView {
    @discardableResult
    public func mask(toBound flag: Observable<Bool>, by disposeBag: DisposeBag) -> Self {
        flag.subscribe(onNext: { self.layer.masksToBounds = $0 })
            .disposed(by: disposeBag)
        return self
    }
    
    @discardableResult
    public func corner(radius: Observable<CGFloat>, by disposeBag: DisposeBag) -> Self {
        radius.subscribe(onNext: { self.layer.cornerRadius = $0 })
            .disposed(by: disposeBag)
        return self
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func corner(curve: Observable<CALayerCornerCurve>, by disposeBag: DisposeBag) -> Self {
        curve.subscribe(onNext: { self.layer.cornerCurve = $0 })
            .disposed(by: disposeBag)
        return self
    }
    
    @discardableResult
    public func border(color: Observable<UIColor>, by disposeBag: DisposeBag) -> Self {
        color.subscribe(onNext: { self.layer.borderColor = $0.cgColor })
            .disposed(by: disposeBag)
        return self
    }
    
    @discardableResult
    public func border(width: Observable<CGFloat>, by disposeBag: DisposeBag) -> Self {
        width.subscribe(onNext: { self.layer.borderWidth = $0 })
            .disposed(by: disposeBag)
        return self
    }
    
    @discardableResult
    public func mask(toBound flag: BehaviorRelay<Bool>, by disposeBag: DisposeBag) -> Self {
        self.mask(toBound: flag.asObservable(), by: disposeBag)
    }
    @discardableResult
    public func corner(radius: BehaviorRelay<CGFloat>, by disposeBag: DisposeBag) -> Self {
        self.corner(radius: radius.asObservable(), by: disposeBag)
    }
    @available(iOS 13.0, *)
    @discardableResult
    public func corner(curve: BehaviorRelay<CALayerCornerCurve>, by disposeBag: DisposeBag) -> Self {
        self.corner(curve: curve.asObservable(), by: disposeBag)
    }
    @discardableResult
    public func border(color: BehaviorRelay<UIColor>, by disposeBag: DisposeBag) -> Self {
        self.border(color: color.asObservable(), by: disposeBag)
    }
    @discardableResult
    public func border(width: BehaviorRelay<CGFloat>, by disposeBag: DisposeBag) -> Self {
        self.border(width: width.asObservable(), by: disposeBag)
    }
}

extension UIView {
    @discardableResult
    public func onResize(to relay: PublishRelay<CGSize>, by disposeBag: DisposeBag) -> Self {
        self.onResize({ relay.accept($1) }, by: disposeBag)
    }
    @discardableResult
    public func onResize(to relay: BehaviorRelay<CGSize>, by disposeBag: DisposeBag) -> Self {
        self.onResize({ relay.accept($1) }, by: disposeBag)
    }
}

extension UIControl {
    @discardableResult
    public func addTarget(to relay: PublishRelay<Void>,
                          by disposeBag: DisposeBag,
                          for controlEvents: UIControl.Event)
    -> Self {
        self.addTarget(by: disposeBag, for: controlEvents, action: { relay.accept(()) })
    }
}
#endif
#endif

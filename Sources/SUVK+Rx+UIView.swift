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
    private struct DisposeBagStore {
        static var key = "disposeBag"
    }
    
    internal var disposeBag: DisposeBag {
        get {
            if let disposeBag = objc_getAssociatedObject(self, &DisposeBagStore.key) as? DisposeBag {
                return disposeBag
            } else {
                let disposeBag = DisposeBag()
                self.disposeBag = disposeBag
                return disposeBag
            }
        }
        set {
            objc_setAssociatedObject(self, &DisposeBagStore.key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension UIView {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func subscribe<V: UIView, T>(_ observer: Observable<T>,
                                        at when: SwiftUIView.SubscribeAt = .always,
                                        by disposeBag: DisposeBag,
                                        onNext: @escaping (V, T)->Void,
                                        file: String = #file, function: String = #function, lineNumber: Int = #line)
    -> Self {
        self.subscribe(observer, at: when, onNext: onNext,
                       file: file, function: function, lineNumber: lineNumber)
    }
    
    @discardableResult
    public func subscribe<V: UIView, T>(_ observer: Observable<T>,
                                        at when: SwiftUIView.SubscribeAt = .always,
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
                .disposed(by: self.disposeBag)
        }
        return self
    }
}

extension UIView {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func color(_ color: Observable<UIColor>, by disposeBag: DisposeBag) -> Self {
        self.color(color)
    }
    
    @discardableResult
    public func color(_ color: Observable<UIColor>) -> Self {
        color
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] in
                _ = self?.color($0)
            })
            .disposed(by: self.disposeBag)
        return self
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func hidden(_ flag: Observable<Bool>, by disposeBag: DisposeBag) -> Self {
        self.hidden(flag)
    }
    
    @discardableResult
    public func hidden(_ flag: Observable<Bool>) -> Self {
        flag
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] in
                _ = self?.hidden($0)
            })
            .disposed(by: self.disposeBag)
        return self
    }
}

extension UIView {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func onLayoutSubviews(onNext block: @escaping ()->Void, by disposeBag: DisposeBag) -> Self {
        self.onLayoutSubviews(onNext: block)
    }

    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func onLayoutSubviews(onNext block: @escaping ([Any])->Void, by disposeBag: DisposeBag) -> Self {
        self.onLayoutSubviews(onNext: block)
    }
    
    @discardableResult
    public func onLayoutSubviews(onNext block: @escaping ()->Void) -> Self {
        self.onLayoutSubviews(onNext: {_ in block() })
    }
    
    @discardableResult
    public func onLayoutSubviews(onNext block: @escaping ([Any])->Void) -> Self {
        self.rx.layoutSubviews
            .subscribe(onNext: block)
            .disposed(by: self.disposeBag)
        return self
    }
}

extension UIView {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func onResize<T: UIView>(_ perform: @escaping (T, CGSize)->Void, by disposeBag: DisposeBag) -> Self {
        self.onResize(perform)
    }
    
    @discardableResult
    public func onResize<T: UIView>(_ perform: @escaping (T, CGSize)->Void) -> Self {
        if let t = self as? T {
            self.rx.observe(CGRect.self, #keyPath(UIView.bounds))
                .map { (t, $0?.size ?? .zero) }
                .bind(onNext: perform)
                .disposed(by: self.disposeBag)
        }
        return self
    }
}

extension UIView {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func corner(radius: Observable<CGFloat>, by disposeBag: DisposeBag) -> Self {
        self.corner(radius: radius)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func border(color: Observable<UIColor>, by disposeBag: DisposeBag) -> Self {
        self.border(color: color)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func border(width: Observable<CGFloat>, by disposeBag: DisposeBag) -> Self {
        self.border(width: width)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func mask(toBound flag: Observable<Bool>, by disposeBag: DisposeBag) -> Self {
        self.mask(toBound: flag)
    }
    
    @discardableResult
    public func corner(radius: Observable<CGFloat>) -> Self {
        radius.subscribe(onNext: { self.layer.cornerRadius = $0 })
            .disposed(by: self.disposeBag)
        return self
    }
    
    @discardableResult
    public func border(color: Observable<UIColor>) -> Self {
        color.subscribe(onNext: { self.layer.borderColor = $0.cgColor })
            .disposed(by: self.disposeBag)
        return self
    }
    
    @discardableResult
    public func border(width: Observable<CGFloat>) -> Self {
        width.subscribe(onNext: { self.layer.borderWidth = $0 })
            .disposed(by: self.disposeBag)
        return self
    }
    
    @discardableResult
    public func mask(toBound flag: Observable<Bool>) -> Self {
        flag.subscribe(onNext: { self.layer.masksToBounds = $0 })
            .disposed(by: self.disposeBag)
        return self
    }
}

extension UIView {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func corner(radius: CGFloat, to corners: UIRectCorner, by disposeBag: DisposeBag) -> Self {
        self.corner(radius: radius, to: corners)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func corner(radius: CGSize, to corners: UIRectCorner, by disposeBag: DisposeBag) -> Self {
        self.corner(radius: radius, to: corners)
    }
    
    @discardableResult
    public func corner(radius: CGFloat, to corners: UIRectCorner) -> Self {
        return self.corner(radius: CGSize(width: radius, height: radius), to: corners)
    }
    
    @discardableResult
    public func corner(radius: CGSize, to corners: UIRectCorner) -> Self {
        self.rx.observe(CGRect.self, #keyPath(UIView.bounds))
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] bounds in
                guard let bounds = bounds else { return }
                let path = UIBezierPath(roundedRect:       bounds,
                                        byRoundingCorners: corners,
                                        cornerRadii:       radius)
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                self?.layer.mask          = maskLayer
                self?.layer.masksToBounds = true
                self?.layer.borderColor   = UIColor.clear.cgColor
                self?.layer.borderWidth   = 0.0
            })
            .disposed(by: self.disposeBag)
        return self
    }
}

extension UIControl {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func addTarget(by disposeBag: DisposeBag,
                          for controlEvents: UIControl.Event,
                          action: @escaping (()->Void))
    -> Self {
        self.addTarget(for: controlEvents, action: action)
    }
    
    @discardableResult
    public func addTarget(for controlEvents: UIControl.Event, action: @escaping (()->Void)) -> Self {
        self.rx.controlEvent(controlEvents)
            .subscribe(onNext: action)
            .disposed(by: self.disposeBag)
        return self
    }
}

#if canImport(RxRelay)
import RxRelay

extension UIView {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func subscribe<V: UIView, T>(_ observer: BehaviorRelay<T>,
                                        at when: SwiftUIView.SubscribeAt = .always,
                                        by disposeBag: DisposeBag,
                                        onNext: @escaping (V, T)->Void,
                                        file: String = #file, function: String = #function, lineNumber: Int = #line)
    -> Self {
        self.subscribe(observer, at: when, onNext: onNext,
                       file: file, function: function, lineNumber: lineNumber)
    }
    
    @discardableResult
    public func subscribe<V: UIView, T>(_ observer: BehaviorRelay<T>,
                                        at when: SwiftUIView.SubscribeAt = .always,
                                        onNext: @escaping (V, T)->Void,
                                        file: String = #file, function: String = #function, lineNumber: Int = #line)
    -> Self {
        self.subscribe(observer.asObservable(), at: when, onNext: onNext,
                       file: file, function: function, lineNumber: lineNumber)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func color(_ color: BehaviorRelay<UIColor>, by disposeBag: DisposeBag) -> Self {
        self.color(color.asObservable(), by: disposeBag)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func hidden(_ flag: BehaviorRelay<Bool>, by disposeBag: DisposeBag) -> Self {
        self.hidden(flag.asObservable(), by: disposeBag)
    }
    
    @discardableResult
    public func color(_ color: BehaviorRelay<UIColor>) -> Self {
        self.color(color.asObservable())
    }
    
    @discardableResult
    public func hidden(_ flag: BehaviorRelay<Bool>) -> Self {
        self.hidden(flag.asObservable())
    }
}

extension UIView {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func onTapGesture(count: Int = 1,
                             finger: Int = 1,
                             by disposeBag: DisposeBag,
                             publish relay: PublishRelay<UITapGestureRecognizer>)
    -> Self {
        self.onTapGesture(count: count, finger: finger, publish: relay)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func onTapGesture(count: Int = 1,
                             finger: Int = 1,
                             by disposeBag: DisposeBag,
                             publish relay: PublishRelay<Void>)
    -> Self {
        self.onTapGesture(count: count, finger: finger, publish: relay)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func onTapGesture(count: Int = 1,
                             finger: Int = 1,
                             by disposeBag: DisposeBag,
                             perform action: @escaping (UITapGestureRecognizer)->Void)
    -> Self {
        self.onTapGesture(count: count, finger: finger, perform: action)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func onTapGesture(count: Int = 1,
                             finger: Int = 1,
                             by disposeBag: DisposeBag,
                             perform action: @escaping ()->Void)
    -> Self {
        self.onTapGesture(count: count, finger: finger, perform: action)
    }
    
    @discardableResult
    public func onTapGesture(count: Int = 1,
                             finger: Int = 1,
                             publish relay: PublishRelay<UITapGestureRecognizer>)
    -> Self {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired    = count
        gesture.numberOfTouchesRequired = finger
        gesture.rx.event
            .bind(to: relay)
            .disposed(by: self.disposeBag)
        self.addGestureRecognizer(gesture)
        self.isUserInteractionEnabled = true
        return self
    }
    
    @discardableResult
    public func onTapGesture(count: Int = 1,
                             finger: Int = 1,
                             publish relay: PublishRelay<Void>)
    -> Self {
        let observer = PublishRelay<UITapGestureRecognizer>()
        observer
            .map {_ in }
            .bind(to: relay)
            .disposed(by: self.disposeBag)
        return self.onTapGesture(count: count, finger: finger, publish: observer)
    }
    
    @discardableResult
    public func onTapGesture(count: Int = 1,
                             finger: Int = 1,
                             perform action: @escaping (UITapGestureRecognizer)->Void)
    -> Self {
        let observer = PublishRelay<UITapGestureRecognizer>()
        observer
            .subscribe(onNext: action)
            .disposed(by: self.disposeBag)
        return self.onTapGesture(count: count, finger: finger, publish: observer)
    }
    
    @discardableResult
    public func onTapGesture(count: Int = 1,
                             finger: Int = 1,
                             perform action: @escaping ()->Void)
    -> Self {
        let observer = PublishRelay<Void>()
        observer
            .subscribe(onNext: action)
            .disposed(by: self.disposeBag)
        return self.onTapGesture(count: count, finger: finger, publish: observer)
    }
}

extension UIView {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func corner(radius: BehaviorRelay<CGFloat>, by disposeBag: DisposeBag) -> Self {
        self.corner(radius: radius)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func border(color: BehaviorRelay<UIColor>, by disposeBag: DisposeBag) -> Self {
        self.border(color: color)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func border(width: BehaviorRelay<CGFloat>, by disposeBag: DisposeBag) -> Self {
        self.border(width: width)
    }
    
    @discardableResult
    public func corner(radius: BehaviorRelay<CGFloat>) -> Self {
        self.corner(radius: radius.asObservable())
    }
    
    @discardableResult
    public func border(color: BehaviorRelay<UIColor>) -> Self {
        self.border(color: color.asObservable())
    }
    
    @discardableResult
    public func border(width: BehaviorRelay<CGFloat>) -> Self {
        self.border(width: width.asObservable())
    }
}

extension UIView {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func onResize(to relay: PublishRelay<CGSize>, by disposeBag: DisposeBag) -> Self {
        self.onResize(to: relay)
    }
    
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func onResize(to relay: BehaviorRelay<CGSize>, by disposeBag: DisposeBag) -> Self {
        self.onResize(to: relay)
    }
    
    @discardableResult
    public func onResize(to relay: PublishRelay<CGSize>) -> Self {
        self.onResize({ relay.accept($1) })
    }
    
    @discardableResult
    public func onResize(to relay: BehaviorRelay<CGSize>) -> Self {
        self.onResize({ relay.accept($1) })
    }
}

extension UIControl {
    @available(*, deprecated, message: "Remove `by: DisposeBag` in parameter.")
    @discardableResult
    public func addTarget(to relay: PublishRelay<Void>,
                          by disposeBag: DisposeBag,
                          for controlEvents: UIControl.Event)
    -> Self {
        self.addTarget(to: relay, for: controlEvents)
    }
    
    @discardableResult
    public func addTarget(to relay: PublishRelay<Void>, for controlEvents: UIControl.Event) -> Self {
        self.addTarget(for: controlEvents, action: { relay.accept(()) })
    }
}
#endif
#endif

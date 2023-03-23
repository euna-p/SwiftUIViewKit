//
//  SUVK+Builder.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/23.
//

#if swift(>=5.4)
import UIKit

import SnapKit

@resultBuilder
public struct ViewGroup {
    
}

extension ViewGroup {
    public static func buildBlock(_ components: UIView...) -> [UIView] {
        return components
    }
    
    public static func buildOptional(_ component: [UIView]?) -> UIView {
        return UIGroupView(views: component ?? [])
    }
    
    public static func buildEither(first component: [UIView]) -> UIView {
        return UIGroupView(views: component)
    }
    
    public static func buildEither(second component: [UIView]) -> UIView {
        return UIGroupView(views: component)
    }
    
    public static func buildArray(_ components: [[UIView]]) -> UIView {
        return UIGroupView(views: components.flatMap { $0 })
    }
}

extension UIGroupView {
    public convenience init(@ViewGroup content: (()->[UIView])) {
        let views = content()
        self.init(views: views)
    }
}

open class UIVStackView: UIStackView {
    private(set) var isPassthroughHit = false
    
    public override var axis: NSLayoutConstraint.Axis {
        get { return super.axis }
        set { }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.axis = .vertical
    }
    
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        super.axis = .vertical
    }
    
    public convenience init(alignment: UIStackView.Alignment = .fill,
                            spacing: CGFloat = 0.0,
                            @ViewGroup content: (()->[UIView])) {
        self.init(frame: .zero)
        self.spacing = spacing
        self.alignment = alignment
        content().forEach {
            self.addArrangedSubview($0)
        }
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        
        if view == self, self.isPassthroughHit, let color = self.color(of: point), color.cgColor.alpha <= 0.0 {
            return nil
        }
        
        return view
    }
    
    @discardableResult
    public func passthroughHit(_ flag: Bool = true) -> Self {
        self.isPassthroughHit = flag
        return self
    }
}

open class UIHStackView: UIStackView {
    private(set) var isPassthroughHit = false
    
    public override var axis: NSLayoutConstraint.Axis {
        get { return super.axis }
        set { }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.axis = .horizontal
    }
    
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        super.axis = .horizontal
    }
    
    public convenience init(alignment: UIStackView.Alignment = .fill,
                            spacing: CGFloat = 0.0,
                            @ViewGroup content: (()->[UIView])) {
        self.init(frame: .zero)
        self.spacing = spacing
        self.alignment = alignment
        content().forEach {
            self.addArrangedSubview($0)
        }
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        
        if view == self, self.isPassthroughHit, let color = self.color(of: point), color.cgColor.alpha <= 0.0 {
            return nil
        }
        
        return view
    }
    
    @discardableResult
    public func passthroughHit(_ flag: Bool = true) -> Self {
        self.isPassthroughHit = flag
        return self
    }
}

#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa

open class Subscriber {
    public typealias Block = ()->[UIView]
    
    private let disposeBag: DisposeBag
    
    public init(by disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
    }
}

extension Subscriber {
    public func `if`(_ observer: @autoclosure ()->BehaviorRelay<Bool>,
                     @ViewGroup then: @escaping Block)
    -> UIView {
        self.if(observer().asObservable(), then: then)
    }
    
    public func `if`(_ observer: @autoclosure ()->BehaviorRelay<Bool>,
                     @ViewGroup then: @escaping Block,
                     @ViewGroup else: @escaping Block)
    -> UIView {
        self.if(observer().asObservable(), then: then, else: `else`)
    }
    
    public func `if`(_ observer: @autoclosure ()->Observable<Bool>,
                     @ViewGroup then: @escaping Block)
    -> UIView {
        let view = UIGroupView()
        observer()
            .distinctUntilChanged()
            .subscribe(onNext: {condition in
                view.subviews.forEach { $0.removeFromSuperview() }
                if condition {
                    then().forEach { view.addArrangedSubview($0) }
                }
            })
            .disposed(by: self.disposeBag)
        return view
    }
    
    public func `if`(_ observer: @autoclosure ()->Observable<Bool>,
                     @ViewGroup then: @escaping Block,
                     @ViewGroup else: @escaping Block)
    -> UIView {
        let view = UIGroupView()
        observer()
            .distinctUntilChanged()
            .subscribe(onNext: {condition in
                view.subviews.forEach { $0.removeFromSuperview() }
                if condition {
                    then().forEach { view.addArrangedSubview($0) }
                } else {
                    `else`().forEach { view.addArrangedSubview($0) }
                }
            })
            .disposed(by: self.disposeBag)
        return view
    }
}

extension Subscriber {
    public func forEach<T: Collection>(_ observer: @autoclosure ()->Observable<T>,
                                       @ViewGroup perform: @escaping (T.Element)->[UIView])
    -> UIView {
        let view = UIGroupView()
        observer()
            .subscribe(onNext: {list in
                view.subviews.forEach { $0.removeFromSuperview() }
                list.forEach {
                    perform($0).forEach { view.addArrangedSubview($0) }
                }
            })
            .disposed(by: self.disposeBag)
        return view
    }
}
#endif

#endif

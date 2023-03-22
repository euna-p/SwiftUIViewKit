//
//  SUVK+Builder.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/23.
//

#if swift(>=5.4)
import UIKit

import SnapKit

#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa
#endif

@resultBuilder
public struct ViewGroup {
    
}

extension ViewGroup {
    public static func buildBlock(_ components: UIView...) -> [UIView] {
        return components
    }
    
    #if canImport(RxSwift) && canImport(RxCocoa)
    public static func buildOptional(_ component: [UIView]?) -> UIView {
        return UIGroupView(views: component ?? [])
    }
    #endif
    
    #if canImport(RxSwift) && canImport(RxCocoa)
    public static func buildEither(first component: [UIView]) -> UIView {
        return UIGroupView(views: component)
    }
    #endif
    
    #if canImport(RxSwift) && canImport(RxCocoa)
    public static func buildEither(second component: [UIView]) -> UIView {
        return UIGroupView(views: component)
    }
    #endif
    
    #if canImport(RxSwift) && canImport(RxCocoa)
    public static func buildArray(_ components: [[UIView]]) -> UIView {
        return UIGroupView(views: components.flatMap { $0 })
    }
    #endif
}

extension UIGroupView {
    public convenience init(@ViewGroup content: (()->[UIView])) {
        let views = content()
        self.init(views: views)
    }
}

open class UIVStackView: UIStackView {
    private var isPassthroughHit = false
    
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
    
    public func passthroughHit(_ flag: Bool = true) {
        self.isPassthroughHit = flag
    }
}

open class UIHStackView: UIStackView {
    private var isPassthroughHit = false
    
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
    
    public func passthroughHit(_ flag: Bool = true) {
        self.isPassthroughHit = flag
    }
}
#endif

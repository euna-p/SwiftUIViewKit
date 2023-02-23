//
//  SUVK+UIStackView.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

open class UIVStackView: UIStackView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis      = .vertical
        self.spacing   = .zero
        self.alignment = .fill
    }
    
    public convenience init(@ViewGroup content: (()->[UIView])) {
        self.init(frame: .zero)
        content().forEach {
            self.addArrangedSubview($0)
        }
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

open class UIHStackView: UIStackView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis      = .horizontal
        self.spacing   = .zero
        self.alignment = .fill
    }
    
    public convenience init(@ViewGroup content: (()->[UIView])) {
        self.init(frame: .zero)
        content().forEach {
            self.addArrangedSubview($0)
        }
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension UIStackView {
    public static func vstack() -> UIStackView {
        return Self.vstack(views: [])
    }
    public static func vstack(_ views: UIView...) -> UIStackView {
        return Self.vstack(views: views)
    }
    public static func vstack(views: [UIView]) -> UIStackView {
        let vstack = UIVStackView(frame: .zero)
        views.forEach {
            vstack.addArrangedSubview($0)
        }
        return vstack
    }
    
    public static func hstack() -> UIStackView {
        return Self.hstack(views: [])
    }
    public static func hstack(_ views: UIView...) -> UIStackView {
        return Self.hstack(views: views)
    }
    public static func hstack(@ViewGroup content: (()->[UIView])) -> UIStackView {
        return Self.hstack(views: content())
    }
    public static func hstack(views: [UIView]) -> UIStackView {
        let hstack = UIHStackView(frame: .zero)
        views.forEach {
            hstack.addArrangedSubview($0)
        }
        return hstack
    }
    
    public func spacing(_ value: CGFloat) -> Self {
        self.spacing = value
        return self
    }
    
    public func alignment(_ value: UIStackView.Alignment) -> Self {
        self.alignment = value
        return self.rearrange()
    }
    
    public func distribution(_ value: Distribution) -> Self {
        self.distribution = value
        return self.rearrange()
    }
    
    private func rearrange() -> Self {
        self.subviews.forEach {
            $0.removeFromSuperview()
            self.addArrangedSubview($0)
        }
        return self
    }
}

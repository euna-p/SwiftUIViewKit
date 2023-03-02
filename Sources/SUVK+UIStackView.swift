//
//  SUVK+UIStackView.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

extension UIStackView {
    public static func vstack() -> UIStackView {
        return Self.vstack(views: [])
    }
    public static func vstack(_ views: UIView...) -> UIStackView {
        return Self.vstack(views: views)
    }
    public static func vstack(views: [UIView]) -> UIStackView {
        let vstack = UIStackView(frame: .zero)
        vstack.axis = .vertical
        vstack.spacing = 0.0
        vstack.alignment = .fill
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
        let hstack = UIStackView(frame: .zero)
        hstack.axis = .horizontal
        hstack.spacing = 0.0
        hstack.alignment = .fill
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

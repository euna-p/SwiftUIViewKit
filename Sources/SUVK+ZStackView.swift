//
//  SUVK+ZStackView.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/05/11.
//

import UIKit

open class UIZStackView: UIView {
    public enum Alignment {
        case fill
        case topLeft, top, topRight
        case left, center, right
        case bottomLeft, bottom, bottomRight
    }
    
    private var alignment: Alignment = .fill
    
    public convenience init(content: UIView...) {
        self.init(frame: .zero)
        self.setContent(content)
    }
    
    public convenience init(content: [UIView]) {
        self.init(frame: .zero)
        self.setContent(content)
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        
        if view == self, let color = self.color(of: point), color.cgColor.alpha <= 0.0 {
            return nil
        }
        
        return view
    }
}

extension UIZStackView {
    private func clearContent() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func setContent(_ content: [UIView]) {
        self.clearContent()
        content.forEach {
            self.addArrangedSubview($0)
        }
    }
    
    public func addArrangedSubview(_ view: UIView) {
        self.addSubview(view)
        view.snp.makeConstraints {
            switch self.alignment {
            case .fill:
                $0.edges.equalToSuperview()
            case .topLeft:
                $0.top.leading.equalToSuperview()
                $0.trailing.bottom.lessThanOrEqualToSuperview()
            case .top:
                $0.top.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.leading.greaterThanOrEqualToSuperview()
                $0.trailing.bottom.lessThanOrEqualToSuperview()
            case .topRight:
                $0.top.trailing.equalToSuperview()
                $0.leading.greaterThanOrEqualToSuperview()
                $0.bottom.lessThanOrEqualToSuperview()
            case .left:
                $0.top.greaterThanOrEqualToSuperview()
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.trailing.bottom.lessThanOrEqualToSuperview()
            case .center:
                $0.top.leading.greaterThanOrEqualToSuperview()
                $0.centerX.centerY.equalToSuperview()
                $0.trailing.bottom.lessThanOrEqualToSuperview()
            case .right:
                $0.top.leading.greaterThanOrEqualToSuperview()
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.bottom.lessThanOrEqualToSuperview()
            case .bottomLeft:
                $0.top.greaterThanOrEqualToSuperview()
                $0.leading.equalToSuperview()
                $0.trailing.lessThanOrEqualToSuperview()
                $0.bottom.equalToSuperview()
            case .bottom:
                $0.top.leading.greaterThanOrEqualToSuperview()
                $0.centerX.equalToSuperview()
                $0.trailing.lessThanOrEqualToSuperview()
                $0.bottom.equalToSuperview()
            case .bottomRight:
                $0.top.leading.greaterThanOrEqualToSuperview()
                $0.trailing.bottom.equalToSuperview()
            }
        }
        self.setNeedsLayout()
    }
}

extension UIZStackView {
    @discardableResult
    public func alignment(_ alignment: Alignment) -> Self {
        if self.alignment != alignment {
            self.alignment = alignment
            self.subviews.forEach {
                $0.removeFromSuperview()
                self.addArrangedSubview($0)
            }
        }
        return self
    }
}

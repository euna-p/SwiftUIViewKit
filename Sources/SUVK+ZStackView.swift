//
//  SUVK+ZStackView.swift
//  SwiftUIViewKit
//
//  Created by Leopard on 2023/05/11.
//

import UIKit

open class UIZStackView: UIView {
    public var alignment: UIStackView.Alignment = .fill {
        didSet { self.setAlignment() }
    }
    
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
            self.addSubview($0)
        }
        self.setAlignment()
    }
    
    private func setAlignment() {
        self.subviews.forEach {view in
            view.removeFromSuperview()
            self.addSubview(view)
            view.snp.makeConstraints {
                switch self.alignment {
                case .fill:     $0.edges.equalToSuperview()
                case .top:      $0.top.equalToSuperview()
                case .leading:  $0.leading.equalToSuperview()
                case .center:   $0.centerX.centerY.equalToSuperview()
                case .trailing: $0.trailing.equalToSuperview()
                case .bottom:   $0.bottom.equalToSuperview()
                default:        break
                }
                if self.alignment != .fill {
                    if self.alignment != .top {
                        $0.top.greaterThanOrEqualToSuperview()
                    }
                    if self.alignment != .leading {
                        $0.leading.greaterThanOrEqualToSuperview()
                    }
                    if self.alignment != .trailing {
                        $0.trailing.lessThanOrEqualToSuperview()
                    }
                    if self.alignment != .bottom {
                        $0.bottom.lessThanOrEqualToSuperview()
                    }
                }
            }
        }
    }
}

extension UIZStackView {
    public func alignment(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }
}

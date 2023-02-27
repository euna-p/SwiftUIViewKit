//
//  SUVK+GroupView.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/27.
//

import UIKit

open class UIGroupView: UIStackView {
    private let emptyView = UIView(frame: .zero)
    
    public convenience init(_ views: UIView...) {
        self.init(views: views)
    }
    
    public convenience init(views: [UIView]) {
        self.init(frame: .zero)
        
        self.addArrangedSubview(self.emptyView)
        
        if !views.isEmpty {
            self.subviews.forEach { $0.removeFromSuperview() }
            views.forEach { self.addArrangedSubview($0) }
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if let superView = self.superview as? UIStackView {
            self.axis         = superView.axis
            self.spacing      = superView.spacing
            self.alignment    = superView.alignment
            self.distribution = superView.distribution
        }
        
        self.emptyView.frame.size = .zero
        self.emptyView.snp.remakeConstraints {
            switch self.axis {
            case .vertical:   $0.width.equalTo(0.0)
            case .horizontal: $0.height.equalTo(0.0)
            @unknown default: break
            }
        }
    }
}

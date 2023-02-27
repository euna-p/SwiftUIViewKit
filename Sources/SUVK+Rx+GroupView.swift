//
//  SUVK+GroupView.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/27.
//

import UIKit

#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa

open class UIGroupView: UIStackView {
    private let disposeBag = DisposeBag()
    
    public convenience init(_ views: UIView...) {
        self.init(views: views)
    }
    
    public convenience init(views: [UIView]) {
        self.init(frame: .zero)
        
        let emptyView = UIView(frame: .zero)
        self.addArrangedSubview(emptyView)
        self.rx.layoutSubviews
            .subscribe(onNext: {_ in
                guard let superView = self.superview as? UIStackView else { return }
                self.axis         = superView.axis
                self.spacing      = superView.spacing
                self.alignment    = superView.alignment
                self.distribution = superView.distribution
                emptyView.frame.size = .zero
                emptyView.snp.remakeConstraints {
                    switch self.axis {
                    case .vertical:   $0.width.equalTo(0.0)
                    case .horizontal: $0.height.equalTo(0.0)
                    @unknown default: break
                    }
                }
            })
            .disposed(by: self.disposeBag)
        if !views.isEmpty {
            self.subviews.forEach { $0.removeFromSuperview() }
            views.forEach { self.addArrangedSubview($0) }
        }
    }
}
#endif

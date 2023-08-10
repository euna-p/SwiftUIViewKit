//
//  SUVK+UIScrollView.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

open class UIVScrollView: UIScrollView {
    public convenience init(@ViewGroup content: (()->[UIView])) {
        let subview = UIVStackView(content: content)
        self.init(frame: .zero)
        self.addSubview(subview)
        subview.didMoveToSuperview()
        subview.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().priority(.required)
            $0.width.equalToSuperview().priority(.required)
        }
    }
}

open class UIHScrollView: UIScrollView {
    public convenience init(@ViewGroup content: (()->[UIView])) {
        let subview = UIHStackView(content: content)
        self.init(frame: .zero)
        self.addSubview(subview)
        subview.didMoveToSuperview()
        subview.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().priority(.required)
            $0.height.equalToSuperview().priority(.required)
        }
    }
}

extension UIScrollView {
    public static func vscroll(_ content: UIView) -> UIScrollView {
        return UIVScrollView { content }
    }
    
    public static func hscroll(_ content: UIView) -> UIScrollView {
        return UIHScrollView { content }
    }
    
    public var isScrolledHorizontalLast: Bool {
        self.contentOffset.x >= self.contentSize.width - self.bounds.size.width + self.contentInset.right
    }
    
    public var isScrolledVerticalLast: Bool {
        self.contentOffset.y >= self.contentSize.height - self.bounds.size.height + self.contentInset.bottom
    }
    
    public func showsScrollIndicator(_ flag: Bool) -> Self {
        self.showsVerticalScrollIndicator   = flag
        self.showsHorizontalScrollIndicator = flag
        return self
    }
    
    public func pagingEnabled(_ flag: Bool) -> Self {
        self.isPagingEnabled = flag
        return self
    }
}

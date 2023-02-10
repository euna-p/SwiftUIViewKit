//
//  SUVK+UIScrollView.swift
//  ParkingShare
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

extension UIScrollView {
    public static func vscroll(_ content: UIView) -> UIScrollView {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.addSubview(content)
        content.didMoveToSuperview()
        content.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().priority(.required)
            $0.width.equalToSuperview().priority(.required)
        }
        return scrollview
    }
    
    public static func hscroll(_ content: UIView) -> UIScrollView {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.addSubview(content)
        content.didMoveToSuperview()
        content.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().priority(.required)
            $0.height.equalToSuperview().priority(.required)
        }
        return scrollview
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

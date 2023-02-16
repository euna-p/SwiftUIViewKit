//
//  UITableViewExtensions.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/16.
//

import UIKit

extension UITableView {
    func headerViewSizeToFit() {
        if let headerView = self.tableHeaderView {
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            
            self.tableHeaderView = headerView
        }
    }
}

//
//  UIEdgeInsets.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/17.
//

import UIKit

extension UIEdgeInsets {
    public static var safeAreaInsets: UIEdgeInsets {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.keyWindow else { return .zero }
        return window.safeAreaInsets
    }
}

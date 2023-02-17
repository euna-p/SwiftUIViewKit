//
//  UIApplication.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/17.
//

import UIKit

extension UIApplication {
    public var keyWindow: UIWindow? {
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
    }
}

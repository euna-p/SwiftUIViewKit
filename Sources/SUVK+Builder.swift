//
//  SUVK+Builder.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/23.
//

import UIKit

@resultBuilder
public struct ViewGroup {
    
}

extension ViewGroup {
    public static func buildBlock(_ components: UIView...) -> [UIView] {
        return components
    }
    
    public static func buildEither(first component: UIView) -> [UIView] {
        return [component]
    }
    
    public static func buildEither(second component: UIView) -> [UIView] {
        return [component]
    }
}

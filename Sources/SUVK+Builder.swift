//
//  SUVK+Builder.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/23.
//

import UIKit

@resultBuilder
open class ViewGroup {
    
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

extension ViewGroup {
    public static func buildBlock(_ components: UILabel...) -> [UILabel] {
        return components
    }
    
    public static func buildEither(first component: UILabel) -> [UILabel] {
        return [component]
    }
    
    public static func buildEither(second component: UILabel) -> [UILabel] {
        return [component]
    }
}

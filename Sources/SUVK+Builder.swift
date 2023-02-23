//
//  SUVK+Builder.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/23.
//

import UIKit

@resultBuilder
open class ViewGroup {
    static func buildBlock(_ components: UIView...) -> [UIView] {
        return components
    }
    
    static func buildEither(first component: UIView) -> [UIView] {
        return [component]
    }
    
    static func buildEither(second component: UIView) -> [UIView] {
        return [component]
    }
    
    static func buildBlock(_ components: UILabel...) -> [UILabel] {
        return components
    }
    
    static func buildEither(first component: UILabel) -> [UILabel] {
        return [component]
    }
    
    static func buildEither(second component: UILabel) -> [UILabel] {
        return [component]
    }
}

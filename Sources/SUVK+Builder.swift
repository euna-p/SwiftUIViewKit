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
    
    static func buildBlock(_ components: UILabel...) -> [UILabel] {
        return components
    }
}

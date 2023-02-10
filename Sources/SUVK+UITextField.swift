//
//  SUVK+UITextField.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

extension UITextField {    
    public func placeholder(_ placeholder: String?) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    public func placeholder(_ placeholder: NSAttributedString?) -> Self {
        self.attributedPlaceholder = placeholder
        return self
    }
}

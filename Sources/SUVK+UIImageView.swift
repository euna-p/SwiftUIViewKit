//
//  SUVK+UIImageView.swift
//  ParkingShare
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

import SnapKit

extension UIImageView {
    public convenience init(named name: String) {
        self.init(image: .init(named: name))
    }
    
    @available(iOS 13.0, *)
    public convenience init(systemName name: String) {
        self.init(image: .init(systemName: name))
    }
    
    public func renderingMode(_ mode: UIImage.RenderingMode) -> Self {
        self.image = self.image?.withRenderingMode(mode)
        return self
    }
}

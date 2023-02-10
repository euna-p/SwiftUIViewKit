//
//  SUVK+Divider.swift
//  ParkingShare
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

import SnapKit

open class Divider: UIView {
    public var color: UIColor = .lightGray {
        didSet {
            self.layoutSubviews()
        }
    }
    
    public init(lineWeight: CGFloat = 1.0) {
        super.init(frame: .zero)
        self.snp.makeConstraints {
            $0.height.equalTo(lineWeight)
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = self.color
    }
}

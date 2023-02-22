//
//  SUVK+DottedDivider.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

import SnapKit

open class DottedDivider: UIView {
    private var pattern: (NSNumber, NSNumber) = (3.0, 2.0)
    
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
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor     = self.color.cgColor
        shapeLayer.lineWidth       = self.bounds.size.height
        shapeLayer.lineDashPattern = [self.pattern.0, self.pattern.1]

        let path = CGMutablePath()
        path.addLines(between: [.zero, .init(x: self.bounds.size.width, y: 0.0)])
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    @discardableResult
    public func setPattern(line: CGFloat, space: CGFloat) -> Self {
        self.pattern = (NSNumber(value: line), NSNumber(value: space))
        self.setNeedsLayout()
        return self
    }
}

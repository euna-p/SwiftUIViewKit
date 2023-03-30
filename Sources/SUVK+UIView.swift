//
//  SUVK+UIView.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

extension UIView {
    @discardableResult
    public func configuration<T: UIView>(_ perform: (T)->Void) -> Self {
        if let t = self as? T {
            perform(t)
        }
        return self
    }
    
    public func priority(_ priority: UILayoutPriority) -> Self {
        self.priority(priority, axis: .horizontal)
            .priority(priority, axis: .vertical)
    }
    
    public func priority(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) -> Self {
        self.setContentHuggingPriority(priority, for: axis)
        self.setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
    
    @discardableResult
    public func build(to superView: UIView, isIgnoreSafeAreaLayoutGuide: Bool = false) -> Self {
        superView.addSubview(self)
        self.didMoveToSuperview()
        
        self.snp.makeConstraints {
            if isIgnoreSafeAreaLayoutGuide {
                $0.edges.equalToSuperview().priority(.required)
            } else {
                $0.edges.equalTo(superView.safeAreaLayoutGuide).priority(.required)
            }
        }
        
        self.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        return self
    }
    
    private func corver(isPassthroughHit: Bool) -> UIView {
        let corverView = isPassthroughHit ? PaddingView(frame: .zero) : UIView(frame: .zero)
        corverView.backgroundColor = .clear
        corverView.addSubview(self)
        self.didMoveToSuperview()
        return corverView
    }
}

extension UIView {
    public func add(gesture: UIGestureRecognizer) -> Self {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
        return self
    }
    
    public func set(accessibilityValue: String?) -> Self {
        self.accessibilityValue = accessibilityValue
        return self
    }
}

extension UIView {
    public enum VisibleState {
        case normal, gone, hidden
    }
    
    public static func emptyView() -> UIView {
        let view = UIView(frame: .zero)
        view.snp.makeConstraints {
            $0.width.height.equalTo(CGFloat.leastNonzeroMagnitude)
        }
        return view
    }
    
    public func hidden(_ flag: Bool = true) -> Self {
        self.isHidden = flag
        return self
    }
    
    public func visible(_ state: VisibleState = .normal) -> Self {
        let constraintKey = "UIView_VislbleState"
        
        self.constraints.forEach {
            guard $0.accessibilityValue == constraintKey else { return }
            self.removeConstraint($0)
        }
        
        switch state {
        case .normal:
            self.isHidden = false
            return self
        case .gone:
            let width  = NSLayoutConstraint(item: self,  attribute: .width,
                                            relatedBy: .equal, toItem: nil, attribute: .width,
                                            multiplier: 1.0,
                                            constant: 0.0)
            let height = NSLayoutConstraint(item: self, attribute: .height,
                                            relatedBy: .equal, toItem: nil, attribute: .height,
                                            multiplier: 1.0,
                                            constant: 0.0)
            width.accessibilityValue  = constraintKey
            height.accessibilityValue = constraintKey
            width.priority  = .medium
            height.priority = .medium
            self.addConstraints([width, height])
            self.isHidden = true
            return self
        case .hidden:
            self.isHidden = true
            return self
        }
    }
}

extension UIView {
    public func color(_ color: UIColor) -> Self {
        if let view = self as? UILabel {
            view.textColor = color
        }
        if let view = self as? UITextField {
            view.textColor = color
        }
        if let view = self as? UITextView {
            view.textColor = color
        }
        if let view = self as? UIImageView {
            view.tintColor = color
        }
        
        if let view = self as? Divider {
            view.color = color
        }
        if let view = self as? DottedDivider {
            view.color = color
        }
        
        self.subviews.forEach { _ = $0.color(color) }
        return self
    }
    
    public func contentMode(_ mode: ContentMode) -> Self {
        self.contentMode = mode
        return self
    }
}

extension UIView {
    public func background(_ color: UIColor) -> Self {
        self.layer.backgroundColor = color.cgColor
        return self
    }
    
    public func background(_ view: UIView) -> Self {
        self.addSubview(view)
        self.sendSubviewToBack(view)
        view.didMoveToSuperview()
        view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        return self
    }
    
    public func overlay(_ view: UIView,
                        horizontalAlignment: HAlignment? = nil,
                        verticalAlignment: VAlignment? = nil)
    -> Self {
        self.addSubview(view)
        self.bringSubviewToFront(view)
        view.didMoveToSuperview()
        view.snp.makeConstraints {
            switch horizontalAlignment {
            case .left:   $0.leading.equalToSuperview()
            case .center: $0.centerX.equalToSuperview()
            case .right:  $0.trailing.equalToSuperview()
            case .none:   $0.leading.trailing.equalToSuperview()
            }
            switch verticalAlignment {
            case .top:    $0.top.equalToSuperview()
            case .center: $0.centerY.equalToSuperview()
            case .bottom: $0.bottom.equalToSuperview()
            case .none:   $0.top.bottom.equalToSuperview()
            }
        }
        return self
    }
    
    public func alpha(_ value: CGFloat) -> Self {
        self.alpha = value
        return self
    }
    
    public func mask(toBound flag: Bool = true) -> Self {
        self.layer.masksToBounds = flag
        return self
    }
    
    public func corner(radius: CGFloat, masksToBounds flag: Bool = true) -> Self {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = flag
        if #available(iOS 13.0, *) {
            self.layer.cornerCurve = .continuous
        }
        return self
    }
    
    public func border(color: UIColor, masksToBounds flag: Bool = true) -> Self {
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = flag
        return self
    }
    
    public func border(width: CGFloat, masksToBounds flag: Bool = true) -> Self {
        self.layer.borderWidth = width
        self.layer.masksToBounds = flag
        return self
    }
    
    public func clip(_ flag: Bool = true) -> Self {
        self.clipsToBounds = flag
        return self
    }
}

extension UIView {
    public enum EdgePoint {
        case top, left, right, bottom
        case horizontal, vertical, all
    }
    
    public func padding(_ edge: EdgePoint, _ value: CGFloat, isPassthroughHit: Bool = false) -> UIView {
        let view = self.corver(isPassthroughHit: isPassthroughHit)
        self.snp.makeConstraints {
            switch edge {
            case .top:
                $0.top.equalToSuperview().offset(value)
                $0.leading.trailing.bottom.equalToSuperview()
            case .left:
                $0.leading.equalToSuperview().offset(value)
                $0.top.trailing.bottom.equalToSuperview()
            case .right:
                $0.trailing.equalToSuperview().offset(-value)
                $0.top.leading.bottom.equalToSuperview()
            case .bottom:
                $0.bottom.equalToSuperview().offset(-value)
                $0.top.leading.trailing.equalToSuperview()
            case .horizontal:
                $0.leading.equalToSuperview().offset(value)
                $0.trailing.equalToSuperview().offset(-value)
                $0.top.bottom.equalToSuperview()
            case .vertical:
                $0.top.equalToSuperview().offset(value)
                $0.bottom.equalToSuperview().offset(-value)
                $0.leading.trailing.equalToSuperview()
            case .all:
                $0.top.leading.equalToSuperview().offset(value)
                $0.trailing.bottom.equalToSuperview().offset(-value)
            }
        }
        return view
    }
    
    public func padding(_ value: UIEdgeInsets, isPassthroughHit: Bool = false) -> UIView {
        let view = self.corver(isPassthroughHit: isPassthroughHit)
        self.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(value)
        }
        return view
    }
    
    public func ignoreSafeArea(_ edge: EdgePoint) -> UIView {
        guard #available(iOS 11.0, *),
              let safeAreaInsets = self.getKeyWindow()?.safeAreaInsets
        else { return self }
        
        switch edge {
        case .top:        return self.padding(.top,    -safeAreaInsets.top)
        case .left:       return self.padding(.left,   -safeAreaInsets.left)
        case .right:      return self.padding(.right,  -safeAreaInsets.right)
        case .bottom:     return self.padding(.bottom, -safeAreaInsets.bottom)
        case .horizontal: return self.ignoreSafeArea(.left).ignoreSafeArea(.right)
        case .vertical:   return self.ignoreSafeArea(.top).ignoreSafeArea(.bottom)
        case .all:
            return self.ignoreSafeArea(.top).ignoreSafeArea(.left).ignoreSafeArea(.right).ignoreSafeArea(.bottom)
        }
    }
    
    private func getKeyWindow() -> UIWindow? {
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes
                        .filter { $0.activationState == .foregroundActive }
                        .first { $0 is UIWindowScene }
                        .flatMap { $0 as? UIWindowScene }?
                        .windows
                        .first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.windows.first(where: \.isKeyWindow)
        }
    }
}

extension UIView {
    public enum HAlignment {
        case left, center, right
    }
    
    public enum VAlignment {
        case top, center, bottom
    }

    public func frame(width: CGFloat, height: CGFloat) -> Self {
        self
            .frame(width: width)
            .frame(height: height)
    }
    
    public func frame(minWidth: CGFloat? = nil, minHeight: CGFloat? = nil,
                      maxWidth: CGFloat?  = nil, horizontalAlignment: HAlignment,
                      maxHeight: CGFloat? = nil, verticalAlignment: VAlignment,
                      width: CGFloat, height: CGFloat)
    -> UIView {
        var corverView = self
        if let value = minWidth {
            corverView = corverView.frame(minWidth:  value)
        }
        if let value = minHeight {
            corverView = corverView.frame(minHeight: value)
        }
        if let value = maxWidth {
            corverView = corverView.frame(maxWidth:  value, horizontalAlignment: horizontalAlignment)
        }
        if let value = maxHeight {
            corverView = corverView.frame(maxHeight: value, verticalAlignment:   verticalAlignment)
        }
        return corverView
            .frame(width:  width,  horizontalAlignment: horizontalAlignment)
            .frame(height: height, verticalAlignment:   verticalAlignment)
    }
    
    public func frame(width: CGFloat) -> Self {
        self.snp.makeConstraints {
            $0.width.equalTo(width)
        }
        return self
    }
    
    public func frame(height: CGFloat) -> Self {
        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
        return self
    }
    
    public func frame(width: CGFloat, horizontalAlignment: HAlignment) -> UIView {
        let view = self.corver(isPassthroughHit: false)
        self.set(horizontalAlignment: horizontalAlignment)
        self.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
        view.snp.makeConstraints {
            $0.width.equalTo(width)
        }
        return view
    }
    
    public func frame(height: CGFloat, verticalAlignment: VAlignment) -> UIView {
        let view = self.corver(isPassthroughHit: false)
        self.set(verticalAlignment: verticalAlignment)
        self.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        view.snp.makeConstraints {
            $0.height.equalTo(height)
        }
        return view
    }
    
    private func set(horizontalAlignment: HAlignment) {
        self.snp.makeConstraints {
            switch horizontalAlignment {
            case .left:
                $0.leading.equalToSuperview()
                $0.trailing.lessThanOrEqualToSuperview()
            case .center:
                $0.centerX.equalToSuperview()
                $0.leading.greaterThanOrEqualToSuperview()
                $0.trailing.lessThanOrEqualToSuperview()
            case .right:
                $0.leading.greaterThanOrEqualToSuperview()
                $0.trailing.equalToSuperview()
            }
        }
    }
    
    private func set(verticalAlignment: VAlignment) {
        self.snp.makeConstraints {
            switch verticalAlignment {
            case .top:
                $0.top.equalToSuperview()
                $0.bottom.lessThanOrEqualToSuperview()
            case .center:
                $0.centerY.equalToSuperview()
                $0.top.greaterThanOrEqualToSuperview()
                $0.bottom.lessThanOrEqualToSuperview()
            case .bottom:
                $0.top.greaterThanOrEqualToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    public func frame(maxWidth: CGFloat,  horizontalAlignment: HAlignment = .center,
                      maxHeight: CGFloat, verticalAlignment: VAlignment   = .center)
    -> UIView {
        self.frame(maxWidth:  maxWidth,  horizontalAlignment: horizontalAlignment)
            .frame(maxHeight: maxHeight, verticalAlignment:   verticalAlignment)
    }
    
    public func frame(maxWidth: CGFloat, horizontalAlignment: HAlignment = .center) -> UIView {
        let view = self.corver(isPassthroughHit: false)
        self.set(horizontalAlignment: horizontalAlignment)
        self.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
        view.snp.makeConstraints {
            $0.width.lessThanOrEqualTo(maxWidth)
        }
        return view
    }
    
    public func frame(maxHeight: CGFloat, verticalAlignment: VAlignment = .center) -> UIView {
        let view = self.corver(isPassthroughHit: false)
        self.set(verticalAlignment: verticalAlignment)
        self.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        view.snp.makeConstraints {
            $0.height.lessThanOrEqualTo(maxHeight)
        }
        return view
    }
    
    public func frame(minWidth: CGFloat, minHeight: CGFloat) -> UIView {
        self.frame(minWidth:  minWidth)
            .frame(minHeight: minHeight)
    }
    
    public func frame(minWidth: CGFloat) -> Self {
        self.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(minWidth)
        }
        return self
    }
    
    public func frame(minHeight: CGFloat) -> Self {
        self.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(minHeight)
        }
        return self
    }
}

extension UIView {
    public func sketchShadow(color: UIColor = .black, alpha: CGFloat = 1.0,
                             x: CGFloat = 0.0, y: CGFloat = 0.0,
                             blur: CGFloat = 0.0, spread: CGFloat = 0.0)
    -> Self {
        var r: CGFloat = 0.0,
            g: CGFloat = 0.0,
            b: CGFloat = 0.0,
            a: CGFloat = 0.0
        if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
            let color = UIColor(red: r, green: g, blue: b, alpha: a)
            self.layer.shadowColor   = color.cgColor
            self.layer.shadowOpacity = Float(a * alpha)
        } else {
            self.layer.shadowColor   = color.cgColor
            self.layer.shadowOpacity = Float(alpha)
        }
        
        self.layer.masksToBounds = false
        
        self.layer.shadowOffset  = CGSize(width: x, height: y)
        self.layer.shadowRadius  = blur / 2.0
        if spread == 0 {
            self.layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
        
        return self
    }
}

extension UIView {
    public static func spacer() -> UIView {
        let view = UIView(frame: .zero)
        view.snp.makeConstraints {
            $0.width.height.greaterThanOrEqualTo(0.0)
        }
        return view
    }
    
    public static func corverView(_ views: UIView...,
                                  horizontalAlignment: HAlignment = .center,
                                  verticalAlignment: VAlignment   = .center)
    -> UIView {
        let view = UIView(frame: .zero)
        
        views.forEach {
            view.addSubview($0)
            $0.didMoveToSuperview()
            $0.set(horizontalAlignment: horizontalAlignment)
            $0.set(verticalAlignment:   verticalAlignment)
        }
        
        return view
    }
}

class PaddingView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        
        if view == self, let color = self.color(of: point), color.cgColor.alpha <= 0.0 {
            return nil
        }
        
        return view
    }
}

extension UIView {
    func color(of point: CGPoint) -> UIColor? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var pixel: [UInt8] = [0, 0, 0, 0]
        
        guard let context = CGContext(data:             &pixel,
                                      width:            1,
                                      height:           1,
                                      bitsPerComponent: 8,
                                      bytesPerRow:      4,
                                      space:            colorSpace,
                                      bitmapInfo:       bitmapInfo.rawValue)
        else { return nil }
        
        context.translateBy(x: -point.x, y: -point.y)
        self.layer.render(in: context)
        
        return UIColor(red:   CGFloat(pixel[0]) / 255.0,
                       green: CGFloat(pixel[1]) / 255.0,
                       blue:  CGFloat(pixel[2]) / 255.0,
                       alpha: CGFloat(pixel[3]) / 255.0)
    }
}

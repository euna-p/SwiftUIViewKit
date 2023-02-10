//
//  SUVKBase.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

public typealias SwiftUIViewKit = UIViewKitAbstract & UIViewKitClass

public protocol UIViewKitAbstract: AnyObject {
    var body: UIView { get }
}

open class UIViewKitClass: UIView {
    private let runOnOnceForFirstLayout = RunOnOnce()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.runOnOnceForFirstLayout.run {
            self.setContent()
        }
    }
    
    public func clearContent() {
        self.subviews.forEach {
            $0.removeFromSuperview()
            $0.didMoveToSuperview()
        }
    }
    
    public func setContent() {
        self.clearContent()
        if let body = (self as? UIViewKitAbstract)?.body {
            body.build(to: self)
        }
    }
}

#if canImport(SwiftUI)
import SwiftUI
extension UIViewKitClass {
    @available(iOS 13.0, *)
    public static var view: some View {
        return Representable<UIView>(from: { Self.init() })
    }
    
    @available(iOS 13.0, *)
    public static func modifier(_ perform: @escaping (UIView)->UIView) -> some View {
        return Representable<UIView>(from: {
            let view = Self.init()
            return perform(view)
        })
    }
    
    @available(iOS 13.0, *)
    public static func configure(_ perform: @escaping (UIView)->Void) -> some View {
        return Representable<UIView>(from: {
            let view = Self.init()
            perform(view)
            return view
        })
    }
}
#endif

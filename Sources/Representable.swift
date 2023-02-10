//
//  Representable.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
struct Representable<T: UIView>: UIViewRepresentable {
    private class Block {
        public typealias Closure = (T) -> Void
        public var block: Closure?
    }
    
    private let uiView: T
    private let configuration: Block = .init()
    private let updateView: Block    = .init()
    
    public init(from instance: @escaping () -> T) {
        self.uiView = instance()
        self.uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.uiView.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.uiView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    public init(configuration: @escaping (T) -> Void) {
        self.uiView = .init(frame: .zero)
        self.uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.uiView.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.uiView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        configuration(self.uiView)
    }
    
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> T {
        self.configuration.block?(self.uiView)
        return self.uiView
    }
    
    public func updateUIView(_ uiView: T, context: UIViewRepresentableContext<Self>) {
        self.updateView.block?(uiView)
    }
    
    public func onMake(perform: @escaping (T) -> Void) -> Self {
        self.configuration.block = perform
        return self
    }
    
    public func onUpdate(perform: @escaping (T) -> Void) -> Self {
        self.updateView.block = perform
        return self
    }
}
#endif

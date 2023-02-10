//
//  RunOnOnce.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import Foundation

public class RunOnOnce {
    private var isRunned: Bool = false
    
    init() {
        self.reset()
    }
    
    @discardableResult
    internal func run(_ closure: (() -> Void)) -> Bool {
        guard !self.isRunned else { return false }
        self.isRunned = true
        closure()
        return true
    }
    
    internal func reset() {
        self.isRunned = false
    }
}

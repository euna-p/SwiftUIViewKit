//
//  RxSwiftExtensions.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/10.
//

import Foundation

import RxSwift
import RxRelay

extension BehaviorRelay {
    public var unwrappedValue: Element {
        get { return self.value }
        set { self.accept(newValue) }
    }
}

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

extension PublishRelay where Element == Void {
    public func accept() {
        self.accept(())
    }
}

extension Observable {
    public var asOptional: Observable<Optional<Element>> {
        return self.map({ $0 })
    }
}

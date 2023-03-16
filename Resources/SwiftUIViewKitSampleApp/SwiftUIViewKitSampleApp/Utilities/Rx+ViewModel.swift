//
//  Rx+ViewModel.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/03/16.
//

import Foundation

import RxRelay

protocol ViewModel {
    init()
}
extension ViewModel {
    typealias Relay = BehaviorRelay
    static var relay: Relay<Self> {
        .init(value: .init())
    }
}

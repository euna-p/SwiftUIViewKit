//
//  MainViewModel.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/10.
//

import Foundation

struct MainViewModel: ViewModel {
    var userText: String = ""
    var clickedCount: Int = 0
}

extension ViewModel.Relay where Element == MainViewModel {
    func increaseCount() {
        self.unwrappedValue.clickedCount += 1
    }
    
    func decreaseCount() {
        self.unwrappedValue.clickedCount -= 1
    }
}

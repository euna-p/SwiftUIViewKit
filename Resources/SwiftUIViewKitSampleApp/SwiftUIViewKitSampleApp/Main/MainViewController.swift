//
//  MainViewController.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/10.
//

import UIKit

class MainViewController: UIViewController {
    private let content = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SwiftUIViewKit"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.content
            .build(to: self.view)
    }


}


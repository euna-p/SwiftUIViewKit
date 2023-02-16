//
//  SecondViewController.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/10.
//

import UIKit

class SecondViewController: UIViewController {
    private let content = SecondView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Second View"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.content
            .build(to: self.view)
    }


}


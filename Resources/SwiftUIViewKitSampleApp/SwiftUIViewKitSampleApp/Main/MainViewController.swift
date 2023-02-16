//
//  MainViewController.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/10.
//

import UIKit

import RxSwift

class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let content = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SwiftUIViewKit"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.content
            .build(to: self.view)
        
        self.content
            .didTappedNavigateToSecondView
            .subscribe(onNext: {[unowned self] in
                let viewController = SecondViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)
    }


}


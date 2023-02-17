//
//  MainViewController.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/10.
//

import UIKit

import RxSwift
import RxRelay

class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let content = MainView()
}

//MARK: - LifeCycle
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SwiftUIViewKit"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.content
            .build(to: self.view)
        
        self.bindObservers()
    }
}

//MARK: - Methods
extension MainViewController {
    private func bindObservers() {
        self.content
            .didTappedNavigateToSecondView
            .subscribe(onNext: {[unowned self] in
                let viewController = SecondViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        Observable.merge(
            RxKeyboardResponder.shared.willShow.asObservable().asOptional,
            RxKeyboardResponder.shared.willHide.map({ nil })
        )
        .subscribe(onNext: {[unowned self] keyboardRect in
            self.content.snp.updateConstraints {
                if let keyboardSize = keyboardRect?.size {
                    let inset = keyboardSize.height - UIEdgeInsets.safeAreaInsets.bottom
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(inset)
                } else {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
                }
            }
            self.view.layoutIfNeeded()
        })
        .disposed(by: self.disposeBag)
    }
}

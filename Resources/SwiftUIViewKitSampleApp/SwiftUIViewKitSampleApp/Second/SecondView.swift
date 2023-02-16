//
//  SecondView.swift
//  SwiftUIViewKitSampleApp
//
//  Created by LONELiE on 2023/02/16.
//

import UIKit

import SwiftUIViewKit
import RxSwift
import RxRelay

class SecondView: SwiftUIView {
    private let disposeBag = DisposeBag()
    
    private let viewModel = BehaviorRelay<SecondViewModel>(value: .init())
    
    private let selectedIdx = BehaviorRelay<Int?>(value: nil)
}

//MARK: - Make A View
extension SecondView {
    var body: UIView {
        self.mainTableView
    }
    
    private var mainTableView: UITableView {
        let tableView = UITableView()
        
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.00, bottom: 12.0, right: 0.0)
        tableView.tableHeaderView = self.mainTableHeaderView
        
        self.viewModel
            .map { $0.list }
            .distinctUntilChanged()
            .bind(to: tableView.rx.items) {(tableView: UITableView, index, element) in
                let cell = UITableViewCell()
                if #available(iOS 14.0, *) {
                    var content = cell.defaultContentConfiguration()
                    content.text = element
                    cell.contentConfiguration = content
                } else {
                    cell.textLabel?.text = element
                }
                cell.selectionStyle = .none
                return cell
            }
            .disposed(by: self.disposeBag)
            
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: self.selectedIdx)
            .disposed(by: self.disposeBag)
        
        self.selectedIdx
            .map { $0 == nil }
            .distinctUntilChanged()
            .map {_ in }
            .subscribe(onNext: {
                tableView.headerViewSizeToFit()
            })
            .disposed(by: self.disposeBag)
        
        tableView.setContentOffset(CGPoint(x: 0.0, y: -tableView.contentInset.top), animated: false)
        
        return tableView
    }
    
    private var mainTableHeaderView: UIView {
        UIStackView.vstack(
            UIImageView(named: "11213734")
                .contentMode(.scaleAspectFit)
                .priority(.required),
            UILabel(
                UILabel("Awesome!\n")
                    .font(.systemFont(ofSize: 20.0, weight: .bold))
                    .lineHeight(26.0)
                + UILabel("It's a TableHeaderView...")
                    .font(.systemFont(ofSize: 14.0, weight: .thin))
                    .lineHeight(20.0)
            )
            .alignment(.center)
            .lineLimit(0)
            .color(.darkGray),
            DottedDivider(),
            UILabel(
                Observable.combineLatest(
                    self.viewModel.map({ $0.list }),
                    self.selectedIdx.map({ $0 ?? 0 })
                )
                .map({ String(format: "Your selected: idx=%d, element=\"%@\"", $1, $0[$1]) }),
                by: self.disposeBag
            )
            .font(.systemFont(ofSize: 14.0, weight: .regular))
            .alignment(.center)
            .lineHeight(20.0)
            .hidden(self.selectedIdx.map({ $0 == nil }), by: self.disposeBag)
        )
        .spacing(8.0)
        .padding(.horizontal, 16.0)
    }
    
    private func button(text: String) -> UIView {
        UILabel(text)
            .font(.systemFont(ofSize: 16.0, weight: .semibold))
            .color(.white)
            .alignment(.center)
            .priority(.required)
            .padding(.horizontal, 20.0)
            .padding(.vertical, 8.0)
            .background(.darkGray)
            .corner(radius: 6.0)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct SecondView_Preview: PreviewProvider {
    static var previews: some View {
        SecondView.view
            .previewDevice("iPhone 12 mini")
    }
}
#endif

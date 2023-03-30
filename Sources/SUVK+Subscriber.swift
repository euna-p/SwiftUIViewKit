//
//  SUVK+Subscriber.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/03/30.
//

import UIKit

#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa

open class Subscriber: UIGroupView {
    public typealias Block = ()->[UIView]
    
    private let disposeBag: DisposeBag
    
    internal init(by disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
        super.init(frame: .zero)
    }
    
    public required init(coder: NSCoder) {
        self.disposeBag = DisposeBag()
        super.init(coder: coder)
    }
}

extension Subscriber {
    public convenience init<T>(_ observer: Observable<T>,
                               at when: SwiftUIView.SubscribeAt = .always,
                               by disposeBag: DisposeBag,
                               @ViewGroup onNext perform: @escaping ((T)->[UIView]),
                               file: String = #file, function: String = #function, lineNumber: Int = #line) {
        self.init(by: disposeBag)
        
        var observer = observer
        switch when {
        case .always:
            break
        case .skip(let count):
            observer = observer.skip(count)
        case .untilChanged:
            observer = observer.distinctUntilChanged {
                if let lhs = $0 as? (any Equatable), let rhs = $1 as? (any Equatable) {
                    return lhs.isEqual(rhs)
                } else {
                    if let style = Mirror(reflecting: $0).displayStyle {
                        switch style {
                        case .struct, .enum, .tuple, .optional, .collection, .dictionary:
                            return "\($0)" == "\($1)"
                        case .class, .set:
                            break
                        @unknown default:
                            break
                        }
                    }
                    let fileName = file.components(separatedBy: "/").last ?? file
                    let log = String(format: "[SwiftUIKit] ⚠️ WARNING (%@:%lld %@): %@",
                                     fileName, lineNumber, function,
                                     "An element is not `Equatable` on 'subscribe(_: at: by: onNext:)' "
                                     + "by 'SwiftUIViewKit.SubscribeAt.untilChanged'.")
                    print(log)
                    return false
                }
            }
        }
        
        observer
            .subscribe(onNext: {
                self.subviews.forEach { $0.removeFromSuperview() }
                perform($0).forEach { self.addArrangedSubview($0) }
            })
            .disposed(by: self.disposeBag)
    }
    
    public convenience init<T>(_ observer: BehaviorRelay<T>,
                               at when: SwiftUIView.SubscribeAt = .always,
                               by disposeBag: DisposeBag,
                               @ViewGroup onNext perform: @escaping ((T)->[UIView]),
                               file: String = #file, function: String = #function, lineNumber: Int = #line) {
        self.init(observer.asObservable(), at: when, by: disposeBag, onNext: perform,
                  file: file, function: function, lineNumber: lineNumber)
    }
}
#endif

extension Equatable {
    func isEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}

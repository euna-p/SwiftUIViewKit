//
//  SUVK+RxBase.swift
//  SwiftUIViewKit
//
//  Created by LONELiE on 2023/02/09.
//

import UIKit

#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    public var layoutSubviews: Observable<[Any]> {
        return sentMessage(#selector(UIView.layoutSubviews))
    }
}

extension Reactive where Base: UIScrollView {
    public var didEndScroll: ControlEvent<Void> {
        ControlEvent(
            events: Observable.merge(
                self.base.rx.didEndDragging.map({ !$0 }),
                self.base.rx.didEndDecelerating.map({ true })
            )
            .filter { $0 }
            .map {_ in }
        )
    }
    
    public var didScrollLast: ControlEvent<Void> {
        var isHLast: Bool { self.base.isScrolledHorizontalLast }
        var isVLast: Bool { self.base.isScrolledVerticalLast   }
        return ControlEvent(events: self.didEndScroll.filter({ isHLast && isVLast }).map({_ in }))
    }
}

extension Reactive where Base: UIViewController {
    public var viewDidLoad: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
      return ControlEvent(events: source)
    }

    public var viewWillAppear: ControlEvent<Bool> {
      let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
    }
    public var viewDidAppear: ControlEvent<Bool> {
      let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
    }

    public var viewWillDisappear: ControlEvent<Bool> {
      let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
    }
    public var viewDidDisappear: ControlEvent<Bool> {
      let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
    }

    public var viewWillLayoutSubviews: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
      return ControlEvent(events: source)
    }
    public var viewDidLayoutSubviews: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
      return ControlEvent(events: source)
    }

    public var willMoveToParentViewController: ControlEvent<UIViewController?> {
      let source = self.methodInvoked(#selector(Base.willMove)).map { $0.first as? UIViewController }
      return ControlEvent(events: source)
    }
    public var didMoveToParentViewController: ControlEvent<UIViewController?> {
      let source = self.methodInvoked(#selector(Base.didMove)).map { $0.first as? UIViewController }
      return ControlEvent(events: source)
    }

    public var didReceiveMemoryWarning: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.didReceiveMemoryWarning)).map { _ in }
      return ControlEvent(events: source)
    }
    
    public var isDismissing: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}

extension Observable {
    internal var asOptional: Observable<Optional<Element>> {
        return self.map({ $0 })
    }
}
#endif

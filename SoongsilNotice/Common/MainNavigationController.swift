//
//  MainNavigationController.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import UIKit

public class MainNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    public override func viewDidLoad() {
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

public protocol MainNavigationBarUpdatable {
    func refreshShadowLine(offset: CGFloat)
}

public extension MainNavigationBarUpdatable where Self: UIViewController {
    func refreshShadowLine(offset: CGFloat) {
        if let navigationBar = navigationController?.navigationBar as? MainUINavigationBar {
            navigationBar.barTintColor = .white
            navigationBar.tintColor = .blue
            
            if offset > 0 {
                navigationBar.setDefaultShadowImage()
            } else {
                navigationBar.removeDefaultShadowImage()
            }
        }
    }
}

//
//  UIViewController+Ext.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit

extension UIViewController {
    func embed(_ viewController: UIViewController) {
        viewController.willMove(toParent: self)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
}

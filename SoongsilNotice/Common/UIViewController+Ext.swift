//
//  UIViewController+Ext.swift
//  SoongsilNotice
//
//  Created by Gyuni on 2021/09/16.
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit

extension UIViewController {
    func embed(_ viewController: UIViewController, at view: UIView) {
        viewController.willMove(toParent: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
}

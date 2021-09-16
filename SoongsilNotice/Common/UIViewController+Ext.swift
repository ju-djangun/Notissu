//
//  UIViewController+Ext.swift
//  SoongsilNotice
//
//  Created by Gyuni on 2021/09/16.
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

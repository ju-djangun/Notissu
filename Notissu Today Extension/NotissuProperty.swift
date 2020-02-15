//
//  NotissuProperty.swift
//  Notissu Today Extension
//
//  Created by TaeinKim on 2020/02/15.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import UIKit

struct NotissuProperty {
    private static let shortcutImage: [String] = ["my_notice", "major_list", "tab_school", "more"]
    
    static func getImage(tag: Int) -> UIImage? {
        return (UIImage(named: self.shortcutImage[tag])?.withRenderingMode(.alwaysTemplate))
    }
    
    public static var openIndex: Int = 0
}

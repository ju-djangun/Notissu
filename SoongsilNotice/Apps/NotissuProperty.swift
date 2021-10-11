//
//  NotissuProperty.swift
//  SoongsilNotice
//
//  Created by denny on 2021/10/11.
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import UIKit

struct NotissuProperty {
    private static let shortcutImage: [String] = ["my_notice", "major_list", "tab_school", "more"]
    
    static var currentVersion: String = ""
    static var recentVersion: String = ""
    
    static var isUpdateRequired: Bool = false
    
    static func getImage(tag: Int) -> UIImage? {
        return (UIImage(named: self.shortcutImage[tag])?.withRenderingMode(.alwaysTemplate))
    }
    
    public static var openIndex: Int?
}

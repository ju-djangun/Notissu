//
//  UIImage+Ext.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    convenience init(color: UIColor?, size: CGSize = CGSize(width: UIScreen.main.scale, height: UIScreen.main.scale)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color?.setFill()
        UIRectFill(rect)
        if let image = UIGraphicsGetImageFromCurrentImageContext(), let cgImage = image.cgImage {
            UIGraphicsEndImageContext()
            self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        } else {
            self.init()
        }
    }
}

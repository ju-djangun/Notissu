//
//  BaseViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/07.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var loadingView   : UIView = UIView()
    var spinner       = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showActivityIndicator(uiView: UIView!) {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.style = .large
        uiView.addSubview(actInd)
        self.spinner.startAnimating()
    }
    
    func hideActivityIndicator(uiView: UIView) {
        self.spinner.stopAnimating()
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

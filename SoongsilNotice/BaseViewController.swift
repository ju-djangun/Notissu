//
//  BaseViewController.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import UIKit
import Lottie
import WatchConnectivity
import YDS

class BaseViewController: UIViewController, UIGestureRecognizerDelegate, ProgressBarDelegate {
    let animationView = AnimationView(name: "notissu_anim")
    
    static var noticeDeptCode: DeptCode?
    static var noticeMajor   : Major?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = YDSColor.bgNormal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func showAlert(title: String, msg: String, handler: ((UIAlertAction) -> Swift.Void)?) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let yesButton = UIAlertAction(title: "예", style: .default, handler: handler)
        alertController.addAction(yesButton)
        
        let noButton = UIAlertAction(title: "아니요", style:.destructive, handler: nil)
        alertController.addAction(noButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertOKWithHandler(title: String, msg: String, handler: ((UIAlertAction) -> Swift.Void)?) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "확인", style: .default, handler: handler)
        alertController.addAction(okButton)
        
        self.present(alertController, animated: true, completion: { print ("끝") })
    }
    
    func showAlertOK(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let yesButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(yesButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showProgressBar() {
        animationView.loopMode      = .loop
        self.view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        animationView.play()
    }
    
    func hideProgressBar() {
        animationView.stop()
        animationView.removeFromSuperview()
    }
    
    func setNavigationTitleLabelFont() {
        if let titleLabel = self.navigationItem.leftBarButtonItem?.customView as? UILabel {
            titleLabel.font = UIFont(name: "Avenir-Black", size: 22)
        }
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

protocol ProgressBarDelegate {
    func showProgressBar()
    func hideProgressBar()
}

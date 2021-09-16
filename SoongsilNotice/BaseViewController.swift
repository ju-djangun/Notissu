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

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    let animationView = AnimationView(name: "notissu_anim")
    
    static var noticeDeptCode: DeptCode?
    static var noticeMajor   : Major?
    weak var tabBarDelegate: MainTabBarDelegate?
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if let vc = self.navigationController?.topViewController {
//            return vc.preferredStatusBarStyle
//        } else {
//            return .lightContent
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.barStyle = .black
        self.view.backgroundColor = YDSColor.bgNormal
        self.checkUpdate()
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
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertOK(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let yesButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(yesButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkUpdate() {
        if self.isUpdateAvailable() {
            self.showAlertOKWithHandler(title: "업데이트가 필요합니다.", msg: "원활한 서비스 이용을 위해 업데이트가 필요합니다. '확인'을 누르면 스토어로 이동합니다.", handler: onClickUpdateApp(_:))
        }
    }
    
    @objc func onClickUpdateApp(_ action: UIAlertAction) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1488050194"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func isUpdateAvailable() -> Bool {
        guard
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=com.elliott.notissu-ios"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.count > 0,
            let appStoreVersion = results[0]["version"] as? String
            else { return false }
        
        print("🗣 Version Checking...")
        print("🗣 ...Current Version : \(version)")
        print("🗣 ...App Store Version : \(appStoreVersion)")
        
        NotissuProperty.currentVersion = version
        NotissuProperty.recentVersion = appStoreVersion
        
        if appStoreVersion.compare(version, options: .numeric) == .orderedDescending {
            NotissuProperty.isUpdateRequired = true
            return true
        } else {
            NotissuProperty.isUpdateRequired = false
            return false
        }
    }
    
    func showProgressBar() {
//        animationView.frame         =  view.bounds
//        animationView.contentMode   = .center
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

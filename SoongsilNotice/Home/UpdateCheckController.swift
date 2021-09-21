//
//  SplashViewController.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import UIKit

class UpdateCheckController: BaseViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlertOKWithHandler(title: "업데이트가 필요합니다.", msg: "원활한 서비스 이용을 위해 업데이트가 필요합니다. '확인'을 누르면 스토어로 이동합니다.", handler: onClickUpdateApp(_:))
    }
    
    @objc
    func onClickUpdateApp(_ action: UIAlertAction) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1488050194"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        HomeSwitcher.shared.updateRootVCAfterCheckingVersion()
    }
    
}

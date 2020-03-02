//
//  InterfaceController.swift
//  Notissu-Watch Extension
//
//  Created by TaeinKim on 2020/03/02.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, InterfaceViewProtocol {
    @IBOutlet var lblMyMajor: WKInterfaceLabel!
    let session = WCSession.default
    
    @IBAction func onClickSend() {
        let data: [String: Any] = ["watch": "data from watch" as Any]
        session.transferUserInfo(data)
        
        self.presenter.loadCachedConfigData()
    }
    
    private var presenter: InterfacePresenterProtocol!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.presenter = InterfacePresenter(view: self)
        self.presenter.loadCachedConfigData()
        
        session.delegate = self
        session.activate()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func setMajorTextToLabel(result: WatchError) {
        if result == .success {
            // Success
            self.lblMyMajor.setText("\(WatchConfig.myDeptName!.rawValue)")
        } else {
            // Failure
            self.lblMyMajor.setText("Load Failed")
        }
    }

}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            if let value = userInfo["myDeptName"] as? String, let code = userInfo["myDeptCode"] as? Int {
                self.lblMyMajor.setText("\(value)")
                self.presenter.saveCacheData(deptName: value, deptCode: code)
            }
        }
    }
}

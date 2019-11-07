//
//  NoticeAttachmentCell.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/07.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit
import Alamofire

class NoticeAttachmentCell: UITableViewCell {
    @IBOutlet var attachmentTitle: UILabel!
    @IBOutlet var btnDownload: UIButton!
    var fileDownloadURL = String()
    var viewController: UIViewController?
    
    @IBAction func onClickDownload(_ sender: Any) {
        showAlert(title: "파일 다운로드", msg: "파일을 다운로드하시겠습니까?", handler: doDownloadFile(_:))
    }
    
    func doDownloadFile(_ action: UIAlertAction) {
        print("download : \(fileDownloadURL)")
    }
    
    func showAlert(title: String, msg: String, handler: ((UIAlertAction) -> Swift.Void)?){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let yesButton = UIAlertAction(title: "예", style: .default, handler: handler)
        alertController.addAction(yesButton)
        
        let noButton = UIAlertAction(title: "아니요", style:.destructive, handler: nil)
        alertController.addAction(noButton)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
}

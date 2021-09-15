//
//  NoticeDetailViewModel.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import Alamofire

protocol NoticeDetailViewModelInput {
    func loadWebView()
}

protocol NoticeDetailViewModelOutput {
    var title: String? { get }
    var caption: String? { get }
}


class NewNoticeDetailViewModel: NoticeDetailViewModelInput, NoticeDetailViewModelOutput {
    
    //  MARK: - OUTPUT
    
    let title: String?
    let caption: String?
    
    //  MARK: - INPUT
    
    func loadWebView() {
        
    }
    
    //  MARK: - 그 외
    
    let notice: Notice
    
    init(notice: Notice) {
        self.notice = notice
        self.title = notice.title
        self.caption = notice.date
    }
    
    
}

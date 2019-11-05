//
//  Notice.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/05.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation

class Notice {
    var author : String?
    var title  : String?
    var url    : String?
    var date   : String?
    
    init(author: String, title: String, url: String, date: String) {
        self.author = author
        self.title  = title
        self.url    = url
        self.date   = date
    }
}

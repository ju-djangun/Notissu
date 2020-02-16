//
//  TodayModel.swift
//  Notissu Today Extension
//
//  Created by TaeinKim on 2020/02/16.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation

enum WidgetNoticeError: Error {
    case noDeptName
    case deptNameError
}

struct WidgetNoticeModel {
    var myDeptName: String
    var code: DeptCode
}

class TodayModel: TodayModelProtocol {
    var cachedNoticeList: [Notice]?
    
    var favoriteNoticeList: [Notice] = [Notice]()
    
    func appendFavoriteNotice(notice: Notice) {
        self.favoriteNoticeList.append(notice)
    }
    
    func removeAllFavoriteNotice() {
        self.favoriteNoticeList.removeAll()
    }
    
    func getFavoriteNoticeList() -> [Notice] {
        return self.favoriteNoticeList
    }
}

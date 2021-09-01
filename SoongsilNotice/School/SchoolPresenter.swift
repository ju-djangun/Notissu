//
//  SchoolPresenter.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

class SchoolPresenter : SchoolPresenterIf {
    private var view: SchoolView?
    
    init(view: SchoolView) {
        self.view = view
    }
    
    func parseSchoolNotice(page: Int, keyword: String?) {
        NoticeSoongsil.parseSchoolNotice(page: page, keyword: keyword, completion: self.view!.applyTableView)
    }
}

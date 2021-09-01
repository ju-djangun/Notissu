//
//  SchoolContract.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import Foundation

protocol SchoolView {
    func applyTableView(list: [Notice]) -> Void
}

protocol SchoolPresenterIf {
    func parseSchoolNotice(page: Int, keyword: String?)
}

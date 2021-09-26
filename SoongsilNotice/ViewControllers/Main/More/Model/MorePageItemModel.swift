//
//  MorePageItemModel.swift
//  SoongsilNotice
//
//  Created by Gyuni on 2021/09/25.
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

struct MorePageItemModel {
    let item: MorePageItem
    let title: String?
}

enum MorePageItem {
    case bookmark
    case opensource
    case developer
}

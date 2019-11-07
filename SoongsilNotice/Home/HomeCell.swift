//
//  HomeCell.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/07.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit

struct Major {
    var majorCode: DeptCode?
    var majorName: DeptName?
    var majorNameEng: DeptNameEng?
}

class HomeCell: UITableViewCell {
    @IBOutlet var majorTitle: UILabel!
    @IBOutlet var majorTitleEng: UILabel!
    var majorCode: DeptCode?
    var majorName: DeptName?
}

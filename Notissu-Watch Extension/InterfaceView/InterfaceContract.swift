//
//  InterfaceContract.swift
//  Notissu-Watch Extension
//
//  Created by TaeinKim on 2020/03/02.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import WatchKit

protocol InterfaceViewProtocol {
    func setMajorTextToLabel(result: WatchError)
}

protocol InterfacePresenterProtocol {
    func loadCachedConfigData()
    
    func saveCacheData(deptName: String, deptCode: Int)
}

protocol InterfaceModelProtocol {
    
}

//
//  MajorListViewModel.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

final class MajorListViewModel {
    var majorSectionList: Dynamic<[MajorSection]>
    
    init() {
        majorSectionList = Dynamic<[MajorSection]>([.general, .it, .law, .inmun,
                                                    .engineering, .science, .business, .financial,
                                                    .social, .convergence])
    }
}

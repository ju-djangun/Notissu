//
//  MajorSection.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

enum MajorSection {
    case general
    case it
    case law
    case inmun
    case engineering
    case science
    case business
    case financial
    case social
    case convergence
    
    func getMajorList() -> [Major] {
        switch self {
        case .general:
            return MajorModel.majorListSoongsil
        case .it:
            return MajorModel.majorListIT
        case .law:
            return MajorModel.majorListLaw
        case .inmun:
            return MajorModel.majorListInmun
        case .engineering:
            return MajorModel.majorListEngineer
        case .science:
            return MajorModel.majorListNatural
        case .business:
            return MajorModel.majorListBusiness
        case .financial:
            return MajorModel.majorListEconomy
        case .social:
            return MajorModel.majorListSocial
        case .convergence:
            return [MajorModel.majorConvergence]
        }
    }
}

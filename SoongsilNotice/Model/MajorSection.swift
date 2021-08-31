//
//  MajorSection.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

enum MajorSection: Int {
    case general = 0
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
    
    static func getAllMajorCount() -> Int {
        var totalCount = 0
        totalCount += MajorModel.majorListSoongsil.count
        totalCount += MajorModel.majorListIT.count
        totalCount += MajorModel.majorListLaw.count
        totalCount += MajorModel.majorListInmun.count
        totalCount += MajorModel.majorListEngineer.count
        totalCount += MajorModel.majorListNatural.count
        totalCount += MajorModel.majorListBusiness.count
        totalCount += MajorModel.majorListEconomy.count
        totalCount += MajorModel.majorListSocial.count
        totalCount += 1
        
        return totalCount
    }
    
    func getSectionTitle() -> String {
        switch self {
        case .general:
            return "학교 생활"
        case .it:
            return "IT 대학"
        case .law:
            return "법과대학"
        case .inmun:
            return "인문대학"
        case .engineering:
            return "공과대학"
        case .science:
            return "자연과학대학"
        case .business:
            return "경영대학"
        case .financial:
            return "경제통상대학"
        case .social:
            return "사회과학대학"
        case .convergence:
            return "융합특성화자유전공학부"
        }
    }
}

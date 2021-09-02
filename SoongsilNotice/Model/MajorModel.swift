//
//  MajorModel.swift
//  Notissu
//
//  Copyright © 2020 Notissu. All rights reserved.
//

import Foundation

struct MajorModel {
    // 학교 부대 시설
    static var majorCodeListSoongsil    = [DeptCode.Dormitory]
    
    // IT대학
    static var majorCodeListIT = [DeptCode.IT_Computer, DeptCode.IT_Media, DeptCode.IT_Electric, DeptCode.IT_Software, DeptCode.IT_SmartSystem]
    
    // 법과대학
    static var majorCodeListLaw = [DeptCode.LAW_Law, DeptCode.LAW_IntlLaw]
    
    // 인문대학
    static var majorCodeListInmun = [DeptCode.Inmun_Korean, DeptCode.Inmun_French, DeptCode.Inmun_German, DeptCode.Inmun_Chinese, DeptCode.Inmun_English, DeptCode.Inmun_History, DeptCode.Inmun_Philosophy, DeptCode.Inmun_Japanese, DeptCode.Inmun_Writing]
//    , DeptCode.Inmun_Film
    
    // 공과대학
    static var majorCodeListEngineer = [DeptCode.Engineering_Chemistry, DeptCode.Engineering_Machine, DeptCode.Engineering_Electonic, DeptCode.Engineering_Industrial, DeptCode.Engineering_Organic, DeptCode.Engineering_Architect]
    
    // 자연과학대학
    static var majorCodeListNaturalScience = [DeptCode.NaturalScience_Math, DeptCode.NaturalScience_Physics, DeptCode.NaturalScience_Chemistry, DeptCode.NaturalScience_Actuarial, DeptCode.NaturalScience_Medical]
    
    // 경영대학 4
    static var majorCodeListBusiness = [DeptCode.Business_biz, DeptCode.Business_venture, DeptCode.Business_Account, DeptCode.Business_Finance]
    
    // 경제통상대학 2
    static var majorCodeListEconomy = [DeptCode.Economy_Economics, DeptCode.Economy_GlobalCommerce]
    
    // 사회과학대학 6
    static var majorCodeListSocial = [DeptCode.Social_Welfare, DeptCode.Social_Administration, DeptCode.Social_Sociology, DeptCode.Social_Journalism, DeptCode.Social_LifeLong, DeptCode.Social_Political]
    
    static var majorConvergence = Major(majorCode: DeptCode.MIX_mix)
    
    static var majorListSoongsil = [Major]()
    static var majorListIT       = [Major]()
    static var majorListLaw      = [Major]()
    static var majorListInmun    = [Major]()
    static var majorListEngineer = [Major]()
    static var majorListNatural  = [Major]()
    static var majorListBusiness = [Major]()
    static var majorListEconomy  = [Major]()
    static var majorListSocial   = [Major]()
    
    static func initializeMajor() {
        for index in 0..<majorCodeListSoongsil.count {
            majorListSoongsil.append(Major(majorCode: majorCodeListSoongsil[index]))
        }
        
        for index in 0..<majorCodeListIT.count {
            majorListIT.append(Major(majorCode: majorCodeListIT[index]))
        }
        
        for index in 0..<majorCodeListLaw.count {
            majorListLaw.append(Major(majorCode: majorCodeListLaw[index]))
        }
        
        for index in 0..<majorCodeListInmun.count {
            majorListInmun.append(Major(majorCode: majorCodeListInmun[index]))
        }
        
        for index in 0..<majorCodeListEngineer.count {
            majorListEngineer.append(Major(majorCode: majorCodeListEngineer[index]))
        }
        
        for index in 0..<majorCodeListNaturalScience.count {
            majorListNatural.append(Major(majorCode: majorCodeListNaturalScience[index]))
        }
        
        for index in 0..<majorCodeListBusiness.count {
            majorListBusiness.append(Major(majorCode: majorCodeListBusiness[index]))
        }
        
        for index in 0..<majorCodeListEconomy.count {
            majorListEconomy.append(Major(majorCode: majorCodeListEconomy[index]))
        }
        
        for index in 0..<majorCodeListSocial.count {
            majorListSocial.append(Major(majorCode: majorCodeListSocial[index]))
        }
    }
}

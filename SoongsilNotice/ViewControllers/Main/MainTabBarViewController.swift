//
//  MainTabBarViewController.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import YDS

public class MainTabBarViewController: YDSBottomBarController {
    
    private let isRecentVersion: Bool
    
    private let myNoticeNavigationController: YDSNavigationController
    private let majorListNavigationController: YDSNavigationController
    private let ssuCatchNavigationController: YDSNavigationController
    private let morePageNavigationController: YDSNavigationController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([
            myNoticeNavigationController,
            majorListNavigationController,
            ssuCatchNavigationController,
            morePageNavigationController
        ], animated: true)
        
        setNavigationControllerProperties()
    }
    
    private func setNavigationControllerProperties() {
        self.viewControllers?.forEach {
            $0.view.backgroundColor = YDSColor.bgNormal
        }
    }
    
    init(isRecentVersion: Bool) {
        self.isRecentVersion = isRecentVersion
        
        myNoticeNavigationController = {
            let deptCode = BaseNoticesListViewController.noticeDeptCode ?? .Soongsil
            let rootViewController = NoticesListViewController(with: NoticesListViewModel(deptCode: deptCode))
            let navigationController = YDSNavigationController(title: deptCode.getName(),
                                                               rootViewController: rootViewController)
            navigationController.tabBarItem = UITabBarItem(title: "내 공지",
                                                           image: YDSIcon.homeLine,
                                                           selectedImage: YDSIcon.homeFilled)
            return navigationController
        }()
        
        majorListNavigationController = {
            let rootViewController = MajorListViewController(viewModel: MajorListViewModel())
            let navigationController = YDSNavigationController(title: "전공 목록",
                                                               rootViewController: rootViewController)
            navigationController.tabBarItem = UITabBarItem(title: "전공 목록",
                                                           image: YDSIcon.listLine,
                                                           selectedImage: YDSIcon.listLine)
            return navigationController
        }()
        
        ssuCatchNavigationController = {
            let rootViewController = NoticesListViewController(with: NoticesListViewModel(deptCode: .Soongsil))
            let navigationController = YDSNavigationController(title: "SSU:Catch",
                                                               rootViewController: rootViewController)
            navigationController.tabBarItem = UITabBarItem(title: "학교 공지",
                                                           image: YDSIcon.noticeLine,
                                                           selectedImage: YDSIcon.noticeFilled)
            return navigationController
        }()
        
        morePageNavigationController = {
            let deptCode = BaseNoticesListViewController.noticeDeptCode ?? .Soongsil
            let rootViewController = MorePageViewController(with: MorePageViewModel(deptCode: deptCode, isRecentVersion: isRecentVersion))
            let navigationController = YDSNavigationController(title: "더 보기",
                                                               rootViewController: rootViewController)
            navigationController.tabBarItem = UITabBarItem(title: "더 보기",
                                                           image: YDSIcon.plusLine,
                                                           selectedImage: YDSIcon.plusLine)
            return navigationController
        }()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

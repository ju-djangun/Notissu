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
    private let myNoticeNavigationController: YDSNavigationController = {
        let deptCode = BaseNoticesListViewController.noticeDeptCode ?? .Soongsil
        let rootViewController = NoticesListViewController(with: NoticesListViewModel(deptCode: deptCode))
        let navigationController = YDSNavigationController(title: deptCode.getName(),
                                                           rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: "내 공지",
                                                       image: YDSIcon.homeLine,
                                                       selectedImage: YDSIcon.homeFilled)
        return navigationController
    }()
    
    private let majorListNavigationController: YDSNavigationController = {
        let rootViewController = MajorListViewController(viewModel: MajorListViewModel())
        let navigationController = YDSNavigationController(title: "전공 목록",
                                                           rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: "전공 목록",
                                                       image: YDSIcon.listLine,
                                                       selectedImage: YDSIcon.listLine)
        return navigationController
    }()
    
    private let ssuCatchNavigationController: YDSNavigationController = {
        let rootViewController = NoticesListViewController(with: NoticesListViewModel(deptCode: .Soongsil))
        let navigationController = YDSNavigationController(title: "SSU:Catch",
                                                           rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: "학교 공지",
                                                       image: YDSIcon.noticeLine,
                                                       selectedImage: YDSIcon.noticeFilled)
        return navigationController
    }()
    
    private let noticeSearchNavigationController: YDSNavigationController = {
        let rootViewController = NoticeSearchViewController(viewModel: NoticeSearchViewModel())
        let navigationController = YDSNavigationController(title: "검색",
                                                           rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: "검색",
                                                       image: YDSIcon.searchLine,
                                                       selectedImage: YDSIcon.searchLine)
        return navigationController
    }()
    
    private let aboutNavigationController: YDSNavigationController = {
        let deptCode = BaseNoticesListViewController.noticeDeptCode ?? .Soongsil
        let rootViewController = MorePageViewController(with: MorePageViewModel(deptCode: deptCode, isRecentVersion: true))
        let navigationController = YDSNavigationController(title: "더 보기",
                                                           rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: "더 보기",
                                                       image: YDSIcon.plusLine,
                                                       selectedImage: YDSIcon.plusLine)
        return navigationController
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([
            myNoticeNavigationController,
            majorListNavigationController,
            ssuCatchNavigationController,
            noticeSearchNavigationController,
            aboutNavigationController
        ], animated: true)
        
        setNavigationControllerProperties()
    }
    
    private func setNavigationControllerProperties() {
        self.viewControllers?.forEach {
            $0.view.backgroundColor = YDSColor.bgNormal
        }
    }
}

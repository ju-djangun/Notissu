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

protocol MainTabBarDelegate: AnyObject {
    func hideTabBar()
    func showTabBar()
}

public class MainTabBarViewController: YDSBottomBarController, UITabBarControllerDelegate {
    private var tabViewControllers: [UIViewController] = [UIViewController]()
    
    let myNoticeNavigationController: YDSNavigationController = {
        let rootViewController = NoticesListViewController(with: NoticesListViewModel(deptCode: .IT_Computer))
        let navigationController = YDSNavigationController(title: "내 공지",
                                                           rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: "내 공지",
                                                       image: YDSIcon.homeLine,
                                                       selectedImage: YDSIcon.homeFilled)
        return navigationController
    }()
    
    let majorListNavigationController: YDSNavigationController = {
        let rootViewController = MajorListViewController(viewModel: MajorListViewModel())
        let navigationController = YDSNavigationController(title: "전공 목록",
                                                           rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: "전공 목록",
                                                       image: YDSIcon.listLine,
                                                       selectedImage: YDSIcon.listLine)
        return navigationController
    }()
    
    let ssuCatchNavigationController: YDSNavigationController = {
        let rootViewController = NoticesListViewController(with: NoticesListViewModel(deptCode: .Soongsil))
        let navigationController = YDSNavigationController(title: "SSU:Catch",
                                                           rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: "학교 공지",
                                                       image: YDSIcon.noticeLine,
                                                       selectedImage: YDSIcon.noticeFilled)
        return navigationController
    }()
    
    let noticeSearchNavigationController: YDSNavigationController = {
        let rootViewController = NoticeSearchViewController(viewModel: NoticeSearchViewModel())
        let navigationController = YDSNavigationController(title: "검색",
                                                           rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: "검색",
                                                       image: YDSIcon.searchLine,
                                                       selectedImage: YDSIcon.searchLine)
        return navigationController
    }()
    
    let aboutNavigationController: YDSNavigationController = {
        //  moreNavigationController 로 이름을 짓고 싶었는데 이미 UITabBarController에서 사용중인 속성이더라고요...
        //  새 이름 추천해주세요
        let rootViewController = UIViewController()
        let navigationController = YDSNavigationController(title: "더 보기",
                                                           rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: "더 보기",
                                                       image: YDSIcon.plusLine,
                                                       selectedImage: YDSIcon.plusLine)
        return navigationController
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
//        delegate = self

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

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

//    public func tabBarController(_: UITabBarController, didSelect _: UIViewController) {
//        print("tabBarController didSelect update Navigation Title")
//    }
    
}

extension MainTabBarViewController: MainNavigationBarUpdatable { }

extension MainTabBarViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshShadowLine(offset: scrollView.contentOffset.y)
    }
}

//extension MainTabBarViewController: MainTabBarViewDelegate {
//    public func tabBarItem(at index: Int) {
//        tabChanged(tapped: index)
//    }
//}

extension MainTabBarViewController: MainTabBarDelegate {
    func hideTabBar() {
        self.tabBar.isHidden = true
    }
    
    func showTabBar() {
        self.tabBar.isHidden = false
    }
}

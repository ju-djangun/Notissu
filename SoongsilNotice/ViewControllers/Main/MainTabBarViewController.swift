//
//  MainTabBarViewController.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

protocol MainTabBarDelegate: AnyObject {
    func hideTabBar()
    func showTabBar()
}

public class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    private var tabViewControllers: [UIViewController] = [UIViewController]()
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        navigationController?.isNavigationBarHidden = true
        setupTabBarItems()
    }

    private func setupTabBarItems() {
        let myNoticeVC = MyNoticeViewController(viewModel: MyNoticeViewModel())
        let majorListVC = MajorListViewController(viewModel: MajorListViewModel())
        let ssuCatchVC = SSUCatchViewController(viewModel: SSUCatchViewModel())
        let noticeSearchVC = NoticeSearchViewController(viewModel: NoticeSearchViewModel())
        
        let myNoticeNC = createNavController(for: myNoticeVC,
                                         normalImage: UIImage(named: "tab_home_un.png"),
                                         selectedImage: UIImage(named: "tab_home.png"))
        
        let majorListNC = createNavController(for: majorListVC,
                                         normalImage: UIImage(named: "tab_home_un.png"),
                                         selectedImage: UIImage(named: "tab_home.png"))
        
        let ssuCatchNC = createNavController(for: ssuCatchVC,
                                         normalImage: UIImage(named: "tab_home_un.png"),
                                         selectedImage: UIImage(named: "tab_home.png"))
        
        let noticeSearchNC = createNavController(for: noticeSearchVC,
                                         normalImage: UIImage(named: "tab_home_un.png"),
                                         selectedImage: UIImage(named: "tab_home.png"))
        
        tabViewControllers.removeAll()
        tabViewControllers.append(myNoticeNC)
        tabViewControllers.append(majorListNC)
        tabViewControllers.append(ssuCatchNC)
        tabViewControllers.append(noticeSearchNC)
        
        tabBar.barTintColor = .black
        tabBar.tintColor = .gray

        viewControllers = tabViewControllers
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    public func tabBarController(_: UITabBarController, didSelect _: UIViewController) {
        print("tabBarController didSelect update Navigation Title")
    }
    
    fileprivate func createNavController(for rootViewController: BaseViewController,
                                         normalImage: UIImage?,
                                         selectedImage: UIImage?) -> UIViewController {
        rootViewController.tabBarDelegate = self
        let navController = MainNavigationController(navigationBarClass: MainUINavigationBar.self, toolbarClass: nil)
        navController.tabBarItem = UITabBarItem(title: "", image: normalImage, selectedImage: selectedImage)
        navController.viewControllers = [rootViewController]
        return navController
    }
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

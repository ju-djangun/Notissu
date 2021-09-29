//
//  MorePageViewController.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import UIKit
import SafariServices
import YDS

class MorePageViewController : BaseViewController {
    
    private let myMajorView: MyMajorView
    private let versionView: VersionView
    private let viewModel: MorePageViewModelProtocol
    private let itemsListTableViewController: MorePageItemsListTableViewController
    
    init(with viewModel: MorePageViewModelProtocol) {
        self.viewModel = viewModel
        self.itemsListTableViewController = MorePageItemsListTableViewController(with: viewModel)
        self.myMajorView = MyMajorView(with: viewModel)
        self.versionView = VersionView(with: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupViewLayout()
        bindViewModel()
//        NotificationCenter.default.addObserver(self, selector: #selector(onLoadFromWidget),
//                                               name: NSNotification.Name("widget"),
//                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkURLScheme()
    }
    
    private func setupViewLayout() {
        self.embed(itemsListTableViewController)
        
        view.addSubview(itemsListTableViewController.view)
        itemsListTableViewController.tableView.tableHeaderView = myMajorView
        itemsListTableViewController.tableView.tableFooterView = versionView
        itemsListTableViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    private func bindViewModel() {
        viewModel.pushViewController.bind { [weak self] viewController in
            guard let `self` = self else { return }
            if let viewController = viewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @objc func onLoadFromWidget() {
        self.checkURLScheme()
    }
    
    private func checkURLScheme() {
        if let index = NotissuProperty.openIndex {
            if index != self.tabBarController?.selectedIndex {
                self.tabBarController?.selectedIndex = index
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch(indexPath.row) {
//        case 0:
//            let storyBoard = self.storyboard!
//            let bookmarkController = storyBoard.instantiateViewController(withIdentifier: "bookmarkVC") as? BookmarkViewController
//            self.navigationController?.pushViewController(bookmarkController!, animated: true)
//        case 1:
//            let storyBoard = self.storyboard!
//            let noticeDetailController = storyBoard.instantiateViewController(withIdentifier: "OpenSourceVC") as? OpenSourceViewController
//            self.navigationController?.pushViewController(noticeDetailController!, animated: true)
//        case 2:
//            showAlert(title: "개발자 정보", msg: "숭실대학교 컴퓨터학부\n14학번 김태인\nContributor : 김봉균\n\n메일 전송을 위해 메일 앱을 실행합니다.", handler: onClickMailButton(_:))
//        case 3:
//            showAlert(title: "개발자 GitHub", msg: "개발자의 GitHub 사이트에 접속합니다.", handler: onClickDevelopGitHub(_:))
//        default: break
//        }
        viewModel.itemDidTap(at: indexPath)
    }
    
//    @objc func onClickDevelopGitHub(_ action: UIAlertAction) {
//        let viewController = SFSafariViewController(url: URL(string: "https://github.com/della-padula")!)
//        self.present(viewController, animated: true, completion: nil)
//    }
//
//    @objc func onClickMailButton(_ action: UIAlertAction) {
//        let email = "della.kimko@gmail.com"
//        if let url = URL(string: "mailto:\(email)") {
//            UIApplication.shared.open(url)
//        }
//    }
//
//    @objc func onClickRecommendApp(_ action: UIAlertAction) {
//        if let url = URL(string: "itms-apps://apps.apple.com/kr/app/%EA%B7%B8%EB%9D%BC%EC%9A%B4%EB%93%9C/id1483838254") {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
}

//  MARK: - Header, Footer View Height Setting
extension MorePageViewController {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let tableView = itemsListTableViewController.tableView
        
        if let header = tableView?.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            header.frame.size.height = newSize.height
        }
        
        if let footer = tableView?.tableFooterView {
            let newSize = footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            footer.frame.size.height = newSize.height
        }
    }
}

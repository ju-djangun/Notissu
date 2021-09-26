//
//  MorePageViewController.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import UIKit
import SafariServices
import YDS

class MorePageViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {
        
    private let myMajorView: MyMajorView
    
    private let moreTableView: UITableView = UITableView()
        
    private let viewModel: MorePageViewModelProtocol
    
    init(with viewModel: MorePageViewModelProtocol) {
        self.viewModel = viewModel
        myMajorView = MyMajorView(with: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupViewLayout()
        bindViewModel()
        
        moreTableView.delegate = self
        moreTableView.dataSource = self
        moreTableView.register(MoreTableCell.self, forCellReuseIdentifier: MoreTableCell.identifier)
        moreTableView.separatorInset  = .zero
        moreTableView.tableFooterView = UIView(frame: .zero)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(onLoadFromWidget),
//                                               name: NSNotification.Name("widget"),
//                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkURLScheme()
    }
    
    private func setupViewLayout() {
        view.addSubview(myMajorView)
        view.addSubview(moreTableView)
        
        myMajorView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        moreTableView.snp.makeConstraints { make in
            make.top.equalTo(myMajorView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
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
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MoreTableCell.identifier, for: indexPath) as? MoreTableCell {
            cell.content = viewModel.itemsList[indexPath.row].title
            cell.selectionStyle  = .none
            return cell
        }
        
        return UITableViewCell()
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

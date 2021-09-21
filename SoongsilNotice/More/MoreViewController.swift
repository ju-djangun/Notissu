//
//  MoreViewController.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import UIKit
import SafariServices
import YDS

class MoreViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {
    let moreMenu = ["북마크", "오픈소스 사용 정보", "개발자 정보", "개발자 GitHub 방문하기"]
    
    private let profileContainerView: UIView = UIView()
    
    private let myMajorContainerView: UIView = UIView()
    private let myMajorTitleLabel: UILabel = UILabel()
    private let myMajorLabel: UILabel = UILabel()
    private let profileImageView: UIImageView = UIImageView()
    private let modifyMajorButton: UIButton = UIButton()
    
    private let versionContainerView: UIView = UIView()
    private let moreTableView: UITableView = UITableView()
    
    private let versionView = VersionInfoView.viewFromNib()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupViewLayout()
        
        moreTableView.delegate = self
        moreTableView.dataSource = self
        moreTableView.register(MoreTableCell.self, forCellReuseIdentifier: MoreTableCell.identifier)
        moreTableView.separatorInset  = .zero
        moreTableView.tableFooterView = UIView(frame: .zero)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLoadFromWidget),
                                               name: NSNotification.Name("widget"),
                                               object: nil)
        
        modifyMajorButton.layer.borderColor = YDSColor.buttonPoint.cgColor
        modifyMajorButton.layer.borderWidth = 1
        
        modifyMajorButton.layer.masksToBounds = true
        modifyMajorButton.layer.cornerRadius = 6
        
        modifyMajorButton.addTarget(self, action: #selector(onClickModifyProfile(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.myMajorLabel.text = BaseViewController.noticeDeptCode?.getName() ?? ""
        
        self.checkURLScheme()
    }
    
    private func setupViewLayout() {
        view.addSubview(profileContainerView)
        view.addSubview(versionContainerView)
        view.addSubview(moreTableView)
        
        profileContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(64)
        }
        
        versionContainerView.snp.makeConstraints { make in
            make.top.equalTo(profileContainerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(64)
        }
        
        moreTableView.snp.makeConstraints { make in
            make.top.equalTo(versionContainerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        profileContainerView.addSubview(profileImageView)
        profileContainerView.addSubview(myMajorContainerView)
        myMajorContainerView.addSubview(myMajorTitleLabel)
        myMajorContainerView.addSubview(myMajorLabel)
        profileContainerView.addSubview(modifyMajorButton)
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        modifyMajorButton.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(32)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        myMajorContainerView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.trailing.equalTo(modifyMajorButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        myMajorTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        myMajorLabel.snp.makeConstraints { make in
            make.top.equalTo(myMajorTitleLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        profileImageView.image = UIImage(named: "person_png")?.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = YDSColor.buttonPoint
        
        myMajorTitleLabel.font = UIFont(name: "NotoSansKR-Light", size: 13)
        myMajorTitleLabel.textColor = YDSColor.textTertiary
        myMajorTitleLabel.text = "나의 전공"
        
        myMajorLabel.font = UIFont(name: "NotoSansKR-Bold", size: 20)
        myMajorLabel.textColor = YDSColor.textPointed
        
        modifyMajorButton.setTitle("전공 변경", for: .normal)
        modifyMajorButton.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 13)
        modifyMajorButton.setTitleColor(YDSColor.buttonPoint, for: .normal)
        
        versionView.version = Version(currentVersion: NotissuProperty.currentVersion, recentVersion: NotissuProperty.recentVersion, isUpdateRequired: NotissuProperty.isUpdateRequired)
        
        versionContainerView.addSubview(versionView)
        versionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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
    
    @objc
    private func onClickModifyProfile(_ sender: Any) {
        let modifyVC = ModifyProfileViewController()
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MoreTableCell.identifier, for: indexPath) as? MoreTableCell {
        cell.content = moreMenu[indexPath.row]
        cell.selectionStyle  = .none
        return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row) {
        case 0:
            let storyBoard = self.storyboard!
            let bookmarkController = storyBoard.instantiateViewController(withIdentifier: "bookmarkVC") as? BookmarkViewController
            self.navigationController?.pushViewController(bookmarkController!, animated: true)
        case 1:
            let storyBoard = self.storyboard!
            let noticeDetailController = storyBoard.instantiateViewController(withIdentifier: "OpenSourceVC") as? OpenSourceViewController
            self.navigationController?.pushViewController(noticeDetailController!, animated: true)
        case 2:
            showAlert(title: "개발자 정보", msg: "숭실대학교 컴퓨터학부\n14학번 김태인\nContributor : 김봉균\n\n메일 전송을 위해 메일 앱을 실행합니다.", handler: onClickMailButton(_:))
        case 3:
            showAlert(title: "개발자 GitHub", msg: "개발자의 GitHub 사이트에 접속합니다.", handler: onClickDevelopGitHub(_:))
        default: break
        }
        
    }
    
    @objc func onClickDevelopGitHub(_ action: UIAlertAction) {
        let viewController = SFSafariViewController(url: URL(string: "https://github.com/della-padula")!)
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc func onClickMailButton(_ action: UIAlertAction) {
        let email = "della.kimko@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func onClickRecommendApp(_ action: UIAlertAction) {
        if let url = URL(string: "itms-apps://apps.apple.com/kr/app/%EA%B7%B8%EB%9D%BC%EC%9A%B4%EB%93%9C/id1483838254") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

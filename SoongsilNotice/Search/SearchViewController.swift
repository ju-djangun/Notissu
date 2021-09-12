//
//  SearchViewController.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class SearchViewController: BaseViewController, SearchViewProtocol, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var majorSelectLabel: UILabel = {
        $0.text = "전공을 선택해주세요."
        $0.textColor = YDSColor.buttonNormal
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return $0
    }(UILabel())
    
    private var searchTitleLabel: UILabel = {
        $0.text = "검색어 입력"
        $0.textColor = YDSColor.buttonNormal
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return $0
    }(UILabel())
    
    private var lblSelectedMajor  : UILabel = {
        $0.text = "선택한 전공 : 전공을 선택해주세요."
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return $0
    }(UILabel())
    
    private var searchBtn: YDSBoxButton = {
        $0.text = "검색하기"
        $0.addTarget(self, action: #selector(searchAction(_:)), for: .touchUpInside)
        return $0
    }(YDSBoxButton())
    
    private var majorSelectionBtn: YDSBoxButton = {
        $0.text = "전공 선택"
        $0.addTarget(self, action: #selector(selectMajorAction(_:)), for: .touchUpInside)
        return $0
    }(YDSBoxButton())
    
    private var keywordTextField: YDSSimpleTextFieldView = {
        $0.placeholder = "검색어를 입력해주세요."
        return $0
    }(YDSSimpleTextFieldView())
    
    private var presenter: SearchPresenter!
    
    private var selectedIndex = -1
    private var selectedMajor: DeptCode = .IT_Computer
    
    private func setupViewLayout() {
        view.addSubview(majorSelectLabel)
        view.addSubview(majorSelectionBtn)
        view.addSubview(searchTitleLabel)
        view.addSubview(keywordTextField)
        view.addSubview(lblSelectedMajor)
        view.addSubview(searchBtn)
        
        majorSelectLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        majorSelectionBtn.snp.makeConstraints { make in
            make.top.equalTo(majorSelectLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        searchTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(majorSelectionBtn.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        keywordTextField.snp.makeConstraints { make in
            make.top.equalTo(searchTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        lblSelectedMajor.snp.makeConstraints { make in
            make.top.equalTo(keywordTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SearchPresenter(view: self)
        
        setupViewLayout()
        
        keywordTextField.layer.borderWidth = 0.5
        keywordTextField.layer.borderColor = NotiSSU_ColorSet.notissuGrayLight.cgColor
        
        lblSelectedMajor.textColor = NotiSSU_ColorSet.notissuGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Appear")
        self.navigationItem.title = "검색"
        self.navigationController?.navigationBar.topItem?.title = "검색"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc
    private func searchAction(_ sender: Any?) {
        print("검색 : \(String(describing: self.keywordTextField.text))")
        
        if selectedIndex < 0 {
            let alert = UIAlertController(title: "전공을 선택해주세요", message: "", preferredStyle: .alert)
            alert.isModalInPopover = true
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert,animated: true, completion: nil )
        } else if (self.keywordTextField.text ?? "").isEmpty {
            let alert = UIAlertController(title: "검색어를 입력해주세요", message: "", preferredStyle: .alert)
            alert.isModalInPopover = true
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert,animated: true, completion: nil )
        } else {
            
            let storyBoard = self.storyboard!
            let noticeListViewController = storyBoard.instantiateViewController(withIdentifier: "noticeListVC") as? NoticeListViewController
            
            noticeListViewController?.department = Major(majorCode: self.presenter.getMajorListItem(at: selectedIndex))
            
            noticeListViewController?.isSearchResult = true
            noticeListViewController?.listType = .normalList
            noticeListViewController?.searchKeyword = self.keywordTextField.text
            
            self.navigationController?.pushViewController(noticeListViewController!, animated: true)
        }
    }
    
    @objc
    private func selectMajorAction(_ sender: Any?) {
        showPickerActionSheet()
    }
    
    func showPickerActionSheet() {
        let alert: UIAlertController?
        let pickerFrame: UIPickerView?
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert = UIAlertController(title: "전공을 선택하세요.", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            alert!.isModalInPopover = true
            pickerFrame = UIPickerView(frame: CGRect(x: 0, y: 40, width: 270, height: 150))
        } else {
            alert = UIAlertController(title: "전공을 선택하세요.", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
            alert!.isModalInPopover = true
            let width = alert!.view.frame.width
            pickerFrame = UIPickerView(frame: CGRect(x: 0, y: 40, width: width - 16, height: 150))
        }
        
        alert!.view.addSubview(pickerFrame!)
        pickerFrame!.dataSource = self
        pickerFrame!.delegate = self
        
        if self.selectedIndex < 0 {
            self.selectedIndex = 0
        }
        
        pickerFrame!.selectRow(selectedIndex, inComponent: 0, animated: true)
        
        alert!.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert!.addAction(UIAlertAction(title: "확인", style: .default, handler: { (UIAlertAction) in
            self.lblSelectedMajor.text = "선택한 전공 : \(self.selectedMajor.getName())"
            
        }))
        self.present(alert!, animated: true, completion: nil)
    }
    
}

extension SearchViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.presenter.getMajorListCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.presenter.getMajorListItem(at: row).getName()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(row) : \(self.presenter.getMajorListItem(at: row))")
        selectedIndex = row
        selectedMajor = self.presenter.getMajorListItem(at: row)
    }
}

//
//  SearchViewController.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class NoticeSearchViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var majorSelectLabel: UILabel = {
        $0.text = "전공을 선택해주세요."
        $0.textColor = YDSColor.buttonPoint
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return $0
    }(UILabel())
    
    private var searchTitleLabel: UILabel = {
        $0.text = "검색어 입력"
        $0.textColor = YDSColor.buttonPoint
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
    
    private var selectedIndex = -1
    private var selectedMajor: DeptCode = .IT_Computer
    
    private let viewModel: NoticeSearchViewModel!
    
    init(viewModel: NoticeSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        setupViewLayout()
        
        lblSelectedMajor.textColor = NotiSSU_ColorSet.notissuGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc
    private func searchAction(_ sender: Any?) {
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
            
            noticeListViewController?.department = Major(majorCode: self.viewModel.majorList.value[selectedIndex])
            
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

extension NoticeSearchViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.majorList.value.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.majorList.value[row].getName()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
        selectedMajor = viewModel.majorList.value[row]
    }
}

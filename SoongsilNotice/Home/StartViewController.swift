//
//  StartViewController.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import SnapKit
import UIKit

class StartViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private let bottomLabel: UILabel = {
        $0.text = "Copyright (C) 2019 Taein Kim All Rights Reserved."
        $0.textAlignment = .center
        $0.font = UIFont(name: "NotoSansKR-Light", size: 10)
        $0.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        return $0
    }(UILabel())
    
    private let titleLabel: UILabel = {
        $0.text = "앱을 시작하기 위해"
        $0.textAlignment = .center
        $0.font = UIFont(name: "NotoSansKR-Light", size: 16)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let subTitleLabel: UILabel = {
        $0.text = "전공을 선택해주세요"
        $0.textAlignment = .center
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 24)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let continueButton: UIButton = {
        $0.setTitle("계속하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor(named: "notissuButton1000s")
        $0.addTarget(self, action: #selector(onClickNext(_:)), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let majorPickerView: UIPickerView = {
        return $0
    }(UIPickerView())
    
    private var majorList = [DeptCode]()
    
    private var selectedIndex = 0
    private var selectedMajor: DeptCode = .IT_Computer
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for deptCode in DeptCode.allCases {
            majorList.append(deptCode)
        }
        
        majorList.removeLast()
        setupViewLayout()
        
        majorPickerView.dataSource = self
        majorPickerView.delegate = self
    }
    
    private func setupViewLayout() {
        view.backgroundColor = .white
        view.addSubview(bottomLabel)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(majorPickerView)
        view.addSubview(continueButton)
        
        bottomLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(46)
            make.bottom.equalTo(bottomLabel.snp.top).offset(-80)
        }
        
        majorPickerView.snp.makeConstraints { make in
            make.bottom.equalTo(continueButton.snp.top).offset(-36)
            make.height.equalTo(216)
            make.leading.trailing.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(majorPickerView.snp.top).offset(-36)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(subTitleLabel.snp.top).offset(-4)
        }
    }
    
    @objc
    private func onClickNext(_ sender: Any?) {
        let myCode = majorList[selectedIndex]
        
        BaseViewController.noticeDeptCode = myCode
        BaseViewController.noticeMajor = Major(majorCode: myCode)
        
        UserDefaults.standard.setValue(myCode.rawValue, forKey: "myDeptCode")
        
        UserDefaults(suiteName: "group.com.elliott.Notissu")?.set(myCode.rawValue, forKey: "myDeptCode")
        
        HomeSwitcher.updateRootVC()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.majorList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.majorList[row].getName()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
        selectedMajor = self.majorList[row]
    }
}

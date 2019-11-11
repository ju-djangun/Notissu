//
//  StartViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/10.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit

class StartViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var nextButton: UIButton!
    
    private var majorList = [DeptName]()
    private var majorCodeList = [DeptCode]()
    
    private var selectedIndex = 0
    private var selectedMajor = DeptName.IT_Computer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for deptName in DeptName.allCases {
            majorList.append(deptName)
        }
        
        for deptCode in DeptCode.allCases {
            majorCodeList.append(deptCode)
        }
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    @IBAction func onClickNext(_ sender: Any?) {
        let myCode = majorCodeList[selectedIndex]
        let myName = selectedMajor
        
        print(myCode.rawValue)
        print(myName.rawValue)
        BaseViewController.noticeDeptCode = myCode
        BaseViewController.noticeDeptName = myName
        
//        UserDefaults.standard.set(myCode, forKey: "myDeptCode")
        UserDefaults.standard.setValue(myCode.rawValue, forKey: "myDeptCode")
//        UserDefaults.standard.set(myName, forKey: "myDeptName")
        UserDefaults.standard.setValue(myName.rawValue, forKey: "myDeptName")
        
        HomeSwitcher.updateRootVC()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.majorList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.majorList[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
        selectedMajor = self.majorList[row]
    }
}
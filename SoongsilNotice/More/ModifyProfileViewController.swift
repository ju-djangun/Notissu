//
//  ModifyProfileViewController.swift
//  Notissu
//
//  Copyright © 2020 Notissu. All rights reserved.
//

import Foundation
import UIKit

class ModifyProfileViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var nextButton: UIButton!
    
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
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    @IBAction func onClickNext(_ sender: Any?) {
        let myCode = majorList[selectedIndex]
        
        BaseViewController.noticeDeptCode = myCode
        BaseViewController.noticeMajor    = Major(majorCode: myCode)
        
        UserDefaults.standard.setValue(myCode.rawValue, forKey: "myDeptCode")
        UserDefaults(suiteName: "group.com.elliott.Notissu")?.set(myCode.rawValue, forKey: "myDeptCode")
        
        self.navigationController?.popViewController(animated: true)
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

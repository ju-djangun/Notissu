//
//  TodayViewController.swift
//  Notissu Today Extension
//
//  Created by TaeinKim on 2020/01/26.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, TodayViewProtocol, NCWidgetProviding {
    private var presenter: TodayPresenter!
    
    @IBOutlet var widgetTitleSection: UIView!
    @IBOutlet var appButtonView: UIView!
    @IBOutlet var myMajorLbl: UILabel!
    @IBOutlet var noticeStackView: UIStackView!
    @IBOutlet var noticeStackViewHeight: NSLayoutConstraint!
    
    @IBAction func onClickAppButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        self.appButtonView.layer.masksToBounds = true
        self.appButtonView.layer.cornerRadius = self.appButtonView.bounds.height * 0.5
        
        self.widgetTitleSection.clipsToBounds = true
        self.widgetTitleSection.layer.cornerRadius = 15
        
        self.presenter = TodayPresenter(view: self)
        self.presenter.fetchCachedInfo(completion: { result in
            switch(result) {
            case .success(let deptModel):
                self.myMajorLbl.text = deptModel.myDeptName
                self.presenter.loadNoticeList(page: 0, keyword: nil, deptCode: deptModel.code)
            case .failure(let error):
                break
            }
        })
    }
    
    func applyToTableView(list: [Notice]) {
        
        self.noticeStackView.removeAllArrangedSubviews()
        self.noticeStackViewHeight.constant = 0
        if list.count > 3 {
            self.noticeStackViewHeight.constant = 144
        } else {
            self.noticeStackViewHeight.constant = CGFloat(36 * list.count)
        }
        
        for (index, notice) in list.enumerated() {
            if index > 3 {
                break
            }
            
            let noticeItemView = WidgetNoticeView.viewFromNib()
            noticeItemView.noticeItem = notice
            self.noticeStackView.addArrangedSubview(noticeItemView)
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == .compact) {
            self.preferredContentSize = maxSize
            self.noticeStackView.isHidden = true
        } else {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 110 + noticeStackViewHeight.constant + 15)
            self.noticeStackView.isHidden = false
        }
    }
    
}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

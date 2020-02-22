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
    
    @IBOutlet var shortcutImageViews: [UIImageView]!
    @IBOutlet var shortcutButtons: [UIButton]!
    @IBOutlet var shortcutLabels: [UILabel]!
    
    @IBOutlet weak var noticeStackView: UIStackView!
    @IBOutlet weak var noticeStackViewHeight: NSLayoutConstraint!
    
    @IBAction func onClickShortcutButton(_ sender: UIButton) {
        self.openAppByScheme(tag: sender.tag)
    }
    
    private func openAppByScheme(tag: Int) {
        if let url = URL(string: generateURLScheme(index: tag)) {
            self.extensionContext?.open(url) { _ in
                print("shortcuts button")
            }
        } else {
            print("shortcuts error 0x02")
        }
    }
    
    private func generateURLScheme(index: Int) -> String {
        if index == 3 {
            return "notissu://?index=4"
        }
        return "notissu://?index=\(index)"
    }
    
    private func setInitialViewStyle() {
        for (index, imageView) in shortcutImageViews.enumerated() {
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            
            imageView.tintColor = .white
            imageView.image = NotissuProperty.getImage(tag: index)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        self.setInitialViewStyle()
        self.noticeStackViewHeight.constant = 144
        
        self.presenter = TodayPresenter(view: self)
        self.applyToTableView(list: self.presenter.fetchCachedNotice())
        
        self.presenter.fetchCachedInfo(completion: { result in
            switch(result) {
            case .success(let deptModel):
                self.presenter.loadNoticeList(page: 0, keyword: nil, deptCode: deptModel.code)
            case .failure(_):
                break
            }
        })
    }
    
    func applyToTableView(list: [Notice]) {
        
        self.noticeStackView.removeAllArrangedSubviews()
        self.noticeStackViewHeight.constant = 144
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
            self.preferredContentSize = CGSize(width: maxSize.width, height: 110 + self.noticeStackViewHeight.constant + 15)
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

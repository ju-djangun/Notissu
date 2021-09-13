//
//  OpenSourceViewController.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import UIKit

struct OpenSource {
    let title: String?
    let url: String?
    let desc: String?
}

class OpenSourceViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var openSourceListView : UITableView!
    var openSourceList = [OpenSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addOpenSource()
        self.openSourceListView.delegate = self
        self.openSourceListView.dataSource = self
        self.openSourceListView.separatorInset = .zero
        self.openSourceListView.tableFooterView = UIView()
    }
    
    func addOpenSource() {
        self.openSourceList.append(OpenSource(title: "Alamofire", url: "https://github.com/Alamofire/Alamofire", desc: "Alamofire is an HTTP networking library written in Swift."))
        
        self.openSourceList.append(OpenSource(title: "Kanna", url: "https://github.com/tid-kijyun/Kanna", desc: "Kanna is an XML/HTML parser for cross-platform."))
        
        self.openSourceList.append(OpenSource(title: "lottie-ios", url: "https://github.com/airbnb/lottie-ios", desc: "An iOS library to natively render After Effects vector animations"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.openSourceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "openSourceCell", for: indexPath) as! OpenSourceTableViewCell
        
        cell.viewVC = self
        cell.titleLbl.text = openSourceList[indexPath.row].title
        cell.urlButton.setTitle(openSourceList[indexPath.row].url, for: .normal)
        cell.descLbl.text = openSourceList[indexPath.row].desc
        cell.selectionStyle  = .none
        
        return cell
    }
}

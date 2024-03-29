//
//  NoticeDetailAttachmentsListTableViewController.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit

class NoticeDetailAttachmentsListTableViewController: YDSTableViewController {
    
    //  MARK: - Property
    private var viewModel: NoticeDetailViewModel
    private var docController : UIDocumentInteractionController!
    weak var progressBarDelegate: ProgressBarDelegate?
    
    
    //  MARK: - Constant
    private enum Dimension {
        static let cellHeight: CGFloat = 48
    }
    
    //  MARK: - Init
    init(with viewModel: NoticeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupViews()
    }
    
    private func setupViews() {
        setViewProperties()
        setAutolayouts()
    }
    
    private func setViewProperties() {
        self.tableView.register(NoticeDetailAttachemtnsListItemCell.self,
                                forCellReuseIdentifier: "NoticeDetailAttachemtnsListItemCell")
        self.tableView.estimatedRowHeight = Dimension.cellHeight
        self.tableView.bounces = false
        self.tableView.isScrollEnabled = false
    }
    
    private func setAutolayouts() {
        tableView.snp.updateConstraints {
            $0.height.equalTo(tableView.contentSize.height)
        }
    }
    
    private func bindViewModel() {
        viewModel.attachments.bind { [weak self] _ in
            guard let `self` = self else { return }
            self.tableView.reloadData()
            self.setAutolayouts()
        }
        
        viewModel.downloadedFilePath.bind { [weak self] filePath in
            guard let `self` = self else { return }
            self.fileDownloadDidEnd(at: filePath)
        }
    }

}

//  MARK: - DataSource
extension NoticeDetailAttachmentsListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.attachments.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoticeDetailAttachemtnsListItemCell
            = tableView.dequeueReusableCell(withIdentifier: "NoticeDetailAttachemtnsListItemCell",
                                            for: indexPath)
            as? NoticeDetailAttachemtnsListItemCell ?? NoticeDetailAttachemtnsListItemCell()
        
        cell.fillData(with: viewModel.attachments.value[indexPath.row])
        return cell
    }
}

//  MARK: - Delegate
extension NoticeDetailAttachmentsListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        progressBarDelegate?.showProgressBar()
        viewModel.attachmentItemDidSelect(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Dimension.cellHeight
    }
}

//  MARK: - Download file
extension NoticeDetailAttachmentsListTableViewController: UIDocumentInteractionControllerDelegate {
    func fileDownloadDidEnd(at filePath: String?) {
        if let filePath = filePath {
            self.docController = UIDocumentInteractionController(url: NSURL(fileURLWithPath: filePath) as URL)
            self.docController.name = NSURL(fileURLWithPath: filePath).lastPathComponent
            self.docController.delegate = self
            self.docController.presentOptionsMenu(from: self.view.frame, in: self.view, animated: true)
        }
        progressBarDelegate?.hideProgressBar()
    }
}

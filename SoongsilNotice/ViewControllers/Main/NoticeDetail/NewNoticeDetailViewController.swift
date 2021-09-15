//
//  NoticeDetailViewController.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import WebKit
import YDS

class NewNoticeDetailViewController: BaseViewController {

    private let viewModel: NewNoticeDetailViewModel
    
    private enum Dimension {
        enum Margin {
            static let vertical: CGFloat = 20
            static let horizontal: CGFloat = 20
        }
    }
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: Dimension.Margin.vertical,
                                               left: Dimension.Margin.horizontal,
                                               bottom: Dimension.Margin.vertical,
                                               right: Dimension.Margin.horizontal)
        return stackView
    }()
    
    private let titleLabel: YDSLabel = {
        let label = YDSLabel(style: .title2)
        label.textColor = YDSColor.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private let captionLabel: YDSLabel = {
        let label = YDSLabel(style: .body2)
        label.textColor = YDSColor.textTertiary
        return label
    }()
    
    private let contentWebView: WKWebView = WKWebView()
    
    init(with viewModel: NewNoticeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    private func setupViews() {
        setViewProperties()
        setViewHierarchy()
        setAutolayouts()
    }
    
    private func setViewProperties() {
        titleLabel.text = viewModel.title
        captionLabel.text = viewModel.caption
        contentWebView.navigationDelegate = self
    }
    
    private func setViewHierarchy() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        [titleLabel, captionLabel, contentWebView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setAutolayouts() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalToSuperview()
        }
    }

}

extension NewNoticeDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.contentWebView.snp.makeConstraints {
                $0.height.equalTo(self.contentWebView.scrollView.contentSize.height)
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}

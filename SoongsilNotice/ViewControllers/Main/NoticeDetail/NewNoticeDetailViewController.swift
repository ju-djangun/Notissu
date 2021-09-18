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

    //  MARK: - Property
    
    private let viewModel: NoticeDetailViewModelProtocol
    
    
    //  MARK: - Constant
    
    private enum Dimension {
        enum Margin {
            static let vertical: CGFloat = 20
            static let horizontal: CGFloat = 24
        }
    }
    
    
    //  MARK: - View
    private let shareButton: YDSTopBarButton = {
        let configuration = UIImage.SymbolConfiguration(weight: .light)
        let icon = UIImage(systemName: "square.and.arrow.up.on.square",
                           withConfiguration: configuration)
        let button = YDSTopBarButton(image: icon)
        return button
    }()
    
    private let bookmarkButton: YDSTopBarButton = {
        let button = YDSTopBarButton(image: YDSIcon.starLine)
        button.setImage(YDSIcon.starFilled, for: .normal)
        return button
    }()
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: Dimension.Margin.vertical,
                                               left: 0,
                                               bottom: Dimension.Margin.vertical,
                                               right: 0)
        return stackView
    }()
    
    private let titleLabelArea = UIView()
    
    private let titleLabel: YDSLabel = {
        let label = YDSLabel(style: .title2)
        label.textColor = YDSColor.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private let captionLabelArea = UIView()
    
    private let captionLabel: YDSLabel = {
        let label = YDSLabel(style: .body2)
        label.textColor = YDSColor.textTertiary
        return label
    }()
    
    private let webView: WKWebView = WKWebView()
    
    private let divider: YDSDivider = {
        let divider = YDSDivider(.horizontal)
        divider.thickness = .thick
        return divider
    }()
    
    //  MARK: - ViewController
    
    private let attachmentsListTableViewController: NoticeDetailAttachmentsListTableViewController
    
    
    //  MARK: - Init
    init(with viewModel: NewNoticeDetailViewModel) {
        self.viewModel = viewModel
        self.attachmentsListTableViewController = NoticeDetailAttachmentsListTableViewController(with: viewModel)
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //  MARK: - Func
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindViewModel()
        loadWebView()
    }
    
    private func setupViews() {
        setViewProperties()
        setViewHierarchy()
        setAutolayouts()
    }
    
    private func setViewProperties() {
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.title = viewModel.title
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-2, for: .default)
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: bookmarkButton),
                                                    UIBarButtonItem(customView: shareButton),],
                                                   animated: true)
        [bookmarkButton, shareButton].forEach {
            $0.addTarget(self,
                         action: #selector(buttonDidTap(_:)),
                         for: .touchUpInside)
        }
        
        scrollView.delegate = self
        
        titleLabel.text = viewModel.title
        captionLabel.text = viewModel.caption
        
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        webView.tintColor = YDSColor.textPointed
        
        attachmentsListTableViewController.progressBarDelegate = self
    }
    
    private func setViewHierarchy() {
        self.embed(attachmentsListTableViewController)
        self.view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        [titleLabelArea,
         captionLabelArea,
         webView,
         divider,
         attachmentsListTableViewController.view].forEach {
            stackView.addArrangedSubview($0)
        }
        titleLabelArea.addSubview(titleLabel)
        captionLabelArea.addSubview(captionLabel)
    }
    
    private func setAutolayouts() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalToSuperview()
        }

        [titleLabel, captionLabel].forEach {
            $0.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(Dimension.Margin.horizontal)
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.html.bind { [weak self] html in
            guard let `self` = self else { return }
            self.webView.loadHTMLString(html, baseURL: nil)
        }
        
        viewModel.url.bind { [weak self] url in
            guard let `self` = self else { return }
            self.webView.load(URLRequest(url: URL(string: url)!))
        }
        
        viewModel.isBookmarked.bindAndFire { [weak self] isBookmakred in
            guard let `self` = self else { return }
            self.bookmarkButton.setImage(isBookmakred
                                            ? YDSIcon.starFilled
                                            : YDSIcon.starLine,
                                         for: .normal)
        }
        
        viewModel.shouldDividerBeHidden.bindAndFire { [weak self] value in
            guard let `self` = self else { return }
            self.divider.isHidden = value
        }
    }
    
    private func loadWebView() {
        self.showProgressBar()
        viewModel.loadWebView()
    }

}


//  MARK: - WKNavigationDelegate

extension NewNoticeDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.hideProgressBar()
            self.webView.snp.makeConstraints {
                $0.height.equalTo(self.webView.scrollView.contentSize.height)
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


//  MARK: - Action

extension NewNoticeDetailViewController {
    @objc
    func buttonDidTap(_ sender: UIControl) {
        switch(sender) {
        case shareButton:
            presentActivityViewController()
        case bookmarkButton:
            viewModel.bookmarkButtondidTap()
        default:
            return
        }
    }
    
    private func presentActivityViewController() {
        guard let url = viewModel.url.value.decodeUrl()?.encodeUrl(),
              let url = NSURL(string: url) else {
            YDSToast.makeToast(text: "공유할 수 없는 링크입니다.")
            return
        }
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        case .pad:
            YDSToast.makeToast(text: "iPad에서 링크를 공유할 수 없습니다.")
        default:
            YDSToast.makeToast(text: "링크를 공유할 수 없는 기기입니다.")
        }
    }
}


//  MARK: - ScrollView Delegate

extension NewNoticeDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            return
        }
        
        let topBarHeight: CGFloat = self.navigationController?.navigationBar.bounds.height ?? 44
        let gap: CGFloat = ((scrollView.contentOffset.y + topBarHeight)
                    - (titleLabel.bounds.height + Dimension.Margin.vertical))
        
        var alpha: CGFloat {
            let alpha = gap/topBarHeight
            if alpha > 1 {
                return 1
            } else if alpha < 0 {
                return 0
            } else {
                return alpha
            }
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: YDSFont.subtitle3,
            NSAttributedString.Key.foregroundColor: YDSColor.textSecondary.withAlphaComponent(alpha)
        ]
    }
}

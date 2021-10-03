//
//  DeveloperDetailViewController.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import SafariServices
import UIKit
import YDS

class DeveloperDetailView: UIView {
    
    //  MARK: - Model
    private let model: Developer
    
    //  MARK: - Constant
    private enum Dimension {
        enum Margin {
            static let vertical: CGFloat = 0
            static let horizontal: CGFloat = 20
        }
        enum Padding {
            static let vertical: CGFloat = 8
            static let horizontal: CGFloat = 4
        }
    }
    
    //  MARK: - View
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: Dimension.Margin.vertical,
                                               left: Dimension.Margin.horizontal,
                                               bottom: Dimension.Margin.vertical,
                                               right: Dimension.Margin.horizontal)
        return stackView
    }()
    
    private let profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: Dimension.Padding.vertical,
                                               left: Dimension.Padding.horizontal,
                                               bottom: Dimension.Padding.vertical,
                                               right: Dimension.Padding.horizontal)
        return stackView
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        return stackView
    }()
    
    private let profileImageView: YDSProfileImageView = {
        let imageView = YDSProfileImageView()
        imageView.size = .large
        return imageView
    }()
    
    private let headerLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        return stackView
    }()
    
    private let nameLabel: YDSLabel = {
        let label = YDSLabel(style: .title3)
        label.textColor = YDSColor.textPrimary
        return label
    }()
    
    private let idLabel: YDSLabel = {
        let label = YDSLabel(style: .body2)
        label.textColor = YDSColor.textSecondary
        return label
    }()
    
    private let bioLabel: YDSLabel = {
        let label = YDSLabel(style: .body1)
        label.textColor = YDSColor.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private let captionLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }()
    
    private let companyLabel: YDSLabel = {
        let label = YDSLabel(style: .body2)
        label.textColor = YDSColor.textSecondary
        label.numberOfLines = 0
        return label
    }()
    
    private let locationLabel: YDSLabel = {
        let label = YDSLabel(style: .body2)
        label.textColor = YDSColor.textSecondary
        label.numberOfLines = 0
        return label
    }()
    
    private let emailLabel: YDSLabel = {
        let label = YDSLabel(style: .body2)
        label.textColor = YDSColor.textSecondary
        label.numberOfLines = 0
        return label
    }()
    
    private let githubButton: YDSBoxButton = {
        let button = YDSBoxButton()
        button.size = .large
        button.rounding = .r8
        button.text = "개발자 GitHub 방문"
        return button
    }()
    
    //  MARK: - Init
    init(with model: Developer) {
        self.model = model
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Func
    private func setupViews() {
        setProperties()
        setViewHierarchy()
        setAutolayout()
    }
    
    private func setProperties() {
        nameLabel.text = model.name
        idLabel.text = "@\(model.login)"
        
        bioLabel.text = model.bio
        
        if let company = model.company {
            companyLabel.text = "🏢 " + company
        } else {
            companyLabel.isHidden = true
        }
        
        if let location = model.location {
            locationLabel.text = "📍 " + location
        } else {
            locationLabel.isHidden = true
        }
        
        if let email = model.email {
            emailLabel.text = "📬 " + email
        } else {
            emailLabel.isHidden = true
        }
        
        if let url = model.avatarURL {
            loadProfileImage(from: url)
        }
        
        githubButton.addTarget(self,
                               action: #selector(buttonDidTap(_:)),
                               for: .touchUpInside)
    }
    
    private func setViewHierarchy() {
        self.addSubview(stackView)
        
        [profileStackView, githubButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [headerStackView, bioLabel, captionLabelStackView].forEach {
            profileStackView.addArrangedSubview($0)
        }
        
        [profileImageView, headerLabelStackView].forEach {
            headerStackView.addArrangedSubview($0)
        }
        
        [nameLabel, idLabel].forEach {
            headerLabelStackView.addArrangedSubview($0)
        }
        
        [companyLabel, locationLabel, emailLabel].forEach {
            captionLabelStackView.addArrangedSubview($0)
        }
    }
    
    private func setAutolayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(Screen.width)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

//  MARK: -  Load Profile Image
extension DeveloperDetailView {
    private func loadProfileImage(from url: String?) {
        if let url = url {
            ImageFetchManager.shared.loadImage(from: url) { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(let data):
                    self.profileImageView.image = UIImage(data: data)
                case .failure(_):
                    YDSToast.makeToast(text: "네트워크 오류가 발생했습니다.")
                }
            }
        }
    }
}

//  MARK: - Action
extension DeveloperDetailView {
    @objc
    func buttonDidTap(_ sender: UIControl) {
        if let url = URL(string: model.htmlURL) {
            UIApplication.shared.open(url,
                                      options: [:],
                                      completionHandler: nil)
        }
    }
}

//
//  MainUINavigationBar.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import UIKit

public class MainUINavigationBar: UINavigationBar {
    private let emptyShadowImage: UIImage = UIImage(color: UIColor.clear, size: CGSize(width: 1, height: 1.0 / UIScreen.main.scale))
    private var defaultShadowImage: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func setDefaultHeroNavigationStyle() {
        isTranslucent = false
        tintColor = .blue
        backgroundColor = .white
    }
    
    public func setDefaultShadowImage() {
        guard shadowImage != defaultShadowImage else { return }
        shadowImage = defaultShadowImage
    }
    
    public func removeDefaultShadowImage() {
        guard shadowImage != emptyShadowImage else { return }
        shadowImage = emptyShadowImage
    }
    
    func reloadShadowImages() {
        defaultShadowImage = UIImage(color: UIColor.black.withAlphaComponent(0.15),
                                     size: CGSize(width: 1, height: 1.0 / UIScreen.main.scale))
    }
}

public extension UINavigationItem {
    func setRightHeroBarButtonItem(_ item: UIBarButtonItem?, animated: Bool) {
        guard let item = item else {
            rightBarButtonItem = nil
            rightBarButtonItems = nil
            return
        }
        
        setRightBarButton(item, animated: animated)
    }
    
    func setRightHeroBarButtonItems(_ items: [UIBarButtonItem]?, animated: Bool) {
        guard let items = items else {
            rightBarButtonItem = nil
            rightBarButtonItems = nil
            return
        }
        
        let buttonItems: [UIBarButtonItem] = items
        setRightBarButtonItems(buttonItems, animated: animated)
    }
    
    func setRightHeroBarButtonItems(_ items: [UIBarButtonItem]?) {
        setRightHeroBarButtonItems(items, animated: false)
    }
    
    func setLeftHeroBarButtonItem(_ item: UIBarButtonItem?, animated: Bool) {
        guard let item = item else {
            setLeftBarButton(nil, animated: animated)
            setLeftBarButtonItems(nil, animated: animated)
            return
        }
        
        setLeftBarButton(item, animated: animated)
    }
    
    func setLeftHeroBarButtonItems(_ items: [UIBarButtonItem]?, animated: Bool) {
        guard let items = items else {
            leftBarButtonItem = nil
            leftBarButtonItems = nil
            return
        }
        
        let buttonItems: [UIBarButtonItem] = items
        setLeftBarButtonItems(buttonItems, animated: animated)
    }
    
    func setLeftHeroBarButtonItem(_ item: UIBarButtonItem?) {
        setLeftHeroBarButtonItem(item, animated: false)
    }
    
    var rightHeroBarButtonItem: UIBarButtonItem? {
        if rightBarButtonItems != nil && rightBarButtonItems!.count > 0 {
            return rightBarButtonItems?.last
        }
        if rightBarButtonItem != nil {
            return rightBarButtonItem
        }
        return nil
    }
    
    var rightHeroBarButtonItems: [UIBarButtonItem]? {
        if rightBarButtonItems != nil {
            return rightBarButtonItems
        }
        if rightBarButtonItem != nil {
            return [rightBarButtonItem!]
        }
        return nil
    }
    
    var leftHeroBarButtonItem: UIBarButtonItem? {
        if leftBarButtonItems != nil && leftBarButtonItems!.count > 0 {
            return leftBarButtonItems?.last
        }
        if leftBarButtonItem != nil {
            return leftBarButtonItem
        }
        return nil
    }
    
    var leftHeroBarButtonItems: [UIBarButtonItem]? {
        if leftBarButtonItems != nil {
            return leftBarButtonItems
        }
        if leftBarButtonItem != nil {
            return [leftBarButtonItem!]
        }
        return nil
    }
    
    func setRightBarButtonItemEnabled(_ enabled: Bool) {
        rightHeroBarButtonItem?.isEnabled = enabled
    }
    
    func setLeftBarButtonItemEnabled(_ enabled: Bool) {
        leftHeroBarButtonItem?.isEnabled = enabled
    }
}

//
//  NotissuWidgetBundle.swift
//  Notissu WidgetKitExtension
//
//  Created by Denny on 2020/09/20.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

@main
struct NotissuWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        FavoriteWidget()
        ShortcutWidget()
    }
}

//
//  NotissuShortcutWidget.swift
//  Notissu WidgetKitExtension
//
//  Created by Denny on 2020/09/20.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

struct ShortcutProvider: TimelineProvider {
    public typealias Entry = ShortcutEntry

    public func snapshot(with context: Context, completion: @escaping (ShortcutEntry) -> ()) {
        let entry = ShortcutEntry(date: Date())
        completion(entry)
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        
        let entry = ShortcutEntry(date: entryDate)

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct ShortcutEntry: TimelineEntry {
    public let date: Date
}

struct ShortcutPlaceholderView : View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct NotissuShortcutEntryView : View {
    var entry: ShortcutProvider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct ShortcutWidget: Widget {
    private let kind: String = "ShortcutWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ShortcutProvider(), placeholder: ShortcutPlaceholderView()) { entry in
            NotissuShortcutEntryView(entry: entry)
        }
        .configurationDisplayName("Favorite Widget")
        .description("Notissu Favorite Widget")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

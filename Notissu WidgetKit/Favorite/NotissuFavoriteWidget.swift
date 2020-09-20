//
//  Notissu_WidgetKit.swift
//  Notissu WidgetKit
//
//  Created by Denny on 2020/09/18.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import WidgetKit
import SwiftUI

struct FavoriteProvider: TimelineProvider {
    public typealias Entry = FavoriteEntry

    public func snapshot(with context: Context, completion: @escaping (FavoriteEntry) -> ()) {
        let entry = FavoriteEntry(date: Date(), notices: nil)
        completion(entry)
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .second, value: 1, to: currentDate)!
        let favoriteNotices: [Notice] = FavoriteFetcher.shared.fetchFavoriteNotice()
        
        let entry = FavoriteEntry(date: entryDate, notices: favoriteNotices)

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct FavoriteEntry: TimelineEntry {
    public let date: Date
    public let notices: [Notice]?
}

struct FavoritePlaceholderView : View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct NotissuFavoriteEntryView : View {
    var entry: FavoriteProvider.Entry

    var body: some View {
        Text(entry.date, style: .time)
        Text(entry.notices?.first?.title ?? "No Favorite")
    }
}

struct FavoriteWidget: Widget {
    private let kind: String = "ShortcutWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FavoriteProvider(), placeholder: FavoritePlaceholderView()) { entry in
            NotissuFavoriteEntryView(entry: entry)
        }
        .configurationDisplayName("Favorite Widget")
        .description("Notissu Favorite Widget")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

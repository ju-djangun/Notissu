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
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    struct Constants {
        static let topMargin: CGFloat = 0.0
        static let bottomMargin: CGFloat = 0.0
        static let buttonHeight: CGFloat = 40.0
        static let buttonWidth: CGFloat = 40.0
    }
    
    var entry: ShortcutProvider.Entry
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Link(destination: URL(string: "notissu://?index=0")!) {
                        Group {
                            Image("my_notice").resizable().renderingMode(.template).colorMultiply(.white).padding(10)
                        }
                        .background(Color(UIColor(named: "notissuBlue1000s")!))
                        .frame(width: Constants.buttonWidth,
                               height: Constants.buttonWidth,
                               alignment: .center)
                        .cornerRadius(Constants.buttonWidth / 2)
                    }
                    Text("내 공지").font(.system(size: 10))
                }.frame(minWidth: 0, maxWidth: .infinity)
                
                
                VStack {
                    Link(destination: URL(string: "notissu://?index=1")!) {
                        Group {
                            Image("major_list").resizable().renderingMode(.template).colorMultiply(.white).padding(10)
                        }
                        .background(Color(UIColor(named: "notissuBlue1000s")!))
                        .frame(width: Constants.buttonWidth,
                               height: Constants.buttonWidth,
                               alignment: .center)
                        .cornerRadius(Constants.buttonWidth / 2)
                    }
                    Text("전공목록").font(.system(size: 10))
                }.frame(minWidth: 0, maxWidth: .infinity)
            }
            
            HStack {
                VStack {
                    Link(destination: URL(string: "notissu://?index=2")!) {
                        Group {
                            Image("tab_school").resizable().renderingMode(.template).colorMultiply(.white).padding(10)
                        }
                        .background(Color(UIColor(named: "notissuBlue1000s")!))
                        .frame(width: Constants.buttonWidth,
                               height: Constants.buttonWidth,
                               alignment: .center)
                        .cornerRadius(Constants.buttonWidth / 2)
                    }
                    Text("학교공지").font(.system(size: 10))
                }.frame(minWidth: 0, maxWidth: .infinity)
                
                VStack {
                    Link(destination: URL(string: "notissu://?index=4")!) {
                        Group {
                            Image("more")
                                .resizable()
                                .renderingMode(.template)
                                .colorMultiply(.blue)
                                .padding(10)
                        }
                        .background(Color(UIColor(named: "notissuBlue1000s")!))
                        .frame(width: Constants.buttonWidth,
                               height: Constants.buttonWidth,
                               alignment: .center)
                        .cornerRadius(Constants.buttonWidth / 2)
                    }
                    Text("더보기").font(.system(size: 10))
                }.frame(minWidth: 0, maxWidth: .infinity)
                
            }
        }
        .widgetURL(URL(string: "notissu://?index=1")!)
        .padding(10)
    }
}

struct ShortcutWidget: Widget {
    private let kind: String = "ShortcutWidget"
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ShortcutProvider(), placeholder: ShortcutPlaceholderView()) { entry in
            NotissuShortcutEntryView(entry: entry)
        }
        .configurationDisplayName("Shortcut Widget")
        .description("Notissu Shortcut Widget")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

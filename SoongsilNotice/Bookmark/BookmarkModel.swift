//
//  BookmarkModel.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2020/02/18.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation

class BookmarkModel: BookmarkModelProtocol {
    private var bookmarkList: [FavoriteNotice] = [FavoriteNotice]()
    
    func removeBookmarkAll() {
        self.bookmarkList.removeAll()
    }
    
    func appendBookmarkList(list: [FavoriteNotice]) {
        self.bookmarkList.append(contentsOf: list)
    }
    
    func appendBookmark(bookmark: FavoriteNotice) {
        self.bookmarkList.append(bookmark)
    }
}

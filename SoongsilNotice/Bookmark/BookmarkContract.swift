//
//  BookmarkContract.swift
//  Notissu
//
//  Copyright © 2020 Notissu. All rights reserved.
//

import Foundation

protocol BookmarkViewProtocol {
    func applyListToTableView(list: [FavoriteNotice])
}

protocol BookmarkPresenterProtocol {
    func getBookmark(at: Int) -> FavoriteNotice
    
    func getBookmarkCount() -> Int
    
    func fetchBookmarkNotice()
    
    func removeBookmark(at: Int)
    
    func removeBookmark(bookmark: FavoriteNotice)
}

protocol BookmarkModelProtocol {
    func getBookmark(at: Int) -> FavoriteNotice
    
    func getBookmarkCount() -> Int
    
    func removeBookmarkAll()
    
    func appendBookmarkList(list: [FavoriteNotice])
    
    func appendBookmark(bookmark: FavoriteNotice)
}

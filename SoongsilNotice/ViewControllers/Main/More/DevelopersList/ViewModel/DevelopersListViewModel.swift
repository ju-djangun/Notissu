//
//  DevelopersListViewModel.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

protocol DevelopersListViewModelOutput {
    var error: Dynamic<String?> { get }
    var developersList: Dynamic<[Developer]> { get }
    var tappedDeveloper: Dynamic<Developer?> { get }
}

protocol DevelopersListViewModelInput {
    func loadDevelopersList()
    func itemDidTap(at index: IndexPath)
}

protocol DevelopersListViewModelProtocol: DevelopersListViewModelOutput, DevelopersListViewModelInput {}

class DevelopersListViewModel: DevelopersListViewModelProtocol {
    
    //  MARK: - INPUT
    var error: Dynamic<String?> = Dynamic<String?>(nil)
    var developersList: Dynamic<[Developer]> = Dynamic<[Developer]>([])
    var tappedDeveloper: Dynamic<Developer?> = Dynamic<Developer?>(nil)
    
    //  MARK: - OUTPUT
    func loadDevelopersList() {
        GithubFetchManager.shared.loadDevelopersList() { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let items):
                self.developersList.value = items.sorted(by: {$0.id < $1.id})
            case .failure(_):
                self.error.value = "네트워크 오류가 발생했습니다."
            }
        }
    }
    
    func itemDidTap(at indexPath: IndexPath) {
        tappedDeveloper.value = developersList.value[indexPath.row]
    }
}

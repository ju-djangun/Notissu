//
//  GithubFetchManager.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import Alamofire
import GoogleUtilities

final class GithubFetchManager {
    //  MARK: - Singleton
    static let shared = GithubFetchManager()
    
    //  MARK: - URL
    private let baseURL = "https://api.github.com"
    private var repoURL: String { "\(baseURL)/repos/della-padula/Notissu/contributors" }
    private func profileURL(id: String) -> String { "\(baseURL)/users/\(id)" }
    
    //  MARK: - Loader
    func loadDevelopersList(completion: @escaping (Result<[Developer], FetchError>) -> Void) {
        clearDevelopersList()
        
        AF.request(repoURL).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                guard let list = self.parseData(as: [RequestedDevelopersListItemModel].self,
                                                from: data)
                else {
                    completion(.failure(.parsingError))
                    return
                }
                self.loadDevelopers(list: list, completion: completion)
            case .failure(_):
                completion(.failure(.networkError))
            }
        }
    }
    
    private func loadDevelopers(list: [RequestedDevelopersListItemModel],
                                      completion: @escaping (Result<[Developer], FetchError>) -> Void) {
        numberOfDevelopers = list.count
        
        list.forEach {
            AF.request($0.url).responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    guard let profile = self.parseData(as: Developer.self,
                                                       from: data)
                    else {
                        completion(.failure(.parsingError))
                        return
                    }
                    self.appendDeveloper(profile, completion: completion)
                case .failure(_):
                    completion(.failure(.networkError))
                }
            }
        }
    }
    
    //  MARK: - Parser
    private let decoder = JSONDecoder()

    private func parseData<T: Decodable>(as: T.Type,
                                         from data: Any) -> T? {
        if let data = try? JSONSerialization.data(withJSONObject: data,
                                                  options: .prettyPrinted),
           let parsedData = try? self.decoder.decode(T.self,
                                               from: data) {
            return parsedData
        }
        return nil
    }
    
    //  MARK: - List
    private var developersList = [Developer]()
    private var numberOfDevelopers: Int? = nil
    
    private func appendDeveloper(_ developer: Developer,
                                 completion: @escaping (Result<[Developer], FetchError>) -> Void) {
        developersList.append(developer)
        
        if developersList.count == numberOfDevelopers {
            completion(.success(developersList))
        }
    }
    
    private func clearDevelopersList() {
        developersList = [Developer]()
        numberOfDevelopers = nil
    }
}

//  MARK: - Model
fileprivate struct RequestedDevelopersListItemModel: Codable {
    let login: String
    let url: String
}

//  MARK: - FetchError
enum FetchError: Error {
    case networkError
    case parsingError
}

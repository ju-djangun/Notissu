//
//  ImageFetchManager.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import Alamofire

final class ImageFetchManager {
    //  MARK: - Singleton
    static let shared = ImageFetchManager()
    
    func loadImage(from url: String, completion: @escaping (Result<Data, FetchError>) -> Void) {
        AF.request(url).responseData { (response) in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                completion(.failure(.networkError))
            }
        }
    }
}

//
//  APIService.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 16.04.22.
//

import Foundation

class APIService: NSObject {
    
    static let shared = APIService()
    
    private override init() {
        super.init()
    }
    
    func fetchData<T: Decodable>(sourcesURL: URL, model: T.Type, completion: @escaping (Result<T, Error>) -> ()) {
        print("Fetching data from \(sourcesURL)")
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let data = data {
                do {
                    let modelData = try JSONDecoder().decode(model.self, from: data)
                    completion(.success(modelData))
                } catch (let error) {
                    completion(.failure(error))
                }
            } else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(AppError.unknownError))
                }
            }
            
        }.resume()
    }
    
}

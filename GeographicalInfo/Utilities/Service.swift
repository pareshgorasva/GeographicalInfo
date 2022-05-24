//
//  Service.swift
//  GeographicalInfo
//
//  Created by Paresh Gorasva on 23/5/2022.
//

import Foundation

class Service: NSObject {
    
    static let shared = Service()
    
    func getAPICall<T: Decodable>(urlString: String, httpMethod: String, expecting: T.Type, completion: @escaping (Result<T, ServiceError>) -> Void) {
        guard let url = URL(string: ApiURL.getGeographicalInformation) else {
            completion(.failure(.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                completion(.failure(.errorMessage))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let jsonData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(jsonData))
            }catch {
                completion(.failure(.invalidResponse))
            }
        }
        task.resume()
    }
    
    func getDataFromFile<T: Decodable>(fileName: String, expecting: T.Type, completion: @escaping(Result<T, ServiceError>) -> Void) {
        
        guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            completion(.failure(.fileError))
            return
        }
        
        do {
            let data = try Data(contentsOf: file)
            let jsonData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(jsonData))
        }catch{
            completion(.failure(.fileInvalidData))
        }
    }
}

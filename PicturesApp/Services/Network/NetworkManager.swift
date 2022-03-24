//
//  APIManager.swift
//  PicturesApp
//
//  Created by Антон Кочетков on 15.03.2022.
//

import Foundation

typealias Parametrs = [String: String]

protocol Networking {
    func request(parametrs: Parametrs, completion: @escaping (Data?, Error?) -> Void)
    func downloadPhoto(urlPhoto: String?, completion: @escaping (Data?) -> Void)
}

class NetworkManager: Networking {
    func request(parametrs: Parametrs, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = createURL(params: parametrs) else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        request.addValue(API.key, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, error!)
                return
            }
            if let data = data {
                completion(data, nil)
            } else {
                completion(nil, nil)
            }
        }
        task.resume()
    }
    
    func downloadPhoto(urlPhoto: String?, completion: @escaping (Data?) -> Void) {
        guard let urlPhoto = urlPhoto,
              let url = URL(string: urlPhoto) else { return }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            completion(cachedResponse.data)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, _) in
            if let data = data, let response = response {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                        
                completion(data)
            } else {
                completion(nil)
            }
            
        }
        dataTask.resume()
    }
    
    private func createURL(params: Parametrs) -> URL? {
        var componentsURL = URLComponents()
        componentsURL.scheme = API.scheme
        componentsURL.host = API.host
        componentsURL.path = API.path
        if !params.isEmpty {
            componentsURL.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        }
        
        return componentsURL.url
    }
}

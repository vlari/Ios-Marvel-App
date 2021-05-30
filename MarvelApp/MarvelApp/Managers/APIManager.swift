//
//  APIManager.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/24/21.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    var pageLimit = 20
    private init() {}
    
    struct Constants {
        static let baseURL = "https://gateway.marvel.com/"
        static let timeStamp = 1
        static let apiKey = "e7148640a6322e5f43a984f7054fe335"
        static let hashTest = "9176945764cee9da332780aab6bbaf7d"
    }
    
    public func getCharacters(forPage: Int, withName name: String?, orderBy: String?, completion: @escaping (Result<APIResponse<Character>, Error>) -> Void) {
        
        var baseURL = Constants.baseURL + Enpoint.characters.rawValue + buildQuery(hasPaging: true, page: forPage)
        let orderByQuery = orderBy ?? "name"
        baseURL += "&orderBy=\(orderByQuery.lowercased())"
        
        if let nameQuery = name,
           !nameQuery.trimmingCharacters(in: .whitespaces).isEmpty {
            baseURL += "&name=\(nameQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        
        createRequest(with: URL(string: baseURL), method: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedResponseData))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...300).contains(response.statusCode) else {
                    completion(.failure(APIError.failedStatusCode))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(APIResponse<Character>.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    func getComics(from id: Int ,forPage: Int ,completion: @escaping (Result<APIResponse<Comic>, Error>) -> Void) {
        var baseURL = Constants.baseURL + Enpoint.characters.rawValue + "/\(id)/comics" + buildQuery(hasPaging: false, page: forPage)
        baseURL += "&orderBy=title"
        
        createRequest(with: URL(string: baseURL), method: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedResponseData))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...300).contains(response.statusCode) else {
                    completion(.failure(APIError.failedStatusCode))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(APIResponse<Comic>.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    private func createRequest(with url: URL?, method: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        guard let reqUrl = url else { return }
        
        var request = URLRequest(url: reqUrl)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 60
        completion(request)
    }
    
    private func buildQuery(hasPaging: Bool, page: Int = 0) -> String {
        var query = "?apikey=\(Constants.apiKey)&ts=\(Constants.timeStamp)&hash=\(Constants.hashTest)"
        if hasPaging {
            query += "&limit=\(pageLimit)&offset=\(pageLimit * page)"
        }
        
        return query
    }
    
    enum APIError: Error {
        case failedResponseData
        case failedStatusCode
    }
    
    enum Enpoint: String {
        case characters = "v1/public/characters"
    }
    
    enum HTTPMethod: String {
        case GET
    }
}

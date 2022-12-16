//
//  APIManager.swift
//  Spotify
//
//  Created by Amini on 26/10/22.
//

import Foundation
import Combine
import UIKit

enum NetworkerError: Error {
    case badResponse
    case badStatusCode(Int)
    case badData
}

enum APIRoute {
    case spotify
    
    var baseURL: String {
        switch self {
        case .spotify:
            return "https://\(subdomain).\(domain)/\(route)/"
        }
    }
    
    private var domain: String {
        switch self {
        case .spotify:
            return "spotify.com"
        }
    }
    
    private var subdomain: String {
        switch self {
        case .spotify:
            return "api"
        }
    }
    private var route: String {
        return "v1"
    }
}

struct APIService {
    static func get<T: Decodable>(for url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func getWithToken<T: Decodable>(url: URL, with token: String) -> AnyPublisher<T, Error> {
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let publisher = URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }.decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        return publisher        
    }
    
    static func publisherWithToken(for url: URL, token: String?) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.timeoutInterval = 30

        if let token = token {
            request.setValue("Bearer \(token)",
                           forHTTPHeaderField: "Authorization")
        }

        let publisher = URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap({ result in
                
                let str = String(decoding: result.data, as: UTF8.self)
                print("result for url -> \(url):\n\(str)")
                
                  guard let httpResponse = result.response as? HTTPURLResponse,
                        httpResponse.statusCode == 200 else {

                    let error = try JSONDecoder().decode(SerivceError.self, from: result.data)
                    throw error
                  }

                return result.data
            })
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    static func getWithValidToken<T: Decodable>(for url: URL) -> AnyPublisher<T, Error> {
        return AuthManager.shared.validToken()
            .flatMap ({ token in
                return APIService.publisherWithToken(for: url, token: token)
            })
            .tryCatch { error -> AnyPublisher<Data, Error> in
                return AuthManager.shared.validToken(forceRefresh: true)
                    .flatMap { token in
                        APIService.publisherWithToken(for: url, token: token)
                    }
                    .eraseToAnyPublisher()
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct Token: Decodable {
    let isValid: Bool
}

struct Response: Decodable {
    let message: String
}

enum SerivceErrorMessage: String, Decodable, Error {
    case invalidToken = "invalid_token"
}

struct SerivceError: Decodable, Error {
    let errors: [SerivceErrorMessage]
}

enum AuthenticationError: Error {
  case loginRequired
}


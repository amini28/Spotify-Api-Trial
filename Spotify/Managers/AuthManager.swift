//
//  AuthManager.swift
//  Spotify
//
//  Created by Amini on 25/12/21.
//

import Foundation
import Combine
//import XCTest

final class AuthManager {
    
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    struct Constants {
        static let clientID = "9f174cd6f418428b9d828f456eeefdf2"
        static let clientSecret = "67e2a94a16324d2485ef497820d8a1a2"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.iosacademy.io"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email%20user-read-recently-played"

    }
    
    private init() {
    }
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
        
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
        
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    
    public func excngeCodeForToken(code: String) -> Future<Bool, Error>{
        return Future { promise in
            guard let url = URL(string: Constants.tokenAPIURL) else {
                return promise(Result.failure(AuthenticationError.loginRequired))
            }

            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "grant_type", value: "authorization_code"),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            ]

            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = components.query?.data(using: .utf8)

            let basicToken = Constants.clientID + ":" + Constants.clientSecret
            let data = basicToken.data(using: .utf8)

            guard let base64String = data?.base64EncodedString() else {
                return promise(Result.failure(AuthenticationError.loginRequired))
            }

            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request){ [weak self]  data, _, error in
                
                guard let data = data,
                      error == nil else {
                        return promise(Result.failure(AuthenticationError.loginRequired))
                      }
                do {

                    
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    self?.cacheToken(result: result)
                    
                    promise(Result.success(true))
                }
                catch {
                    print(error.localizedDescription)
                    promise(Result.failure(AuthenticationError.loginRequired))
                }
            }
            task.resume()

        }
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    /// Supplies valid token to be used with API Calls
    
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            //append the completion
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            // Refresh
            refreshIfNeeded{ [weak self] success in
                if success {
                    if let token = self?.accessToken, success {
                        completion(token)
                    }
                }
            }
        }
        else if let token = accessToken {
            completion(token)
        }
        
    }
    
    public func refreshIfNeeded(completion:  ((Bool) -> Void)?) {
        
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        //Refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)

        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion?(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request){ [weak self] data, _, error in
            self?.refreshingToken = false
            
            guard let data = data,
                  error == nil else {
                      completion?(false)
                      return
                  }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("Successfully refreshed")
                self?.onRefreshBlocks.forEach{ $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                
                completion?(true)
            }
            catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
    }
    
    private func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")

        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    

    private var refreshPublisher: AnyPublisher<String, Error>?
    
    public func validToken(forceRefresh: Bool = false) -> AnyPublisher<String, Error> {
        
        let queue = DispatchQueue(label: accessToken!)
        return queue.sync {
            // this is for checking tokens
            // scenario 1: we're already loading a new token
//            if let publisher = self.refreshPublisher {
//                return publisher
//            }
            
            // scenario 2: we don't have a token at all, the user should probably log in
            guard let token = accessToken else {
              return Fail(error: AuthenticationError.loginRequired)
                .eraseToAnyPublisher()
            }

            // scenario 3: we already have a valid token and don't want to force a refresh
            if (accessToken != nil), !forceRefresh {
              return Just(token)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            
            guard let refreshToken = self.refreshToken else {
                return Fail(error: AuthenticationError.loginRequired)
                    .eraseToAnyPublisher()
            }

            // scenario 4: we need a new token
            guard let url = URL(string: Constants.tokenAPIURL) else {
                return Fail(error: AuthenticationError.loginRequired)
                    .eraseToAnyPublisher()
            }
            
            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "grant_type", value: "refresh_token"),
                URLQueryItem(name: "refresh_token", value: refreshToken)
            ]
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = components.query?.data(using: .utf8)
            request.timeoutInterval = 30
            
            let basicToken = Constants.clientID + ":" + Constants.clientSecret
            let data = basicToken.data(using: .utf8)

            guard let base64String = data?.base64EncodedString() else {
                return Fail(error: AuthenticationError.loginRequired)
                    .eraseToAnyPublisher()
            }

            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
                        
            let publishers = URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { result in
                    guard let httpResponse = result.response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        let error = try JSONDecoder().decode(SerivceError.self, from: result.data)
                        throw error
                    }
                    
                    return result.data
                }
                .decode(type: AuthResponse.self, decoder: JSONDecoder())
                .handleEvents(receiveOutput: { result in
                    self.cacheToken(result: result)
                }, receiveCompletion: { _ in
                    DispatchQueue(label: self.accessToken!).sync {
                        self.refreshPublisher = nil
                    }
                })
                .tryMap({ response in
                    return response.access_token
                })
                .eraseToAnyPublisher()
            
            self.refreshPublisher = publishers
            return publishers
            
        }
    }
    
}

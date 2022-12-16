//
//  UserProfile.swift
//  Spotify
//
//  Created by Amini on 25/12/21.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
    let id: String
    let product: String
    let images: [APIImage]
    
}

class UserCache {
    static let shared = UserCache()
    
    private init() {
    }
    
    public func saveUser(profile: UserProfile) {
        if let encode = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encode, forKey: "user_profile")
        }
    }
    
    public func getUser() -> UserProfile? {
        if let decode = UserDefaults.standard.object(forKey: "user_profile") as? Data,
           let profile = try? JSONDecoder().decode(UserProfile.self, from: decode)
        {
            return profile
        }
        return nil
    }
}

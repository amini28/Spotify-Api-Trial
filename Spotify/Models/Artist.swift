//
//  Artist.swift
//  Spotify
//
//  Created by Amini on 25/12/21.
//

import Foundation

struct Artist: Codable{
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
    let followers: Followers?
    let genres: [String]?
    let popularity: Int?
}

struct Followers: Codable {
    let total: Int
}

//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by Amini on 02/01/22.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable{
    let items: [Album]
}

struct Album: Codable{
    let name: String
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [APIImage]
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
}


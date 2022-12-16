//
//  AlbumDetailsResponse.swift
//  Spotify
//
//  Created by Amini on 12/01/22.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let external_ids: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse
    let popularity: Int
    let href: String
    
}

struct TracksResponse: Codable{
    let items: [AudioTrack]
}

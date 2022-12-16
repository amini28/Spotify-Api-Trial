//
//  Playlist.swift
//  Spotify
//
//  Created by Amini on 25/12/21.
//

import Foundation

struct Playlist: Codable{
    let description: String
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}

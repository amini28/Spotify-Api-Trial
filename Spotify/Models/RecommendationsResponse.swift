//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by Amini on 02/01/22.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}

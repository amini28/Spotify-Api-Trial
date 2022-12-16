//
//  SearchResult.swift
//  Spotify
//
//  Created by Amini on 15/01/22.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}

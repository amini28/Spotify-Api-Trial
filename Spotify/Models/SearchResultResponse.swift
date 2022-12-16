//
//  SearchResultResponse.swift
//  Spotify
//
//  Created by Amini on 14/01/22.
//

import Foundation

struct SearchResultResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsReponse
    let tracks: SearchTracksReponse
}

struct SearchAlbumResponse: Codable{
    let items: [Album]
    
}

struct SearchArtistsResponse: Codable{
    let items: [Artist]
}

struct SearchPlaylistsReponse: Codable{
    let items: [Playlist]
}

struct SearchTracksReponse: Codable{
    let items: [AudioTrack]
}

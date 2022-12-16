//
//  AlbumService.swift
//  Spotify
//
//  Created by Amini on 30/10/22.
//

import Foundation
import Combine
import UIKit

public enum HTTPMethod: String {
    case GET
    case POST
}

protocol DataRoute {
    var route: String { get }
    var httpMethod: HTTPMethod { get }
}

extension DataRoute {
    
    var url: String {
        return APIRoute.spotify.baseURL + route
    }
    
    func publisher<T>() -> AnyPublisher<T, Error> where T : Decodable {
        return APIService.getWithValidToken(for: URL(string: url)!)
    }
}

enum UserProfileData: DataRoute {
    case current
    case users(id: String)
    
    var route: String {
        switch self {
        case .current:
            return "me"
        case .users(let id):
            return "users/\(id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
}

enum AlbumData: DataRoute {
    case Several
    case Album(id: String)
    case AlbumTracks(id: String)
    
    var route: String {
        switch self {
        case .Several:
            return "albums"
            
        case .Album(let id):
            return "albums/\(id)"
            
        case .AlbumTracks(let id):
            return "albums/\(id)/tracks"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .Several, .Album, .AlbumTracks:
            return .GET
        }
    }

}

enum RecommendationData: DataRoute {
    case RecommendationGenres(genres: Set<String>)
    case AvailableGenres
    
    var route: String {
        switch self {
        case .RecommendationGenres(let genres):
            let seeds = genres.joined(separator: ",")
            return "recommendations?limit=20&seed_genres=\(seeds)"
        case .AvailableGenres:
            return "recommendations/available-genre-seeds"

        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .RecommendationGenres, .AvailableGenres:
            return .GET
        }
    }
}

enum PlaylistsData: DataRoute {
    case User
    case Featured
    case NewReleases
    
    var route: String {
        switch self {
        case .User:
            return "me/playlists"
        case .Featured:
            return "browse/featured-playlists"
            
        case .NewReleases:
            return "browse/new-releases?limit=20"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .User, .Featured, .NewReleases:
            return .GET
        }
    }
}

enum CategoriesData: DataRoute {
    case Browse
    case Playlists(category: Category)
    
    var route: String {
        switch self {
        case .Browse:
            return "browse/categories?limit=10"
        case .Playlists(let category):
            return "browse/categories/\(category.id)/playlists"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .Browse, .Playlists:
            return .GET
        }
    }
}

enum ArtistData: DataRoute {
    case ArtistAlbum(id: String)
    case ArtistRelated(id: String)
    case ArtistTopTracks(id: String)
    case Artist(id: String)
    case SeveralArtist
    
    var route: String {
        switch self {
        case .ArtistAlbum(let id):
            return "artists/\(id)/albums"
        case .ArtistRelated(let id):
            return "artists/\(id)/related-artist"
        case .ArtistTopTracks(let id):
            return "artists/\(id)/top-tracks"
        case .Artist(let id):
            return "artists/\(id)"
        case .SeveralArtist:
            return "artists"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
}

enum TracksData: DataRoute {
    case AudioAnalysis(id: String)
    case AudioFeatures(id: String = "")
    case SeveralTracks
    case Tracks(id: String)
    
    var route: String {
        switch self {
        case .AudioAnalysis(let id):
            return "audio-analysis/\(id)"
        case .AudioFeatures(let id):
            return "audio-features/\(id)"
        case .SeveralTracks:
            return "tracks/\(UserCache.shared.getUser()?.id ?? "")"
        case .Tracks(let id):
            return "tracks/\(id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
}

enum PlayerData: DataRoute {
    case RecentlyPlayed
    
    var route: String {
        switch self {
        case .RecentlyPlayed:
            return "me/player/recently-played"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
}

enum ServiceErrorMessage: String, Decodable, Error {
    case invalidToken = "invalid_token"
}

struct ServiceError: Decodable, Error {
    let errors: [ServiceErrorMessage]
}

//
//  HomeViewModel.swift
//  Spotify
//
//  Created by Amini on 08/11/22.
//

import Foundation
import UIKit
import Combine

class HomeViewModel: ObservableObject {
    
    enum HomeSectionType {
        case highlight
        case playlist
        case newRelease
        case recomendedGenres
        case featuredPlaylist
        
        var size: CGSize {
            switch self {
            case .highlight: return CGSize(width: UIScreen.main.bounds.width - 16, height: 150)
            case .playlist: return CGSize(width: 125, height: 170)
            case .newRelease: return CGSize(width: 100, height: 150)
            case .recomendedGenres: return CGSize(width: 100, height: 150)
            case .featuredPlaylist: return CGSize(width: 100, height: 150)
            }
        }
        
        var title: String {
            switch self {
            case .highlight: return ""
            case .playlist: return "Your Playlist"
            case .newRelease: return "New Release"
            case .recomendedGenres: return "Recommendation Tracks"
            case .featuredPlaylist: return "Featured Playlist"
            }
        }
        
    }
    
    @Published var severalTracks: [PlaylistItem] = []
    @Published var playlist: [Playlist] = []
    @Published var newRelease: [Album] = []
    @Published var recomendedGenres: [AudioTrack] = []
    @Published var featuredPlaylist: [Playlist] = []
    
    private(set) var sections: [HomeSectionType] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSection()
    }
    
    private func setupSection() {
        sections.append(.highlight)
        sections.append(.playlist)
        sections.append(.newRelease)
        sections.append(.recomendedGenres)
        sections.append(.featuredPlaylist)
    }
    
    private func getSeveralTracks() {
        PlayerData.RecentlyPlayed.publisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                case .finished:
                    return
                }
            }, receiveValue: { [weak self] (recomendation: PlaylistTracksResponse) in
                print(recomendation)
                self?.severalTracks = recomendation.items
            })
            .store(in: &cancellables)
    }
    
    private func getFeaturedPlaylist() {
        PlaylistsData.Featured.publisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                case .finished:
                    return
                }
            }, receiveValue: { [weak self] (featured: FeaturedPlaylistsResponse) in
                self?.featuredPlaylist = featured.playlists.items
            })
            .store(in: &cancellables)
    }
    
    private func getRecommenndationPlaylist() {
        RecommendationData.AvailableGenres.publisher()
            .flatMap({ (recommendation: RecomendedGenresResponse) -> AnyPublisher<RecommendationsResponse, Error> in
                let genres = recommendation.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                return RecommendationData.RecommendationGenres(genres: seeds).publisher()
            })
            .sink(receiveCompletion: { complete in
                print(complete)
            }, receiveValue: { [weak self] (recomendation: RecommendationsResponse) in
                self?.recomendedGenres = recomendation.tracks
            })
            .store(in: &cancellables)
    }
        
    private func getUserPlaylist() {
        PlaylistsData.User.publisher()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                case .finished:
                    return
                }
            }, receiveValue: { [weak self] (play: PlaylistResponse) in
                self?.playlist = play.items
            })
            .store(in: &cancellables)
        
    }
    
    private func getNewRelease() {
        PlaylistsData.NewReleases.publisher()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                case .finished:
                    return
                }
            }, receiveValue: { [weak self] (newRelease: NewReleasesResponse) in
                self?.newRelease = newRelease.albums.items
            })
            .store(in: &cancellables)
        
    }
    
}


// MARK: - Public Functions
extension HomeViewModel {
    
    var numberOfSections: Int {
        sections.count
    }
    
    func getAllCollectionData() {
        getSeveralTracks()
        getNewRelease()
        getUserPlaylist()
        getRecommenndationPlaylist()
        getFeaturedPlaylist()
    }
    
    func cellForSection(for section: Int) -> HomeSectionType {
        return sections[section]
    }
    
    func indexType(for section: HomeSectionType) -> Int {
        return sections.firstIndex { $0 == section } ?? 0
    }
    
    func numberOfItem(for section: Int) -> Int {
        switch cellForSection(for: section) {
        case .highlight: return 1
        case .playlist: return playlist.count
        case .newRelease: return newRelease.count
        case .featuredPlaylist: return featuredPlaylist.count
        case .recomendedGenres: return recomendedGenres.count
        }
    }
}

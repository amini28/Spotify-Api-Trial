//
//  AlbumViewModel.swift
//  Spotify
//
//  Created by Amini on 08/11/22.
//

import Foundation
import UIKit
import Combine

class AlbumViewModel: ObservableObject {
    
    enum AlbumSectionType {
        case cover
        case profile
        case song_list
        case related_album
        
        var size: CGSize {
            switch self {
            case .cover: return CGSize(width: UIScreen.main.bounds.width - 16, height: 300)
            case .profile: return CGSize(width: UIScreen.main.bounds.width - 16, height: 64)
            case .song_list: return CGSize(width: UIScreen.main.bounds.width - 16, height: 100)
            case .related_album: return CGSize(width: 60, height: 60)
            }
        }
    }
    
    @Published var albumDetails: AlbumDetailsResponse?
    @Published var artistDetails: Artist?
    @Published var artistAlbums: [Album] = []
    
    private var album: Album
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var sections: [AlbumSectionType] = []
    
    init(album: Album){
        self.album = album

        self.getAlbumDetails(albumID: album.id)
        self.getArtist(artistID: album.artists.first?.id ?? "")
        self.getAritstAlbums(artist: album.artists.first?.id ?? "")
        self.setupSection()
    }
    
    private func setupSection() {
        sections.append(.cover)
        sections.append(.profile)
        sections.append(.song_list)
        sections.append(.related_album)
    }
    
    private func getAritstAlbums(artist id: String) {
        ArtistData.ArtistAlbum(id: id).publisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {(completion) in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                case .finished:
                    return
                }
            }, receiveValue: {[weak self] (albums: AlbumsResponse) in

                self?.artistAlbums = albums.items
            })
            .store(in: &cancellables)
    }
    
    private func getAlbumDetails(albumID: String) {
        AlbumData.Album(id: albumID).publisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                case .finished:
                    return
                }
            }, receiveValue: { [weak self] (album: AlbumDetailsResponse) in
                self?.albumDetails = album
            })
            .store(in: &cancellables)
    }
    
    private func getArtist(artistID: String) {
        if artistID != "" {
            ArtistData.Artist(id: artistID).publisher()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .failure(let error):
                        print(error)
                        return
                    case .finished:
                        return
                    }
                }, receiveValue: { [weak self] (artist: Artist) in
                    self?.artistDetails = artist
                })
                .store(in: &cancellables)
        }
    }
    
}

// MARK: - public function
extension AlbumViewModel {
    
    var albumName: String {
        return album.name
    }
    
    var albumCover: String? {
        return album.images.first?.url
    }
    
    var artistName: String? {
        return artistDetails?.name
    }
    
    // first have to get artist profile
    var artistImage: String? {
        return artistDetails?.images?.first?.url
    }
    
    var albumYearRelease: String {
        return album.release_date
    }
    
    var albumType: String {
        return album.album_type
    }
    
    var tracks: [AudioTrack]? {
        return albumDetails?.tracks.items
    }
    
    var numberOfSections: Int {
        return sections.count
    }
    
    func numberOfItemInSection(_ section: Int) -> Int {
        switch cellForSection(for: section) {
        case .cover: return 1
        case .profile: return 1
        case .song_list: return tracks?.count ?? 0
        case .related_album : return artistAlbums.count
        }
    }
    
    func cellForSection(for section: Int) -> AlbumSectionType {
        return sections[section]
    }
    
    
}

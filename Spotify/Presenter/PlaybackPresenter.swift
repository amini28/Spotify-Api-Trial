//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Amini on 15/01/22.
//

import AVFoundation
import UIKit

protocol PlayDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        }
        else if let player = self.playerQueue,  !tracks.isEmpty {
            let item = player.currentItem
            let items = player.items()
            guard let index = items.firstIndex(where: { $0 == item }) else {
                return nil
            }
            return tracks[index]
        }
        
        return nil
    }
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    func startPlayback(from viewController: UIViewController, track: AudioTrack){
        self.track = track
        self.tracks = []
        
//        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
//            guard let url = URL(string: $0.preview_url!)
//            else {
//                return nil
//            }
//            return AVPlayerItem(url: url)
//        }))
//
//        self.playerQueue?.volume = 0
//        self.playerQueue?.play()
        
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]){
        self.tracks = tracks
        self.track = nil

        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.preview_url!)
            else {
                return nil
            }
            return AVPlayerItem(url: url)
        }))
        
        self.playerQueue?.volume = 5
        self.playerQueue?.play()
        
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self

        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        
        viewController.present(navigationController, animated: true, completion: nil)
    }
    
    func startPlayback(from viewController: UIViewController, album: Album){
        
    }
    
    func startPlayback(from viewController: UIViewController, playlist: Playlist){
        
    }
}

extension PlaybackPresenter: PlayDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            // not playlist or album
            player?.pause()
            player?.play()
        }
        else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0
        }
    }
    
    func didTapBackwards() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        }
        else if let player = playerQueue{
            player.advanceToNextItem()
        }
    }
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    
}

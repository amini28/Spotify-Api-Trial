//
//  ListPlayView.swift
//  Spotify
//
//  Created by Amini on 09/11/22.
//

import Foundation
import UIKit
import Combine

class ListPlayView: UIView {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var coverImage: UIImageView = {
        let coverImage = UIImageView()
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        coverImage.image = UIImage(named: "cover")
        coverImage.contentMode = .scaleAspectFit
        return coverImage
    }()
    
    private lazy var playImage: UIImageView = {
        let playImage = UIImageView()
        playImage.translatesAutoresizingMaskIntoConstraints = false
        playImage.image = UIImage(systemName: "play.circle.fill")
        playImage.tintColor = .white
        playImage.contentMode = .scaleAspectFit
        return playImage
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var playlist: Playlist?
    private var track: AudioTrack?
    private var album: Album?

    public let didTapPlay = PassthroughSubject<String, Never>()

    init() {
        super.init(frame: .zero)
        setupViews()
        playImage.isUserInteractionEnabled = true
        playImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapPlay)))
    }
    
    @objc private func handleTapPlay() {
        didTapPlay.send("hallo")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraint()
    }
    
    private func setupViews() {
        
        coverImage.contentMode = .scaleAspectFit
        coverImage.layer.cornerRadius = 16
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        addSubview(containerView)
        containerView.addSubview(coverImage)
        containerView.addSubview(titleLabel)
        containerView.addSubview(playImage)
        
    }

    private func setupConstraint() {
                
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        }
        
        coverImage.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.width.equalTo(coverImage.snp.height)
        }
        
        playImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-4)
            make.centerY.equalToSuperview()
            make.height.equalTo(containerView.snp.height).multipliedBy(0.5)
            make.width.equalTo(playImage.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(coverImage)
            make.left.equalTo(coverImage.snp.right).offset(4)
            make.right.equalTo(playImage.snp.left).offset(-4)
        }
        
    }
    
    private func setupLabel(title: String, description: String) {
        let todaysText = NSAttributedString(string: title,
                                            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                                         .foregroundColor: UIColor.white])
        let highlightText = NSAttributedString(string: "\n\(description)",
                                               attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .light),
                                                            .foregroundColor: UIColor.white])
        
        let attributedStrings: NSMutableAttributedString = NSMutableAttributedString(string: "")
        attributedStrings.append(todaysText)
        attributedStrings.append(highlightText)
        
        titleLabel.attributedText = attributedStrings
    }
}

extension ListPlayView {
        
    public func configure(track: AudioTrack) {
        self.track = track
        
        if let coverURL = track.album?.images.first?.url {
            coverImage.sd_setImage(with: URL(string: coverURL), placeholderImage: UIImage(named: "cover"))
        }
        titleLabel.text = track.name
        if let artistName = track.artists.first?.name {
            setupLabel(title: track.name, description: artistName)
        }
    }
    
    public func configure(playlist: Playlist) {
        self.playlist = playlist
        
        if let coverURL = playlist.images.first?.url {
            coverImage.sd_setImage(with: URL(string: coverURL), placeholderImage: UIImage(named: "cover"))
        }
        setupLabel(title: playlist.name, description: playlist.description)
    }
    
    public func configure(album: Album) {
        self.album = album
        
        if let coverURL = album.images.first?.url {
            coverImage.sd_setImage(with: URL(string: coverURL), placeholderImage: UIImage(named: "cover"))
        }
        setupLabel(title: album.name, description: album.album_type)
    }
}

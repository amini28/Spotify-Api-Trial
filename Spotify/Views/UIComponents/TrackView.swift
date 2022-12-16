//
//  TrackView.swift
//  Spotify
//
//  Created by Amini on 19/10/22.
//

import Foundation
import UIKit

enum TrackEnum {
    case thumbnail
    case disc
}

class TrackView: UIView {
    
    private lazy var coverImage: UIImageView = {
        let coverImage = UIImageView()
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        coverImage.image = UIImage(named: "cover")
        return coverImage
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var maskingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.7)
        return view
    }()
    
    private var type: TrackEnum
    
    init(type: TrackEnum) {
        self.type = type
        super.init(frame: .zero)
        setupViews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        switch type {
        case .thumbnail:
            coverImage.layer.cornerRadius = 10
            coverImage.layer.masksToBounds = true
            maskingView.layer.cornerRadius = 10
            maskingView.layer.masksToBounds = true

        case .disc:
            coverImage.rounded()
            maskingView.rounded()
        }
    }
    
    private func setupViews() {
        
        coverImage.contentMode = .scaleAspectFit
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = .white
        
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = .white
        
        maskingView.isHidden = true
        
        addSubview(coverImage)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(maskingView)
        
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            coverImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            coverImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            coverImage.aspectRatio(1.0),

            maskingView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            maskingView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            maskingView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            maskingView.aspectRatio(1.0),

            titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 4),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
            subtitleLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 0)
        ])
        
    }
}

extension TrackView {
    public func setType(type: TrackEnum) {
        self.type = type
    }
    
    public func configure(track: AudioTrack) {
        if let coverURL = track.album?.images.first?.url {
            coverImage.sd_setImage(with: URL(string: coverURL), placeholderImage: UIImage(named: "cover"))
        }
                
        titleLabel.text = track.name
        
        if let artistName = track.artists.first?.name {
            subtitleLabel.text = artistName
        }
        
        if track.preview_url == nil {
            maskingView.isHidden = false
            titleLabel.textColor = .systemGray
            subtitleLabel.textColor = .systemGray
        }

    }
    
    public func configure(artist: Artist) {
        if let imageURL = artist.images?.first?.url {
            coverImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "cover"))
        }
        titleLabel.text = artist.name
        subtitleLabel.isHidden = true
    }
    
    public func configure(playlist:  Playlist) {
        if let imageURL = playlist.images.first?.url {
            coverImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "cover"))
        }
        titleLabel.text = playlist.name
        subtitleLabel.text = playlist.owner.display_name
    }
    
    public func configure(album: Album) {
        coverImage.sd_setImage(with: URL(string: album.images[0].url), placeholderImage: UIImage(named: "cover"))
        titleLabel.text = album.name
        subtitleLabel.text = album.album_type
    }
    
    public func configurePrepareForReuse() {
        coverImage.sd_cancelCurrentImageLoad()
        coverImage.image = nil
        titleLabel.text = ""
        subtitleLabel.text = ""
    }
}


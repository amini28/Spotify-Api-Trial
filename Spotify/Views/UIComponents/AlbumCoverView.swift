//
//  AlbumCoverView.swift
//  Spotify
//
//  Created by Amini on 13/11/22.
//

import Foundation
import UIKit
import SnapKit

class AlbumCoverView: UIView {
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .black.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    private lazy var coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "cover")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
        
    private lazy var albumNameLabel: UILabel = {
        let albumLabel = UILabel()
        albumLabel.translatesAutoresizingMaskIntoConstraints = false
        albumLabel.text = "Stupid Love"
        albumLabel.textColor = .white
        albumLabel.font = .systemFont(ofSize: 19, weight: .bold)
        return albumLabel
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let artistLabel = UILabel()
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.text = "Lady Gaga"
        artistLabel.textColor = .white
        artistLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        return artistLabel
    }()
    
    private lazy var buttonPlay: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "play.circle.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupViews() {
        addSubview(coverImage)
        addSubview(containerView)
        containerView.addSubview(albumNameLabel)
        containerView.addSubview(artistNameLabel)
        containerView.addSubview(buttonPlay)
    }
    
    private func setupConstraint() {
        
        coverImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(coverImage.snp.height)
        }
        
        containerView.snp.makeConstraints { make in
            make.bottom.equalTo(coverImage.snp.bottom).offset(0)
            make.height.equalTo(coverImage.snp.height).multipliedBy(0.35)
            make.right.equalTo(coverImage.snp.right).offset(0)
            make.left.equalTo(coverImage.snp.left).offset(0)
        }
        
        buttonPlay.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(64)
        }
        
        albumNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(8)
            make.right.equalTo(buttonPlay.snp.left)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(albumNameLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(8)
            make.right.equalTo(buttonPlay.snp.left)
            make.bottom.equalToSuperview().offset(-4)
        }
                
    }
}

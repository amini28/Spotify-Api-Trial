//
//  RecomendedTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Amini on 03/01/22.
//

import Foundation
import UIKit

class RecomendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecomendedTrackCollectionViewCell"
    
    private let albumCoverIamgeView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverIamgeView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        albumCoverIamgeView.frame = CGRect(
//            x: 5,
//            y: 3,
//            width: width,
//            height: contentView.height - 10
//        )
//        
//        artistNameLabel.frame = CGRect(
//            x: albumCoverIamgeView.right + 10,
//            y: contentView.height/2,
//            width: contentView.width - albumCoverIamgeView.right - 15,
//            height: contentView.height/2
//        )
//        
//        trackNameLabel.frame = CGRect(
//            x: albumCoverIamgeView.right + 10,
//            y: contentView.height - 44,
//            width: contentView.width - albumCoverIamgeView.right - 15,
//            height: 44
//        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        albumCoverIamgeView.image = nil
        artistNameLabel.text = nil
    }
    
//    func configure(with viewModel: RecomendedTrackCellViewModel){
//        
//        trackNameLabel.text = viewModel.name
//        albumCoverIamgeView.sd_setImage(with: viewModel.artworkURL, completed: nil)
//        artistNameLabel.text = viewModel.artistName
//    }
}

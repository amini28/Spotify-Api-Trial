//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by Amini on 13/01/22.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GenreCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.tintColor = .white

        return imageview
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemPurple,
        .systemGray,
        .systemGreen,
        .systemBlue,
        .systemYellow,
        .systemRed
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        backgroundColor = .systemPurple
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        label.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width-20, height: contentView.height/2)
//        imageView.frame = CGRect(x: contentView.width/2, y: 0, width: contentView.width/2, height: contentView.height/2)
    }
    
//    func configure(with viewModel: CategoryCollectionViewCellViewModel){
//        label.text = viewModel.title
//        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
//        contentView.backgroundColor = colors.randomElement()
//    }
    
}

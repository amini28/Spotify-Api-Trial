//
//  FloatPlayerControlView.swift
//  Spotify
//
//  Created by Amini on 06/12/22.
//

import UIKit
import SnapKit

class FloatPlayerControlView: UIView {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var coverImage: UIImageView = {
        let coverImage = UIImageView()
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        coverImage.image = UIImage(named: "cover")
        return coverImage
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
        
    private lazy var controlButton: UIImageView = {
        let playeImage = UIImageView()
        playeImage.translatesAutoresizingMaskIntoConstraints = false
        playeImage.image = UIImage(systemName: "play.circle.fill")
        playeImage.tintColor = .white
        playeImage.contentMode = .scaleAspectFit
        return playeImage
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    private func setupViews() {
        
        coverImage.contentMode = .scaleAspectFit
        coverImage.layer.cornerRadius = 16
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.text = "Rock n Roll"
        
        addSubview(containerView)
        containerView.addSubview(coverImage)
        containerView.addSubview(titleLabel)
        containerView.addSubview(controlButton)
        
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
        
        controlButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-4)
            make.centerY.equalToSuperview()
            make.height.equalTo(containerView.snp.height).multipliedBy(0.5)
            make.width.equalTo(controlButton.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(coverImage)
            make.left.equalTo(coverImage.snp.right).offset(4)
            make.right.equalTo(controlButton.snp.left).offset(-4)
        }
        
    }
}

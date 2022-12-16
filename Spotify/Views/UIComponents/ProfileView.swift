//
//  ProfileView.swift
//  Spotify
//
//  Created by Amini on 08/11/22.
//

import Foundation
import UIKit
import SnapKit

class ProfileView: UIView {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
        
    private lazy var nameLabel: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .white
        return name
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private var name: String
    private var imageURL: String

    init(name: String = "", image url: String = "") {
        self.name = name
        self.imageURL = url
        super.init(frame: .zero)
        configureViews()
    }
    
    public func configure(name: String, image url: String) {
        self.name = name
        self.imageURL = url
        configureViews()
    }
    
    public func configure(name: String) {
        self.name = name
        configureViews()
    }
    
    public func configure(image url: String) {
        self.imageURL = url
        configureViews()
    }
    
    private func configureViews() {
        image.sd_setImage(with: URL(string: imageURL))
        nameLabel.text = name
    }
    
    override func layoutSubviews() {
        setupConstraint()
    }
    
    private func setupConstraint() {
        addSubview(containerView)
        containerView.addSubview(image)
        containerView.addSubview(nameLabel)
            
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        }
        
        image.snp.makeConstraints { make in
            make.left.equalTo(containerView.snp.left).offset(4)
            make.top.equalTo(containerView.snp.top).offset(4)
            make.bottom.equalTo(containerView.snp.bottom).offset(-4)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(4)
            make.left.equalTo(image.snp.right).offset(4)
            make.centerY.equalTo(image.snp.centerY)
            make.right.equalTo(containerView.snp.right).offset(-4)
        }
        
        NSLayoutConstraint.activate([
            image.aspectRatio(1.0)
        ])
        image.rounded()
        
    }
}

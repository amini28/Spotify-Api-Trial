//
//  NavigationBarPlayerView.swift
//  Spotify
//
//  Created by Amini on 06/12/22.
//

import UIKit

class NavigationBarPlayerView: UIView {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        return stackView
    }()
    
    public var collapseButton: UIImageView = {
        let collapseButton = UIImageView()
        collapseButton.translatesAutoresizingMaskIntoConstraints = false
        collapseButton.image = UIImage(systemName: "chevron.down")
        collapseButton.contentMode = .scaleAspectFit
        collapseButton.tintColor = .white
        return collapseButton
    }()
    
    public var optionButton: UIImageView = {
        let optionButton = UIImageView()
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        optionButton.image = UIImage(systemName: "ellipsis")
        optionButton.contentMode = .scaleAspectFit
        optionButton.tintColor = .white
        return optionButton
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        label.text = "Judul Lagu"
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupConstraint() {
        addSubview(containerView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(collapseButton)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(optionButton)
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            collapseButton.widthAnchor.constraint(equalToConstant: 24),
            
            optionButton.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
        
}

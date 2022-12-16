//
//  HighlightsView.swift
//  Spotify
//
//  Created by Amini on 06/10/22.
//

import UIKit
import Foundation

class HighlightsView: UIView {
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var highlightContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelStacks: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private var items: [PlaylistItem] = []
    
    init() {
        super.init(frame: .zero)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let highlightWidth = 0.3*UIScreen.main.bounds.width
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant : -8),
            
            highlightContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            highlightContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            highlightContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),
            highlightContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: highlightWidth),
            
            labelStacks.topAnchor.constraint(equalTo: containerView.topAnchor),
            labelStacks.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            labelStacks.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            labelStacks.trailingAnchor.constraint(equalTo: highlightContainerView.leadingAnchor, constant: 8)
        ])


    }
    
    private func configureViews() {
        addSubview(containerView)
        addSubview(highlightContainerView)
        addSubview(labelStacks)
        
        
        containerView.backgroundColor = .white.withAlphaComponent(0.9)
        containerView.layer.cornerRadius = 10
                
        generateLabelStacks()
        generateHighlightsView()
    }
        
    private func generateLabelStacks() {
        let labelTop = UILabel()
        labelTop.translatesAutoresizingMaskIntoConstraints = false
        labelTop.font = .systemFont(ofSize: 14, weight: .regular)
        labelTop.sizeToFit()
        labelTop.numberOfLines = 2
        labelTop.text = ""
                
        labelStacks.addArrangedSubview(labelTop)
        
        let todaysText = NSAttributedString(string: "Todays", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        let highlightText = NSAttributedString(string: "\nHighlights", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)])
        
        let attributedStrings: NSMutableAttributedString = NSMutableAttributedString(string: "")
        attributedStrings.append(todaysText)
        attributedStrings.append(highlightText)
        
        labelTop.attributedText = attributedStrings
    }
    
    private func generateHighlightsView() {
        var lastFrame: [CGRect] = []
        for view in highlightContainerView.subviews {
            view.removeFromSuperview()
        }

        let spacing = 8.0
        let numberofSongs = 6
                
        for index in 0..<numberofSongs {
            let radius = randomRadius(max: (0.7*(UIScreen.main.bounds.width))*0.33)

            let imageView = UIImageView(image: UIImage(named: "vynil"))
            
            if items.count > 0 {
                if let imageURL = items[index].track.album?.images.first?.url {
                    imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "vynil"))
                }
            }
            
            imageView.contentMode = .scaleToFill

            if index < Int(numberofSongs / 2) {

                let frameRect = CGRect(x: index == 0 ? 0 : lastFrame[index-1].maxX + spacing,
                                       y: randomY(),
                                       width: radius,
                                       height: radius)
                
                imageView.frame = frameRect
                imageView.layer.cornerRadius = radius*0.5
                imageView.layer.masksToBounds = true
                
                lastFrame.append(frameRect)

            } else {
                
                let frameRect = CGRect(x: index == Int(numberofSongs / 2) ? 0 : lastFrame[index-1].maxX,
                                       y: lastFrame[index-Int(numberofSongs / 2)].maxY + spacing,
                                       width: radius,
                                       height: radius)
                imageView.frame = frameRect
                imageView.layer.cornerRadius = radius*0.5
                imageView.layer.masksToBounds = true

                lastFrame.append(frameRect)
            }
            
            highlightContainerView.addSubview(imageView)
        }
    }
    
    private func randomRadius(max: CGFloat = 75) -> CGFloat {
        return CGFloat.random(in: 40..<max)
    }
    
    private func randomY() -> CGFloat {
        return CGFloat.random(in: 0..<16)
    }
}

extension HighlightsView {
    
    public func configure(items: [PlaylistItem]) {
        self.items = items
        generateHighlightsView()
    }
}


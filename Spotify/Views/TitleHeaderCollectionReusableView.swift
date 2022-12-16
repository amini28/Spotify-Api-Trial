//
//  TitleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Amini on 13/01/22.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(label)
        
        label.frame = CGRect(x: 10, y: 0, width: self.bounds.width-20, height: self.bounds.height)
    }
    
    func configure(with title: String){
        label.text = title
    }
}

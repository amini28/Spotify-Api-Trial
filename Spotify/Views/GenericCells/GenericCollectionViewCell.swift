//
//  GenericCollectionViewCell.swift
//  Spotify
//
//  Created by Amini on 02/11/22.
//

import UIKit

class GenericCollectionViewCell<CellView: UIView>: UICollectionViewCell {
    
    public var cellView: CellView? {
        didSet {
            guard cellView != nil else { return }
            self.setupViews()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellView?.removeFromSuperview()
    }
        
}

private extension GenericCollectionViewCell {
    func setupViews() {
        guard  let cellView = self.cellView else { return }
        self.contentView.addSubview(cellView)
        self.contentView.preservesSuperviewLayoutMargins = false
        self.contentView.layoutMargins = .zero
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            cellView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor)
        ])

    }
    
}


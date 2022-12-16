//
//  GenericTableViewCell.swift
//  Spotify
//
//  Created by Amini on 02/11/22.
//

import UIKit

class GenericTableViewCell<View: UIView>: UITableViewCell {
    
    var cellView: View? {
        didSet {
            guard cellView != nil else { return }
            setupViews()
        }
    }
    
    private func setupViews() {
        guard let cellView = cellView else { return }
        
        addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellView.leftAnchor.constraint(equalTo: leftAnchor),
            cellView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .systemBackground
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

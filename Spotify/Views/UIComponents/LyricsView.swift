//
//  LyricsView.swift
//  Spotify
//
//  Created by Amini on 06/12/22.
//

import UIKit
import SnapKit

class LyricsView: UIView {
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Lyrics"
        return label
    }()
    
    private lazy var lyricsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Kapan terakhir kali kamu dapat tertidur tenang ?\n(Renggang)\nTak perlu memikirkan tentang apa yang akan datang\ndi esok hari\nTubuh yang berpatah hati"

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func configureViews() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(lyricsLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        lyricsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-32)
        }

    }
}

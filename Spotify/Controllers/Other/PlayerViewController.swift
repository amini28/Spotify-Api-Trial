//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Amini on 25/12/21.
//

import UIKit
import SDWebImage
import SnapKit

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackwards()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController, Expandable {
    
    var tabController: StickyViewController? {
        if let tabBarController = tabBarController as? StickyViewController {
            return tabBarController
        }
        return nil
    }
    
    private lazy var navigationBarPlayer: NavigationBarPlayerView = {
        let view = NavigationBarPlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .red
        return view
    }()
    
    private lazy var collapsedView: FloatPlayerControlView = {
        let view = FloatPlayerControlView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    var minimisedView: UIView {
        return collapsedView
    }
    

    weak var dataSource: PlayDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    private let vynilView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "disc")
        imageView.tintColor = .white.withAlphaComponent(0.5)
        return imageView
    }()
    
    private let coverImageView: UIImageView = {
        let coverImageView = UIImageView()
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.image = UIImage(named: "cover")
        coverImageView.layer.cornerRadius = 10
        coverImageView.layer.masksToBounds = true
        return coverImageView
    }()
    
    private let lyricsView: LyricsView = {
        let view = LyricsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    private let contentScroll: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let controlsView = PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(collapsedView)
        view.addSubview(navigationBarPlayer)
        view.addSubview(scrollView)

        scrollView.addSubview(contentScroll)
        contentScroll.addSubview(coverImageView)
        coverImageView.addSubview(vynilView)
        contentScroll.addSubview(controlsView)
        contentScroll.addSubview(lyricsView)

        collapsedView.backgroundColor = .black.withAlphaComponent(0.2)
        controlsView.delegate = self
            
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        vynilView.rotate()

        configureBarButtons()
//        configure()
        
        collapsedView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        navigationBarPlayer.snp.makeConstraints { make in
            make.top.equalTo(collapsedView.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarPlayer.snp.bottom).offset(0)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height - (50 + (self.tabController?.getHeight() ?? 49)))
        }
                
        contentScroll.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(UIScreen.main.bounds.width - 20)
        }
        
        vynilView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        controlsView.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(200)
        }
        
        lyricsView.snp.makeConstraints { make in
            make.top.equalTo(controlsView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(250)
            make.bottom.equalToSuperview().offset(-100)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configureBarButtons() {
        
        navigationBarPlayer.collapseButton.isUserInteractionEnabled = true
        navigationBarPlayer.collapseButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapClose)))

    }
    
    private func configure() {
        coverImageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
    }
    
    @objc private func didTapClose() {
        tabController?.collapseChild()
    }
    
    @objc private func didTapAction() {
        // Actions
    }

}

extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }

    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }

    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackwards()
    }
    
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
}

extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 3
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}

extension UITabBarController{

    func getHeight()->CGFloat{
        return self.tabBar.frame.size.height
    }

    func getWidth()->CGFloat{
         return self.tabBar.frame.size.width
    }
}

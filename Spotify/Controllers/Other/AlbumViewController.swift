//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Amini on 05/01/22.
//

import UIKit
import SnapKit
import Combine

class AlbumViewController: UIViewController {
    
    // buat nya sama kyk playlist view controller
    
    private lazy var collectionView = UICollectionView (frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let viewmodel: AlbumViewModel
    private var subscriptions = Set<AnyCancellable>()

    
    init(album: Album) {
        self.viewmodel = AlbumViewModel(album: album)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewmodel.albumName
        view.backgroundColor = .black

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
        observeData()
        setupViews()
        setupConstraint()
        configureCollectionView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraint() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
            
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(GenericCollectionViewCell<AlbumCoverView>.self)
        collectionView.register(GenericCollectionViewCell<ProfileView>.self)
        collectionView.register(GenericCollectionViewCell<ListPlayView>.self)
        collectionView.register(GenericCollectionViewCell<TrackView>.self)

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { [self] sectionIndex, _ -> NSCollectionLayoutSection? in
            
            return createSectionLayout(section: sectionIndex)
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        
        collectionView.backgroundColor = .clear
    }
    
    private func observeData() {
        viewmodel.$albumDetails.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewmodel.$artistDetails.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewmodel.$artistAlbums.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    @objc private func didTapShare() {
        
    }
    
}

extension AlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = viewmodel.cellForSection(for: indexPath.section)
        switch section {
        case .cover:break
        case .profile:break
        case .song_list:break
        case .related_album:
            let album = viewmodel.artistAlbums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension AlbumViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewmodel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewmodel.numberOfItemInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = viewmodel.cellForSection(for: indexPath.section)
        switch section {
        case .cover:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as GenericCollectionViewCell<AlbumCoverView>
            let view = AlbumCoverView()
            cell.cellView = view
            return cell
        case .profile:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as GenericCollectionViewCell<ProfileView>
            let view = ProfileView()
            
            if let artisName = viewmodel.artistName,
               let artistImage = viewmodel.artistImage {
                view.configure(name: artisName, image: artistImage)
            }
            cell.cellView = view
            return cell
        case .song_list:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as GenericCollectionViewCell<ListPlayView>
            let view = ListPlayView()
                        
            if let track = viewmodel.tracks {
                view.configure(track: track[indexPath.row])
            }
            
            view.didTapPlay.handleEvents(receiveOutput: {[unowned self] item in
                print(item)
            })
            .sink { _ in }
            .store(in: &subscriptions)
            
            cell.cellView = view
            return cell
            
        case .related_album:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as GenericCollectionViewCell<TrackView>
            let view = TrackView(type: .thumbnail)
            view.configure(album: viewmodel.artistAlbums[indexPath.row])
            cell.cellView = view
            return cell
        }
    }
        
}

extension AlbumViewController {
    private func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let section = viewmodel.cellForSection(for: section)

        switch section {
        case .song_list:
            let trackCount = viewmodel.tracks?.count ?? 1
            let height = CGFloat(trackCount) * section.size.height
            return createSection(with: CGSize(width: section.size.width, height: height), vertical: trackCount)
            
        case .profile, .cover: return createSection(with: section.size, vertical: 1)
        case .related_album : return createSectionHorizontalLayout()
        }
    }
    
    private func createSection(with size: CGSize, vertical: Int = 1, horizontal: Int = 1) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let vertical_group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(size.width), heightDimension: .absolute(size.height)),
                                               subitem: item,
                                               count: vertical)
        
        let horizontal_group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(size.width), heightDimension: .absolute(size.height)), subitem: vertical_group, count: horizontal)
        
        let section = NSCollectionLayoutSection(group: horizontal_group)
        section.orthogonalScrollingBehavior = .continuous

        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        return section
    }
    
    private func createSectionHorizontalLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140)), subitem: item, count: 4)
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
}

//
//  HomeViewController.swift
//  Spotify
//
//  Created by Amini on 24/12/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    
    private var subscriptions = Set<AnyCancellable>()

    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var tabController: StickyViewController? {
        if let tabController = tabBarController as? StickyViewController {
            return tabController
        }
        return nil
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        navigationItem.largeTitleDisplayMode = .never

        view.backgroundColor = .black
        
        configureActionBar()
        configureCollectionView()
             
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
        ])

    }
    
    private func configureActionBar() {
        let discImage = UIImage(named: "disc")
        let discView = UIImageView(image: discImage)
        discView.contentMode = .scaleAspectFit
        let discItem = UIBarButtonItem(customView: discView)
        discItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        discItem.customView?.heightAnchor.constraint(equalToConstant: 28).isActive = true
        discItem.customView?.widthAnchor.constraint(equalToConstant: 28).isActive = true
        
        let gearImage = UIImage(systemName: "gear")
        let gearView = UIImageView(image: gearImage)
        let gearItem = UIBarButtonItem(customView: gearView)
        gearItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        gearItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = false
        gearItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = false
        
        let clockImage = UIImage(systemName: "clock")
        let clockView = UIImageView(image: clockImage)
        let clockItem = UIBarButtonItem(customView: clockView)
        clockItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        clockItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = false
        clockItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = false
        
        let bellImage = UIImage(systemName: "bell")
        let bellView = UIImageView(image: bellImage)
        let bellItem = UIBarButtonItem(customView: bellView)
        bellItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        bellItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = false
        bellItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = false
        
        navigationItem.leftBarButtonItems = [
            discItem,
            UIBarButtonItem(title: "hi \(UserCache.shared.getUser()?.display_name ?? "__")", style: .done, target: nil, action: nil)
        ]
        navigationItem.rightBarButtonItems = [gearItem,
                                              clockItem,
                                              bellItem]
    }
    
    private func configureCollectionView(){
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .red
        
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.sectionHeadersPinToVisibleBounds = true
//        }
        
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.register(GenericCollectionViewCell<TrackView>.self)
        collectionView.register(GenericCollectionViewCell<HighlightsView>.self)
        
        collectionView.register(TitleHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { [self] sectionIndex, _ -> NSCollectionLayoutSection? in
            return createSectionLayout(section: sectionIndex)
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
    }
    
    private func fetchData(){
        
        viewModel.getAllCollectionData()
            
        viewModel.$severalTracks.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] items in
                self?.collectionView.reloadData()
            })
            .store(in: &subscriptions)
        
        
        viewModel.$playlist.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                print("complete")
            }, receiveValue: { [weak self] item in
//                let indexSet = IndexSet(integer: (self?.homeViewModel.indexType(for: .playlist))!)
//                self?.collectionView.reloadSections(indexSet)
                self?.collectionView.reloadData()

            })
            .store(in: &subscriptions)
        
        viewModel.$featuredPlaylist.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                print("complete")
            }, receiveValue: { [weak self] item in
//                let indexSet = IndexSet(integer: (self?.homeViewModel.indexType(for: .playlist))!)
//                self?.collectionView.reloadSections(indexSet)
                self?.collectionView.reloadData()

            })
            .store(in: &subscriptions)
        
        viewModel.$newRelease.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                print("complete")
            }, receiveValue: { [weak self] item in
//                let indexSet = IndexSet(integer: (self?.homeViewModel.indexType(for: .playlist))!)
//                self?.collectionView.reloadSections(indexSet)
                self?.collectionView.reloadData()

            })
            .store(in: &subscriptions)
        
        viewModel.$recomendedGenres.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                print("complete")
            }, receiveValue: { [weak self] item in
//                let indexSet = IndexSet(integer: (self?.homeViewModel.indexType(for: .playlist))!)
//                self?.collectionView.reloadSections(indexSet)
                self?.collectionView.reloadData()

            })
            .store(in: &subscriptions)
        
    }
        
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


// MARK: - Collection Data Source and Actions
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let section = viewModel.cellForSection(for: indexPath.section)
        header.configure(with: section.title)

        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = viewModel.cellForSection(for: indexPath.section)
        
        switch section {
        case .highlight:
            let playlist = viewModel.playlist[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .playlist:
            let playlist = viewModel.playlist[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .newRelease:
            let album = viewModel.newRelease[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .featuredPlaylist:
            let playlist = viewModel.playlist[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .recomendedGenres:
            let viewControllerToStick = PlayerViewController()
            tabController?.configureCollapseableChild(viewControllerToStick, isFullscreenOnFirstAppearance: false)
//            let track = viewModel.recomendedGenres[indexPath.row]
//            PlaybackPresenter.shared.startPlayback(from: self, tracks: [track])

            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItem(for: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = viewModel.cellForSection(for: indexPath.section)
        
        switch section {
        case .highlight:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as GenericCollectionViewCell<HighlightsView>
            let view = HighlightsView()
            view.configure(items: viewModel.severalTracks)
            cell.cellView = view
            return cell

        case .playlist:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as GenericCollectionViewCell<TrackView>
            let view = TrackView(type: .thumbnail)
            view.configure(playlist: viewModel.playlist[indexPath.row])
            cell.cellView = view
            return cell
            
        case .newRelease:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as GenericCollectionViewCell<TrackView>
            let view = TrackView(type: .thumbnail)
            view.configure(album: viewModel.newRelease[indexPath.row])
            cell.cellView = view
            return cell
            
        case .featuredPlaylist:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as GenericCollectionViewCell<TrackView>
            let view = TrackView(type: .thumbnail)
            view.configure(playlist: viewModel.featuredPlaylist[indexPath.row])
            cell.cellView = view
            return cell
            
        case .recomendedGenres:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as GenericCollectionViewCell<TrackView>
            let view = TrackView(type: .disc)
            let track = viewModel.recomendedGenres[indexPath.row]
            view.configure(track: track)
            cell.cellView = view
            return cell
        }
        
    }
    
}


// MARK: - Collection Compositional Section Layouting
extension HomeViewController {
    private func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let section = viewModel.cellForSection(for: section)
        
        let headerForTitle = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let supplementaryViewForTitle = [headerForTitle]
        let supplementaryViewForNoTitle = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                                                          heightDimension: .absolute(10)),
                                                                                       elementKind: UICollectionView.elementKindSectionHeader,
                                                                                       alignment: .top)]
        
        
        switch section {
        case .highlight:
            return createSection(with: supplementaryViewForNoTitle, item: section.size)
        case .playlist:
            return createSection(with: supplementaryViewForTitle, item: section.size)
        case .newRelease:
            return createSection(with: supplementaryViewForTitle, item: section.size)
        case .recomendedGenres:
            return createSection(with: supplementaryViewForTitle, item: section.size)
        case .featuredPlaylist:
            return createSection(with: supplementaryViewForTitle, item: section.size)

        }
        

    }
    
    private func createSection(with boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem], item size: CGSize) -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(size.width),
                                                                                                heightDimension: .absolute(size.height)),
                                                             subitem: item,
                                                             count: 1)
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(size.width),
                                                                                                    heightDimension: .absolute(size.height)),
                                                                 subitem: verticalGroup,
                                                                 count: 1)
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = boundarySupplementaryItems
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
//        section.decorationItems = [
//            NSCollectionLayoutDecorationItem.background(elementKind: "")
//        ]
        
        return section
        
    }
}


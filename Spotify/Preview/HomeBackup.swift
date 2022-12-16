//
////
////  HomeViewController.swift
////  Spotify
////
////  Created by Amini on 24/12/21.
////
//
//import UIKit
//import Combine
//
//enum BrowseSectionType{
//    case newReleases(viewModels: [NewReleasesCellViewModel]) //1
//    case featuredPlaylists(viewModels: [FeaturedPlyalistCellViewModel]) //2
//    case recomendedTracks(viewModels: [RecomendedTrackCellViewModel]) //3
//
//    var title: String {
//        switch self {
//        case .newReleases:
//            return "New Released Albums"
//        case .featuredPlaylists:
//            return "Featured Playlists"
//        case .recomendedTracks:
//            return "Recomended Tracks"
//
//        }
//    }
//}
//
//
//
//class HomeViewController: UIViewController {
//
//
//    private var newAlbums: [Album] = []
//    private var playlists: [Playlist] = []
//    private var tracks: [AudioTrack] = []
//
//    private var collectionView: UICollectionView = UICollectionView(
//        frame: .zero,
//        collectionViewLayout: UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
//            return HomeViewController.createSectionLayout(section: sectionIndex)
//    })
//
//    private let spinner: UIActivityIndicatorView = {
//        let spinner = UIActivityIndicatorView()
//        spinner.tintColor = .label
//        spinner.hidesWhenStopped = true
//        return spinner
//    }()
//
//    private var sections = [BrowseSectionType]()
//
//    private let modelService = AlbumService()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        title = ""
//        view.backgroundColor = .systemBackground
//
//        let discImage = UIImage(named: "disc")
//        let discView = UIImageView(image: discImage)
//        discView.contentMode = .scaleAspectFit
//        let discItem = UIBarButtonItem(customView: discView)
//        discItem.customView?.translatesAutoresizingMaskIntoConstraints = false
//        discItem.customView?.heightAnchor.constraint(equalToConstant: 28).isActive = true
//        discItem.customView?.widthAnchor.constraint(equalToConstant: 28).isActive = true
//
//        let gearImage = UIImage(systemName: "gear")
//        let gearView = UIImageView(image: gearImage)
//        let gearItem = UIBarButtonItem(customView: gearView)
//        gearItem.customView?.translatesAutoresizingMaskIntoConstraints = false
//        gearItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = false
//        gearItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = false
//
//        let clockImage = UIImage(systemName: "clock")
//        let clockView = UIImageView(image: clockImage)
//        let clockItem = UIBarButtonItem(customView: clockView)
//        clockItem.customView?.translatesAutoresizingMaskIntoConstraints = false
//        clockItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = false
//        clockItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = false
//
//        let bellImage = UIImage(systemName: "bell")
//        let bellView = UIImageView(image: bellImage)
//        let bellItem = UIBarButtonItem(customView: bellView)
//        bellItem.customView?.translatesAutoresizingMaskIntoConstraints = false
//        bellItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = false
//        bellItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = false
//
//        navigationItem.leftBarButtonItems = [
//            discItem,
//            UIBarButtonItem(title: "Have Fun", style: .done, target: nil, action: nil)
//        ]
//        navigationItem.rightBarButtonItems = [gearItem,
//                                              clockItem,
//                                              bellItem]
//
//        configureCollectionView()
//        view.addSubview(spinner)
//        fetchData()
//
//        modelService.getAlbum()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionView.frame = view.bounds
//    }
//
//    private func configureCollectionView(){
//
//        view.addSubview(collectionView)
//
//        collectionView.register(UICollectionViewCell.self,
//                                forCellWithReuseIdentifier: "cell")
//        collectionView.register(NewReleaseCollectionViewCell.self,
//                                forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
//        collectionView.register(FeaturedPlaylistCollectionViewCell.self,
//                                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
//        collectionView.register(RecomendedTrackCollectionViewCell.self,
//                                forCellWithReuseIdentifier: RecomendedTrackCollectionViewCell.identifier)
//        collectionView.register(TitleHeaderCollectionReusableView.self,
//                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//                                withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
//
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.backgroundColor = .systemBackground
//    }
//
//    private static func createSectionLayoutNewRelease (with boundarySupplementaryItems:[NSCollectionLayoutBoundarySupplementaryItem]) -> NSCollectionLayoutSection { // case 0
//
//        // Item
//        let item = NSCollectionLayoutItem(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1.0),
//                heightDimension: .fractionalHeight(1.0)
//            )
//        )
//        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
//
//        // Vertical group in horizontal group
//        let verticalGroup = NSCollectionLayoutGroup.vertical(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .absolute(250),
//                heightDimension: .absolute(250)
//            ),
//            subitem: item,
//            count: 3
//        )
//
//        // Group
//        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .absolute(250),
//                heightDimension: .absolute(250)
//            ),
//            subitem: verticalGroup,
//            count: 1
//        )
//
//        // Section
//        let section = NSCollectionLayoutSection(group: horizontalGroup)
//        section.orthogonalScrollingBehavior = .continuous
//        section.boundarySupplementaryItems = boundarySupplementaryItems
//
//        return section
//    }
//
//    private static func createSectionLayoutFeaturedPlaylists () -> NSCollectionLayoutSection { //case 1
//
//        // Item
//        let item = NSCollectionLayoutItem(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .absolute(150),
//                heightDimension: .absolute(150)
//            )
//        )
//        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
//
//        // Group
//        let verticalGroup = NSCollectionLayoutGroup.vertical(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .absolute(150),
//                heightDimension: .absolute(300)
//            ),
//            subitem: item,
//            count: 2
//        )
//
//        // Group
//        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .absolute(150),
//                heightDimension: .absolute(300)
//            ),
//            subitem: verticalGroup,
//            count: 1
//        )
//
//        // Section
//        let section = NSCollectionLayoutSection(group: horizontalGroup)
//        section.orthogonalScrollingBehavior = .continuous
//
//        return section
//    }
//
//    private static func createSectionLayoutrecomendedTracks () -> NSCollectionLayoutSection { //case 2
//
//        // Item
//        let item = NSCollectionLayoutItem(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1.0),
//                heightDimension: .fractionalHeight(1.0)
//            )
//        )
//        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
//
//        // Group
//        let group = NSCollectionLayoutGroup.vertical(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1.0),
//                heightDimension: .absolute(80)
//            ),
//            subitem: item,
//            count: 1
//        )
//
//        // Section
//        let section = NSCollectionLayoutSection(group: group)
//        return section
//    }
//
//    private static func createSectionLayoutDefault () -> NSCollectionLayoutSection { // case 3
//
//        // Item
//        let item = NSCollectionLayoutItem(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1.0),
//                heightDimension: .fractionalHeight(1.0)
//            )
//        )
//        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
//
//        // Group
//        let group = NSCollectionLayoutGroup.vertical(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1.0),
//                heightDimension: .absolute(390)
//            ),
//            subitem: item,
//            count: 1
//        )
//
//        // Section
//        let section = NSCollectionLayoutSection(group: group)
//        return section
//    }
//
//    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
//
//        let supplementaryViews = [
//            NSCollectionLayoutBoundarySupplementaryItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(50)
//                ),
//                elementKind: UICollectionView.elementKindSectionHeader,
//                alignment: .top
//            )
//        ]
//
//        switch section {
//        case 0: return createSectionLayoutNewRelease(with: supplementaryViews)
//        case 1: return createSectionLayoutFeaturedPlaylists()
//        case 2: return createSectionLayoutNewRelease(with: supplementaryViews)
//        default: return createSectionLayoutNewRelease(with: supplementaryViews)
//        }
//
//    }
//
//    private func fetchData(){
//        let group = DispatchGroup()
//        group.enter()
//        group.enter()
//        group.enter()
//
//        print("start fetching data")
//
//        var newRelease: NewReleasesResponse?
//        var featuredPlaylist: FeaturedPlaylistsResponse?
//        var recommendations: RecommendationsResponse?
//
//        // New Releases
//        APICaller.shared.getNewReleases{ result in
//
//            defer {
//                group.leave()
//            }
//
//            switch result {
//            case .success(let model):
//                newRelease = model
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        // Featured Playlists
//        APICaller.shared.getFeaturedPlaylists{ result in
//
//            defer {
//                group.leave()
//            }
//
//            switch result {
//            case .success(let model):
//                featuredPlaylist = model
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        // Recomended Tracks
//        APICaller.shared.getRecomendedGenres{ result in
//            switch result {
//            case .success(let model) :
//                let genres = model.genres
//                var seeds = Set<String>()
//                while seeds.count < 5 {
//                    if let random = genres.randomElement() {
//                        seeds.insert(random)
//                    }
//                }
//                APICaller.shared.getRecommendations(genres: seeds){ recomendedResult in
//                    defer{
//                        group.leave()
//                    }
//
//                    switch recomendedResult {
//                    case .success(let model):
//                        recommendations = model
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//
//                }
//            case .failure(let error) :
//                print(error.localizedDescription)
//            }
//        }
//
//        group.notify(queue: .main){
//            guard let newAlbums = newRelease?.albums.items,
//                  let playlists = featuredPlaylist?.playlists.items,
//                  let tracks = recommendations?.tracks else {
//
//                      fatalError("Models are nil")
//                      return
//                  }
//
//            print("configuring viewmodels")
//            self.configureModels(newAlbums: newAlbums,
//                                 playlists: playlists,
//                                 tracks: tracks)
//        }
//
//        print(modelService.album)
//    }
//
//    private func configureModels(
//        newAlbums: [Album],
//        playlists: [Playlist],
//        tracks: [AudioTrack]
//    ){
//        self.newAlbums = newAlbums
//        self.playlists = playlists
//        self.tracks = tracks
//
//        // Configure Models
//        sections.append(.newReleases(viewModels: newAlbums.compactMap({
//            return NewReleasesCellViewModel(
//                name: $0.name,
//                artworkURL: URL(string: $0.images.first?.url ?? ""),
//                numberOfTracks: $0.total_tracks,
//                artistName: $0.artists.first?.name ?? "-"
//            )
//        })))
//        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
//            return FeaturedPlyalistCellViewModel(
//                name: $0.name,
//                artworkURL: URL(string: $0.images.first?.url ?? ""),
//                creatorName: $0.owner.display_name
//            )
//        })))
//        sections.append(.recomendedTracks(viewModels: tracks.compactMap({
//            return RecomendedTrackCellViewModel(
//                name: $0.name,
//                artistName: $0.artists.first?.name ?? "-",
//                artworkURL: URL(string: $0.album?.images.first?.url ?? "")
//            )
//        })))
//
//        collectionView.reloadData()
//    }
//
//    @objc func didTapSettings() {
//        let vc = SettingsViewController()
//        vc.title = "Settings"
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//
//}
//
//extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource{
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        guard let header = collectionView.dequeueReusableSupplementaryView(
//            ofKind: kind,
//            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
//            for: indexPath
//        ) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
//            return UICollectionReusableView()
//        }
//
//        let section = indexPath.section
//        let title = sections[section].title
//
//        header.configure(with: title)
//
//        return header
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//
//        let section = sections[indexPath.section]
//
//        switch section {
//        case .featuredPlaylists:
//            let playlist = playlists[indexPath.row]
//            let vc = PlaylistViewController(playlist: playlist)
//            vc.title = playlist.name
//            vc.navigationItem.largeTitleDisplayMode = .never
//            navigationController?.pushViewController(vc, animated: true)
//            break
//        case .newReleases:
//            let album = newAlbums[indexPath.row]
//            let vc = AlbumViewController(album: album)
//            vc.title = album.name
//            vc.navigationItem.largeTitleDisplayMode = .never
//            navigationController?.pushViewController(vc, animated: true)
//        case .recomendedTracks:
//            let track = tracks[indexPath.row]
//            PlaybackPresenter.shared.startPlayback(from: self, track: track)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let type = sections[section]
//
//        switch type {
//
//        case .newReleases(let viewModels): return viewModels.count
//        case .featuredPlaylists(let viewModels): return viewModels.count
//        case .recomendedTracks(let viewModels): return viewModels.count
//
//        }
//
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return sections.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let type = sections[indexPath.section]
//
//        switch type {
//
//        case .newReleases(let viewModels):
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
//                for: indexPath) as? NewReleaseCollectionViewCell else {
//                return UICollectionViewCell()
//            }
//            let viewModel = viewModels[indexPath.row]
//            cell.configure(with: viewModel)
//            return cell
//
//        case .featuredPlaylists(let viewModels):
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
//                for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
//                return UICollectionViewCell()
//            }
//            cell.configure(with: viewModels[indexPath.row])
//            cell.backgroundColor = .systemBlue
//            return cell
//        case .recomendedTracks(let viewModels):
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: RecomendedTrackCollectionViewCell.identifier,
//                for: indexPath) as? RecomendedTrackCollectionViewCell else {
//                return UICollectionViewCell()
//            }
//            cell.backgroundColor = .systemOrange
//            cell.configure(with: viewModels[indexPath.row])
//            return cell
//
//        }
//    }
//
//}
//

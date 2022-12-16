//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Amini on 25/12/21.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    private let playlist: Playlist
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitem: item,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)),
                                                            elementKind: UICollectionView.elementKindSectionHeader,
                                                            alignment: .top)
            ]
            return section
        })
    )
    
    init(playlist: Playlist){
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
//    private var viewModels = [RecomendedTrackCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .black
        
        view.addSubview(collectionView)
        
//        collectionView.register(RecomendedTrackCollectionViewCell.self,
//                                forCellWithReuseIdentifier: RecomendedTrackCollectionViewCell.identifier)
        
        collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        
        collectionView.backgroundColor = .systemBackground
//        collectionView.delegate = self
//        collectionView.dataSource = self
        
//        APICaller.shared.getPlaylistsDetails(for: playlist){ [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let model):
//                    //RecomendedTrackCellViewModel
//                    self?.viewModels = model.tracks.items.compactMap({
//                        RecomendedTrackCellViewModel(name: $0.track.name,
//                                                     artistName: $0.track.artists.first?.name ?? "-",
//                                                     artworkURL: URL(string: $0.track.album?.images.first?.url ?? "")
//                        )
//                    })
//                    self?.collectionView.reloadData()
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
    }
    
    @objc private func didTapShare(){
        guard let url = URL(string: playlist.owner.external_urls["spotify"] ?? "") else {
            return
        }
        
        
        let vc = UIActivityViewController(activityItems: ["Check out cool playlist i found !", url], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }

}
//
//extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModels.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomendedTrackCollectionViewCell.identifier, for: indexPath) as? RecomendedTrackCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        cell.configure(with: viewModels[indexPath.row])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let header = collectionView.dequeueReusableSupplementaryView(
//            ofKind: kind,
//            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
//            for: indexPath) as? PlaylistHeaderCollectionReusableView,
//        kind == UICollectionView.elementKindSectionHeader else {
//            return UICollectionReusableView()
//        }
//
////        let headerViewModel = PlaylistHeaderViewModel(
////            name: playlist.name,
////            ownerName: playlist.owner.display_name,
////            description: playlist.description,
////            artworkURL: URL(string: playlist.images.first?.url ?? "")
////        )
//
//        header.configure(with: headerViewModel)
//        header.delegate = self
//
//        return header
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        // Play Song
//
//    }
//
//}
//
//extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate {
//
//    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
//        // Start playlist play in queue
//        print("play all")
//    }
//}

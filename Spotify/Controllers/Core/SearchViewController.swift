//
//  SearchViewController.swift
//  Spotify
//
//  Created by Amini on 25/12/21.
//

import UIKit

class SearchViewController: UIViewController {

    let searchController: UISearchController = {
        let results = SearchResultViewController()
        let vc = UISearchController(searchResultsController: results)
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        
        return vc
    }()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: {_, _ -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)))
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(150)
                    ),
                    subitems: [item, item])
                
                group.contentInsets = NSDirectionalEdgeInsets (top: 10, leading: 0, bottom: 10, trailing: 0)
                
                return NSCollectionLayoutSection(group: group)
            }
        )
    )
    
    private var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        searchController.searchResultsUpdater = self
//        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        view.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.register(GenreCollectionViewCell.self,
                                forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
//        APICaller.shared.getCategories{ [weak self] result in
//
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let categories):
//                    self?.categories = categories
//                    self?.collectionView.reloadData()
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsController = searchController.searchResultsController as? SearchResultViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
              
        
        print(query)
        // perform search
//        APICaller.shared.search(with: query, completion: {
//            result in
//
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let results):
//                    resultsController.update(with: results)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        })
    }
}

//extension SearchViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let resultsController = searchController.searchResultsController as? SearchResultViewController,
//              let query = searchBar.text,
//              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
//                  return
//              }
//
//        APICaller.shared.search(with: query, completion: {
//            result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let results):
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        })
//    }
//
//}
//
//extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return categories.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: GenreCollectionViewCell.identifier,
//            for: indexPath)
//                as? GenreCollectionViewCell else {
//                return UICollectionViewCell()
//            }
//
//        let category = categories[indexPath.row]
//        cell.configure(with: CategoryCollectionViewCellViewModel(
//            title: category.name,
//            artworkURL: URL(string: category.icons.first?.url ?? "")
//        ))
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//
//        let category = categories[indexPath.row]
//        let vc = CategoryViewController(category: category)
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}

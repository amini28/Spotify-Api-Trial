//
//  SearchResultViewController.swift
//  Spotify
//
//  Created by Amini on 25/12/21.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultsViewControllerDelegate : AnyObject{
    func showResult(_ controller: UIViewController)
}

class SearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var sections: [SearchSection] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results: [SearchResult]){

        let artists = results.filter {
            switch $0 {
            case .artist : return true
            default: return false
            }
        }
        
        self.sections = [
            SearchSection(title: "Artists", results: artists)
        ]
        
        tableView.reloadData()
        tableView.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch result {
        case .artist(let model):
            cell.textLabel?.text = "Artist" + model.name
        case .album(let model):
            cell.textLabel?.text = "Album" + model.name
        case .track(let model):
            cell.textLabel?.text = "Track" + model.name
        case .playlist(let model):
            cell.textLabel?.text = "Playlist" + model.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = sections[indexPath.row].results[indexPath.row]
        
        switch result {
        case .artist(let model):
            break
        case .album(let model):
            let vc = AlbumViewController(album: model)
            delegate?.showResult(vc)
            
        case .track(let model):
            break
        case .playlist(let model):
            let vc = PlaylistViewController(playlist: model)
//            vc.navigationItem.largeTitleDisplayMode = .never
//            navigationController?.pushViewController(vc, animated: true)
            delegate?.showResult(vc)
        }
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate{
    func showResult(_ controller: UIViewController) {
        controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(controller, animated: true)
    }
}

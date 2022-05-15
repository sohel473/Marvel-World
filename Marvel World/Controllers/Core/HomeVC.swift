//
//  HomeVC.swift
//  Marvel World
//
//  Created by Abdullah Al Sohel on 5/15/22.
//

import UIKit

class HomeVC: UIViewController {
    
    private var characters: [Character] = [Character]()
    
    private let characterTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: SearchResultVC())
        search.searchBar.placeholder = "Search for a Character"
        search.searchBar.searchBarStyle = .minimal
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Characters"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        characterTable.delegate = self
        characterTable.dataSource = self
        
        view.addSubview(characterTable)
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        searchController.searchResultsUpdater = self
        
        fetchDiscoverMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        characterTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getCharacters { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let titles):
                self.characters = titles
                DispatchQueue.main.async {
                    self.characterTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

//MARK: - UITableView Delegate and Datasource
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
        guard let character_name = characters[indexPath.row].name, let thumbnail = characters[indexPath.row].thumbnail.path else { return UITableViewCell() }
        let model = CharacterViewModel(character_name: character_name, thumbnail: thumbnail)
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let character = characters[indexPath.row]
        guard let character_name = character.name, let character_description = character.description
        else {
            return
        }
        APICaller.shared.getMovies(query: character_name + " variants comics history") { [weak self] result in
            guard let self = self else { return }
//            print("ININ")
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
//                    print("INININ")
                    let vc = CharacterPreviewVC()
                    vc.configure(with: CharacterPreviewModel(name: character_name, description: character_description, youtubeOverview: videoElement))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

//MARK: - UISearchController Updater
extension HomeVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
        let resultController = searchController.searchResultsController as? SearchResultVC else { return }
        resultController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let characters):
                    resultController.characters = characters
                    resultController.searchResultCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
}

extension HomeVC: SearchResultVCDelegate {
    
    func SearchResultVCdidTap(_ viewModel: CharacterPreviewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let vc = CharacterPreviewVC()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

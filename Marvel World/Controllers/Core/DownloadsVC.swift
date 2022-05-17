//
//  DownloadsVC.swift
//  Marvel World
//
//  Created by Abdullah Al Sohel on 5/15/22.
//

import UIKit

class DownloadsVC: UIViewController {
    
    private var characters: [CharacterItem] = [CharacterItem]()
    
    private let downloadTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Downloads"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadTable)
        
        downloadTable.delegate = self
        downloadTable.dataSource = self
        
        fetchTitleFromDatabase()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchTitleFromDatabase()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
    
    func fetchTitleFromDatabase() {
        DataPersistence.shared.fetchingTitles { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let characters):
                self.characters = characters
                DispatchQueue.main.async {
                    self.downloadTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

//MARK: - UITableView Delegate and DataSource
extension DownloadsVC: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
        guard let character_name = characters[indexPath.row].name, let thumbnail = characters[indexPath.row].thumbnail!.path else { return UITableViewCell() }
        let model = CharacterViewModel(character_name: character_name, thumbnail: thumbnail)
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let character = characters[indexPath.row]
//        guard let character_name = character.name, let character_description = character.resultDescription
//        else {
//            return
//        }
//        APICaller.shared.getMovies(query: character_name + " variants comics history") { [weak self] result in
//            guard let self = self else { return }
////            print("ININ")
//            switch result {
//            case .success(let videoElement):
//                DispatchQueue.main.async {
////                    print("INININ")
//                    let vc = CharacterPreviewVC()
//                    vc.configure(with: CharacterPreviewModel(name: character_name, description: character_description, urls: character.urls, youtubeOverview: videoElement))
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistence.shared.deleteTitle(model: characters[indexPath.row]) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    print("Character Deleted Successfully")
                    
                case .failure(let error):
                    print(error)
                }
                self.characters.remove(at: indexPath.row)
                self.downloadTable.deleteRows(at: [indexPath], with: .left)
            }
        default:
            break
        }
    }

}

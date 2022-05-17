//
//  SearchResultVC.swift
//  Marvel World
//
//  Created by Abdullah Al Sohel on 5/15/22.
//

import UIKit

protocol SearchResultVCDelegate: AnyObject {
    func SearchResultVCdidTap(_ viewModel: CharacterPreviewModel)
}

class SearchResultVC: UIViewController {
    
    public var characters: [Character] = [Character]()
    
    weak var delegate: SearchResultVCDelegate?
    
    public let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(searchResultCollectionView)
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
    
    func downloadAt(indexPath: IndexPath) {
        DataPersistence.shared.downloadCharacter(model: characters[indexPath.row]) { result in
            switch result {
            case .success():
                print("Character Download Successful!")
            case .failure(let error):
                print(error)
            }
        }
//        print("Character Download Successful!")
    }
    
}

extension SearchResultVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as! TitleCollectionViewCell
        if let thumbnail = characters[indexPath.row].thumbnail.path {
            cell.configure(with: thumbnail)
        }
        //        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
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
                print(character_name)
//                print(character_description)
//                print(videoElement.id.videoId)
                self.delegate?.SearchResultVCdidTap(CharacterPreviewModel(name: character_name, description: character_description, urls: character.urls, youtubeOverview: videoElement))
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self.downloadAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}

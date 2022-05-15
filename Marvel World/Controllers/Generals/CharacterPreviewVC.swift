//
//  CharacterPreviewVC.swift
//  Marvel World
//
//  Created by Abdullah Al Sohel on 5/16/22.
//

import UIKit
import WebKit
import SafariServices

class CharacterPreviewVC: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
//        label.text = "Title Label"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
//        label.text = "OverView Label"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let detailsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Details", for: .normal)
//        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let comicButton: UIButton = {
        let button = UIButton()
        button.setTitle("Comics", for: .normal)
//        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(detailsButton)
        view.addSubview(comicButton)
        view.addSubview(webView)
        
        configureConstraints()
        
    }
    
    func configure(with model: CharacterPreviewModel) {
        titleLabel.text = model.name
        overviewLabel.text = model.description == "" ? "No description available for this character" : model.description
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeOverview.id.videoId!)") else { return }
        
        webView.load(URLRequest(url: url))
    }
    
    func presentSafariVC(from url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredBarTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            
            detailsButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            detailsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            detailsButton.widthAnchor.constraint(equalToConstant: 140),
            detailsButton.heightAnchor.constraint(equalToConstant: 40),
            
            comicButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            comicButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            comicButton.widthAnchor.constraint(equalToConstant: 140),
            comicButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

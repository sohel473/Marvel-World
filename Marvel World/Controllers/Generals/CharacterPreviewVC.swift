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
    
    var urls: [URLElement]?

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
        button.setTitle("Detail", for: .normal)
//        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
//        button.addTarget(self, action: #selector(presentSafariVC(from:)), for: .touchUpInside)
        return button
    }()
    
    
    
//    private let wikiButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Wiki", for: .normal)
////        button.layer.borderColor = UIColor.white.cgColor
//        button.backgroundColor = .red
//        button.layer.borderWidth = 1
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 8
//        button.layer.masksToBounds = true
//        return button
//    }()
    
    let comicButton: UIButton = {
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
    
//    private let stackView: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [])
//        stack.axis = .horizontal
//        stack.distribution = .equalSpacing
//        return stack
//    }()
    
    
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
//        view.addSubview(wikiButton)
        view.addSubview(comicButton)
        view.addSubview(webView)
        
        configureConstraints()
        
    }
    
    func configure(with model: CharacterPreviewModel) {
        titleLabel.text = model.name
        overviewLabel.text = model.description == "" ? "No description available for this character" : model.description
        self.urls = model.urls
        
        for (i, button) in [detailsButton, comicButton].enumerated() {
            button.setTitle(urls![i].type, for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(presentSafariVC), for: .touchUpInside)
        }
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeOverview.id.videoId!)") else { return }
        
        webView.load(URLRequest(url: url))
    }
    
    @objc func presentSafariVC(sender: UIButton) {
        if sender.tag == 0 {
            guard let url = URL(string: urls![sender.tag].url!) else { return }
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        } else {
            guard let url = URL(string: urls![sender.tag].url!) else { return }
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
        
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
            detailsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsButton.widthAnchor.constraint(equalToConstant: 100),
            detailsButton.heightAnchor.constraint(equalToConstant: 40),
            
//            wikiButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
//            wikiButton.leadingAnchor.constraint(equalTo: detailsButton.trailingAnchor, constant: 20),
//            wikiButton.widthAnchor.constraint(equalToConstant: 100),
//            wikiButton.heightAnchor.constraint(equalToConstant: 40),
            
            comicButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            comicButton.leadingAnchor.constraint(equalTo: detailsButton.trailingAnchor, constant: 20),
            comicButton.widthAnchor.constraint(equalToConstant: 100),
            comicButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

//
//  TitleCollectionViewCell.swift
//  Marvel World
//
//  Created by Abdullah Al Sohel on 5/15/22.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
//        image.image = UIImage(named: "ImageNotAvailable")
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
//        contentView.backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    func configure(with model: String) {
        
        guard let url = URL(string: "\(model)/standard_large.jpg") else {
            print("Image Not Found")
            return
        }
//        print(url)
        posterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "ImageNotAvailable"))
//        print(model)
    }
}

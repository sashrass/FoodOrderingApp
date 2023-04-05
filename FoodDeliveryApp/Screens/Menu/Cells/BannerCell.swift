//
//  BannerCell.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 03.04.2023.
//

import UIKit

class BannerCell: UICollectionViewCell {
    
    static let reuseIdentifier = "BannerCell"
    
    private var model: BannerCellModel?
    
    private var task: URLSessionDataTask?
    
    private lazy var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: BannerCellModel) {
        self.model = model
        task?.cancel()
        task = bannerImageView.setImage(from: model.imageURL)
    }
    
    private func setupUI() {
        layer.cornerRadius = 10
        contentView.addSubview(bannerImageView)
        self.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            bannerImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bannerImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }

}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

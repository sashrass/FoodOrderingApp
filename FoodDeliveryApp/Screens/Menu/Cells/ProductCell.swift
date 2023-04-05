//
//  ProductCell.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 03.04.2023.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ProductCell"
    
    private var model: ProductCellModel?
    private var task: URLSessionDataTask?
    
    var roundedUpperCorners = false {
        didSet {
            if roundedUpperCorners {
                layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                layer.cornerRadius = 17
                layer.masksToBounds = true
            } else {
                layer.cornerRadius = 0
                layer.masksToBounds = false
            }
        }
    }
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(13)
        label.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private let priceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.pink2.cgColor
        button.layer.cornerRadius = 6
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 18, bottom: 8, trailing: 18)
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 13)
            outgoing.foregroundColor = .pink2
            return outgoing
        }
        button.configuration = configuration
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: ProductCellModel) {
        self.model = model
        task?.cancel()
        task = productImageView.setImage(from: model.imageURL)
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        priceButton.setTitle("От \(Int(model.startPrice)) р", for: .normal)
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white
        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceButton)
        
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalToConstant: 132),
            productImageView.heightAnchor.constraint(equalToConstant: 132),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 32),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            priceButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            priceButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            priceButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24)
        ])
        
    }
    
}

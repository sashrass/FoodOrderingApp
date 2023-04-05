//
//  CitySelectorView.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 04.04.2023.
//

import Foundation
import UIKit

class CitySelectorView: UIView {
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .black
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .backgroundMain
        addSubview(cityLabel)
        addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            cityLabel.topAnchor.constraint(equalTo: topAnchor),
            cityLabel.bottomAnchor.constraint(equalTo:  bottomAnchor),
               
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: cityLabel.trailingAnchor, constant: 8),
            arrowImageView.centerYAnchor.constraint(equalTo: cityLabel.centerYAnchor)
        ])
    }
}

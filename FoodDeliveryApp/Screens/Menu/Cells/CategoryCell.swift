//
//  CategoryCell.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 03.04.2023.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CategoryCell"
    
    private var model: CategoryCellModel?
    
    override var isSelected: Bool {
        didSet {
            setDesign()
        }
    }
    
    lazy var titleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.pink2.withAlphaComponent(0.4).cgColor
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
        
//        setDesign()
    }
    
    private func setDesign() {
        
        if isSelected {
            titleLabel.font = .boldSystemFont(ofSize: 13)
            titleLabel.textColor = UIColor.pink2
            contentView.backgroundColor = UIColor.pink1
            self.layer.borderWidth = 0
            
        } else {
            titleLabel.font = .systemFont(ofSize: 13)
            titleLabel.textColor = UIColor.pink2.withAlphaComponent(0.4)
            contentView.backgroundColor = UIColor.backgroundMain
            self.layer.borderWidth = 1
        }
    }
    
    func configure(with model: CategoryCellModel) {
        self.model = model
        titleLabel.text = model.name
        setDesign()
    }
    
}

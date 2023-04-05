//
//  CollectionReusableView.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 03.04.2023.
//

import UIKit

protocol CategoriesHeaderDelegate {
    func didSelectCategoryWith(index: Int)
}

extension CategoriesHeaderDelegate {
    func didSelectCategoryWith(index: Int) { }
}

enum Section {
    case product
}

class CategoriesHeader: UICollectionReusableView {
    
    static let reuseIdentifier = "CategoriesHeader"
    
    weak var delegate: CategoriesHeaderDelegate?
    
    private var selectedCategory = -1
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, CategoryCellModel>!
    
    private var categoryCellModels = [CategoryCellModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with categories: [CategoryCellModel]) {
        self.categoryCellModels = categories
        applySnapshot()
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor.backgroundMain
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        addSubview(collectionView)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, CategoryCellModel>(collectionView: collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, item: CategoryCellModel) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else { fatalError("Cannot create the cell") }

            collectionView.delegate = self
            cell.configure(with: item)
            
            if self?.selectedCategory == -1 {
                self?.selectedCategory = 0
                self?.selectCategory(with: 0)
            }

            return cell
        }
        
        
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(88), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupHeight: CGFloat = 32
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(88), heightDimension: .absolute(groupHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.orthogonalScrollingBehavior = .continuous
            
            section.contentInsets = NSDirectionalEdgeInsets(
                top: (layoutEnvironment.container.contentSize.height - groupHeight)/2,
                leading: 16,
                bottom: 0,
                trailing: 16
              )
            
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CategoryCellModel>()
        let sections: [Section] = [.product]
        snapshot.appendSections([sections[0]])
        snapshot.appendItems(self.categoryCellModels)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func selectCategory(with index: Int) {
        
        if selectedCategory != -1 {
            collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .left)
            selectedCategory = index
        }
        
    }
    
    func updateCategories(_ categories: [CategoryCellModel]) {
        self.categoryCellModels = categories
        applySnapshot()
    }
 
}


extension CategoriesHeader: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = indexPath.row
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        delegate?.didSelectCategoryWith(index: indexPath.row)
    }
    
}

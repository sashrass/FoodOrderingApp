//
//  ViewController.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 03.04.2023.
//

import UIKit

protocol MenuDisplayLogic: AnyObject {
    func displayBanners(_ banners: [BannerCellModel])
    func displayCategories(_ categories: [CategoryCellModel])
    func displayProducts(_ products: [ProductCellModel])
    func setCity(_ city: String)
}

enum SectionType: Int, CaseIterable {
    case banners
    case products
}

private enum SizeConstants{
    static let categoriesHeaderHeight: CGFloat = 80
}

class MenuViewController: UIViewController {
    
    private var interactor: MenuBussinessLogic!
    
    private var collectionView: UICollectionView!
    private let citySelectorView = CitySelectorView()
    private var categoriesHeader: CategoriesHeader?
    
    private var dataSource: UICollectionViewDiffableDataSource<SectionType, AnyHashable>!
    
    private var bannerCellModels = [BannerCellModel]()
    private var productCellModels = [ProductCellModel]()
    private var categoryCellModels = [CategoryCellModel]()
    
    private var currentCellThatHitPointIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundMain
        setupDI()
        setupCollectionView()
        setupDataSource()
        
        interactor.fetchBanners()
        interactor.fetchCategories()
        interactor.fetchProducts()
        interactor.fetchCurrentCity()
    }
        
    private func setupDI() {
        let viewController = self
        let interactor = MenuInteractor()
        let presenter = MenuPresenter()
        
        presenter.viewController = viewController
        interactor.presenter = presenter
        viewController.interactor = interactor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: citySelectorView)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor.backgroundMain
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.reuseIdentifier)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        
        collectionView.register(CategoriesHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoriesHeader.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let sectionType = SectionType(rawValue: sectionIndex) else { return nil }
            
            let section = self.layoutSection(for: sectionType)
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    private func layoutSection(for type: SectionType) -> NSCollectionLayoutSection {
        switch type {
        case .banners:
            return getLayoutForBannersSection()
        case .products:
            return getLayoutForProductsSection()
        }
    }
    
    private func getLayoutForBannersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(112))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func getLayoutForProductsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(180))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(180))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(SizeConstants.categoriesHeaderHeight))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        headerElement.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerElement]
        return section
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionType, AnyHashable>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            
            if let banner = item as? BannerCellModel {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier, for: indexPath) as? BannerCell else { fatalError("Cannot create the cell") }
                cell.configure(with: banner)
                
                return cell
            }
            
            if let product = item as? ProductCellModel {

                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier, for: indexPath) as? ProductCell else { fatalError("Cannot create the cell") }
                cell.configure(with: product)
                
                if indexPath.row == 0 {
                    cell.roundedUpperCorners = true
                } else if cell.roundedUpperCorners, indexPath.row != 0 {
                    cell.roundedUpperCorners = false
                }
                
                return cell
            }
            
            fatalError("Wrong item")
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            if indexPath.section == 1 {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoriesHeader.reuseIdentifier, for: indexPath) as? CategoriesHeader else { fatalError("Cannot create the header") }
                
                header.delegate = self
                header.configure(with: self.categoryCellModels)
                self.categoriesHeader = header
                return header
            }
            
            fatalError("Wrong index")
        }
        
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, AnyHashable>()
        let sections: [SectionType] = [.banners, .products]
        snapshot.appendSections([sections[0]])
        snapshot.appendItems(bannerCellModels)
        snapshot.appendSections([sections[1]])
        snapshot.appendItems(productCellModels)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension MenuViewController: MenuDisplayLogic {
    
    func displayBanners(_ banners: [BannerCellModel]) {
        bannerCellModels = banners
        applySnapshot()
    }
    
    func displayCategories(_ categories: [CategoryCellModel]) {
        categoryCellModels = categories
        categoriesHeader?.updateCategories(categories)
//        categoriesHeader.sel
    }
    
    func displayProducts(_ products: [ProductCellModel]) {
        productCellModels = products
        applySnapshot()
    }
    
    func setCity(_ city: String) {
        citySelectorView.cityLabel.text = city
    }
    
}

extension MenuViewController: CategoriesHeaderDelegate {
    
    func didSelectCategoryWith(index: Int) {
        let indexPath = IndexPath(row: index, section: 1)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
}

extension MenuViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        categoriesHeader?.selectCategory(with: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if collectionView.isDragging || collectionView.isDecelerating {
            
            let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            let hitPoint = CGPoint(x: visibleRect.midX, y: visibleRect.origin.y + SizeConstants.categoriesHeaderHeight + self.topBarHeight + 30)
            
            if let cellThatHitPointIndexPath = collectionView.indexPathForItem(at: hitPoint),
               cellThatHitPointIndexPath.section == 1,
               currentCellThatHitPointIndex != cellThatHitPointIndexPath.row {
                
                let newProductCellModel = productCellModels[cellThatHitPointIndexPath.row]
                
                let oldProductCellModel = productCellModels[currentCellThatHitPointIndex]
                
                if oldProductCellModel.categoryID != newProductCellModel.categoryID {
                    if let categoryIndex = categoryCellModels.firstIndex(where: { $0.id == newProductCellModel.categoryID }) {
                        categoriesHeader?.selectCategory(with: categoryIndex)
                    }
                    
                }
                
                currentCellThatHitPointIndex = cellThatHitPointIndexPath.row
            }
        }
        
    }
}




//
//  MenuPresenter.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 04.04.2023.
//

import Foundation

protocol MenuPresentationLogic: AnyObject {
    func presentBanners(_ banners: [BannerCellModel])
    func presentCategories(_ categories: [CategoryCellModel])
    func presentProducts(_ products: [ProductCellModel])
    func presentCity(_ city: String)
}

class MenuPresenter: MenuPresentationLogic {
    
    weak var viewController: MenuDisplayLogic?
    
    func presentBanners(_ banners: [BannerCellModel]) {
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayBanners(banners)
        }
    }
    
    func presentCategories(_ categories: [CategoryCellModel]) {
        
        let sortedCategories = categories.sorted { $0.id < $1.id }
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayCategories(sortedCategories)
        }
    }
    
    func presentProducts(_ products: [ProductCellModel]) {
        
        let sortedProducts = products.sorted { $0.categoryID < $1.categoryID }
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayProducts(sortedProducts)
        }
    }
    
    func presentCity(_ city: String) {
        viewController?.setCity(city)
    }
    
}

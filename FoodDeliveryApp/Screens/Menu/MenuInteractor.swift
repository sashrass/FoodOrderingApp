//
//  MenuInteractor.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 04.04.2023.
//

import Foundation

protocol MenuBussinessLogic: AnyObject {
    func fetchBanners()
    func fetchCategories()
    func fetchProducts()
    func fetchCurrentCity()
}

struct DataReceivingError: Error { }

class MenuInteractor: MenuBussinessLogic {
    
    var presenter: MenuPresentationLogic?
    
    let webService: DataService = WebService()
    let storageService = StorageService()
    
    private let synchronizeBannersAndProductsLock = NSLock()
    
    func fetchBanners() {
        
        Task.init { [weak self] in
            do {
                let banners = try await self?.webService.getBanners()

                guard let banners = banners else {
                    throw DataReceivingError()
                }
                
                let bannerCellModels = banners.map { bannerResponse -> BannerCellModel in
                    BannerCellModel(id: bannerResponse.id, imageURL: bannerResponse.imageURL)
                }
                
                self?.presenter?.presentBanners(bannerCellModels)
                self?.storageService.saveBanners(bannerCellModels)
                self?.storageService.getBanners()
            } catch {
                self?.storageService.getBanners { bannerCellModels in
                    self?.presenter?.presentBanners(bannerCellModels)
                }
            }
        }
        
    }
    
    func fetchCategories() {
        
        Task.init { [weak self] in
            do {
                let categories = try await self?.webService.getCategories()

                guard let categories = categories else {
                    throw DataReceivingError()
                }
                
                let categoryCellModels = categories.map { categoryResponse -> CategoryCellModel in
                    CategoryCellModel(id: categoryResponse.id, name: categoryResponse.name)
                }
                
                self?.presenter?.presentCategories(categoryCellModels)
                self?.storageService.saveCategories(categoryCellModels)
                
            } catch {
                self?.fetchCategoriesAndProductsFromStorage()
            }
        }
        
    }
    
    func fetchProducts() {
        
        Task.init { [weak self] in
            do {
                let products = try await self?.webService.getProducts()

                guard let products = products else {
                    throw DataReceivingError()
                }
                
                let productsCellModels = products.map { productReponse -> ProductCellModel in
                    ProductCellModel(id: productReponse.id, categoryID: productReponse.categoryID, name: productReponse.name, description: productReponse.description, imageURL: productReponse.imageURL, startPrice: productReponse.startPrice)
                }
                
                self?.presenter?.presentProducts(productsCellModels)
                self?.storageService.saveProducts(productsCellModels)
                
            } catch {
                self?.fetchCategoriesAndProductsFromStorage()
            }
        }
        
    }
    
    func fetchCurrentCity() {
        presenter?.presentCity("Москва")
    }
    
    private func fetchCategoriesAndProductsFromStorage() {
        
        if !synchronizeBannersAndProductsLock.try() { return }
        
        storageService.getCategories { categoryCellModels in
            self.presenter?.presentCategories(categoryCellModels)
        }
        
        storageService.getProducts { productCellModels in
            self.presenter?.presentProducts(productCellModels)
        }
    }
    
}

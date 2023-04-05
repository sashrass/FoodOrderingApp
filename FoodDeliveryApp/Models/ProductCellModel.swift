//
//  ProductCellModel.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 04.04.2023.
//

import Foundation

struct ProductCellModel: Hashable {

    let id: String
    let categoryID: String
    let name: String
    let description: String
    let imageURL: String
    let startPrice: Double
    
    init(id: String, categoryID: String, name: String, description: String, imageURL: String, startPrice: Double) {
        self.id = id
        self.categoryID = categoryID
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.startPrice = startPrice
    }
 
    init(entity: ProductEntity) {
        self.id = entity.id!
        self.categoryID = entity.categoryID!
        self.name = entity.name!
        self.description = entity.productDescription!
        self.imageURL = entity.imageURL?.absoluteString ?? ""
        self.startPrice = entity.startPrice
    }
}

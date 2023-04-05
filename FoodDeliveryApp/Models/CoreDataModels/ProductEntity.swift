//
//  ProductEntity.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 05.04.2023.
//

import Foundation
import CoreData

class ProductEntity: NSManagedObject, CreatableEntity {
    
    typealias Item = ProductCellModel
    
    class func create(_ model: ProductCellModel, context: NSManagedObjectContext) -> NSManagedObject {
        let entity = ProductEntity(context: context)
        entity.id = model.id
        entity.imageURL = URL(string: model.imageURL)
        entity.startPrice = model.startPrice
        entity.categoryID = model.categoryID
        entity.name = model.name
        entity.productDescription = model.description

        return entity
    }

}

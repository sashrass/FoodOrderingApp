//
//  CategoryEntity.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 05.04.2023.
//

import Foundation
import CoreData

class CategoryEntity: NSManagedObject, CreatableEntity {
    
    class func create(_ model: CategoryCellModel, context: NSManagedObjectContext) -> NSManagedObject {
        let entity = CategoryEntity(context: context)
        entity.id = model.id
        entity.name = model.name
        
        return entity
    }
    
    
    typealias Item = CategoryCellModel
}

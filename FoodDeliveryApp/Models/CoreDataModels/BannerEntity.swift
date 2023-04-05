//
//  BannerEntity.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 05.04.2023.
//

import Foundation
import CoreData

protocol CreatableEntity: AnyObject {
    associatedtype Item
    
    static func create(_ model: Item, context: NSManagedObjectContext) -> NSManagedObject
}

class BannerEntity: NSManagedObject, CreatableEntity {
    
    typealias Item = BannerCellModel
    
    class func create(_ model: BannerCellModel, context: NSManagedObjectContext) -> NSManagedObject {
        let entity = BannerEntity(context: context)
        entity.id = model.id
        entity.imageURL = URL(string: model.imageURL)
        
        return entity
    }

    
}

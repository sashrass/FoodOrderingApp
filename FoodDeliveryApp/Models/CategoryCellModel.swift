//
//  CategoryCellModel.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 04.04.2023.
//

import Foundation

struct CategoryCellModel: Hashable {

    let id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(entity: CategoryEntity) {
        self.id = entity.id!
        self.name = entity.name!
    }
}

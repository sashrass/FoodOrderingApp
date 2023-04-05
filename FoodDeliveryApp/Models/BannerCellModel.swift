//
//  BannerCellModel.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 04.04.2023.
//

import Foundation
import UIKit

struct BannerCellModel: Hashable {
    let id: String
    let imageURL: String
    
    init(id: String, imageURL: String) {
        self.id = id
        self.imageURL = imageURL
    }
    
    init(entity: BannerEntity) {
        self.id = entity.id!
        self.imageURL = entity.imageURL?.absoluteString ?? ""
    }
}

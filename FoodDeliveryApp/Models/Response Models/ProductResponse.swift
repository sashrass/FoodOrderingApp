//
//  ProductResponse.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 04.04.2023.
//

import Foundation

struct ProductResponse: Decodable {
    let id: String
    let categoryID: String
    let name: String
    let description: String
    let imageURL: String
    let startPrice: Double
}

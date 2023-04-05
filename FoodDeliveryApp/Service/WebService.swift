//
//  File.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 04.04.2023.
//

import Foundation

protocol DataService {
    func getProducts() async throws -> [ProductResponse]
    func getBanners() async throws -> [BannerResponse]
    func getCategories() async throws -> [CategoryResponse]
}

private enum URLs: String {
    
    case products = "https://mirror-cloudy-seagull.glitch.me/products"
    case banners = "https://mirror-cloudy-seagull.glitch.me/banners"
    case categories = "https://mirror-cloudy-seagull.glitch.me/categories"
}

class WebService: DataService {
    
    func getProducts() async throws -> [ProductResponse] {
        
        let url = URL(string: URLs.products.rawValue)!
        return try await request(url: url, responseType: [ProductResponse].self)
    }
    
    func getBanners() async throws -> [BannerResponse] {
        
        let url = URL(string: URLs.banners.rawValue)!
        return try await request(url: url, responseType: [BannerResponse].self)
    }
    
    func getCategories() async throws -> [CategoryResponse] {
        
        let url = URL(string: URLs.categories.rawValue)!
        return try await request(url: url, responseType: [CategoryResponse].self)
    }
    
    
        
    private func request<T: Decodable>(url: URL, responseType: T.Type) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 5
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
        
    }
}

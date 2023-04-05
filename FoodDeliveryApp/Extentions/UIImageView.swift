//
//  UIImageView.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 04.04.2023.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(from url: String, withPlaceholder placeholder: UIImage? = .none) -> URLSessionDataTask? {
        
        guard let nsurl = NSURL(string: url) else { return nil }

        let cache = ImageCache.shared.cache

        if let cached = cache.object(forKey: nsurl) {
            self.image = cached
            return .none
        }
         
        self.image = placeholder
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                
                cache.setObject(image, forKey: NSURL(string: url)!)
                
                if let error = error as? URLError, error.code == .cancelled {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
        
        task.resume()
        return task
    }
}

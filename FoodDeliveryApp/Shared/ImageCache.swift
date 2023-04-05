//
//  ImageCachce.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 04.04.2023.
//

import Foundation
import UIKit


final class ImageCache {
    
    var cache: NSCache<NSURL, UIImage> = NSCache<NSURL, UIImage>()
    static var shared = ImageCache()
    
}

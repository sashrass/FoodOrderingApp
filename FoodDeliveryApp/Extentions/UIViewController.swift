//
//  UIViewController.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 05.04.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    var topBarHeight: CGFloat {
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        let navBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        return statusBarHeight + navBarHeight
    }
}

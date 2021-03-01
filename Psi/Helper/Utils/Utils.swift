//
//  Utils.swift
//  Marmalade
//
//  Created by Tayyab Ali on 10/25/19.
//  Copyright © 2019 Tayyab Ali. All rights reserved.
//

import UIKit

/*Utility functions used in the entire app*/
class Utils {
    
    static func switchToOnboarding() {
        
        if let rootViewController = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateInitialViewController()  {
            UIApplication.shared.windows.first?.rootViewController = rootViewController
        }
    }
    
    static func switchToMain() {
        
        if let rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()  {
            UIApplication.shared.windows.first?.rootViewController = rootViewController
        }
    }
    
    enum XIB_VIEW_NAME: String {
        var value: String {
            self.rawValue
        }
        
        case BlogPostCardView
    }
}

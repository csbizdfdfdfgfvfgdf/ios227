//
//  Constants.swift
//  Rezeptrechner
//
//  Created by Furqan on 10/28/18.
//  Copyright © 2018 faari27@gmail.com. All rights reserved.
//


import UIKit

//Google Map Api key

enum FlotingButtons: String, CaseIterable {
//    case folder
    case copy
    case cut
    case paste
    case edit
    case delete
    
    init?(tag: Int) {
        switch tag {
//        case 301:
//            self = .folder
        case 302:
            self = .copy
        case 303:
            self = .cut
        case 304:
            self = .paste
        case 305:
            self = .edit
        default:
            self = .delete
        }
    }
    
    var color: UIColor {
        switch self {
//        case .folder:
//            return #colorLiteral(red: 0.6823529412, green: 0.1098039216, blue: 0.3529411765, alpha: 1)
        case .copy:
            return #colorLiteral(red: 0.8039215686, green: 0.06274509804, blue: 0.4862745098, alpha: 1)
        case .cut:
            return #colorLiteral(red: 0.8745098039, green: 0.2, blue: 0.4862745098, alpha: 1)
        case .paste:
            return #colorLiteral(red: 0.8901960784, green: 0.3019607843, blue: 0.5490196078, alpha: 1)
        case .edit:
            return #colorLiteral(red: 0.9098039216, green: 0.4235294118, blue: 0.6274509804, alpha: 1)
        case .delete:
            return #colorLiteral(red: 0.9294117647, green: 0.5529411765, blue: 0.7137254902, alpha: 1)
        }
    }
    
    var tag: Int {
        switch self {
//        case .folder:
//            return 301
        case .copy:
            return 302
        case .cut:
            return 303
        case .paste:
            return 304
        case .edit:
            return 305
        case .delete:
            return 306
        }
    }
}

//
//  GenericModel.swift
//  Orb App
//
//  Created by Umair on 28/11/2020.
//  Copyright © 2020 Infinite. All rights reserved.
//

import Foundation

protocol GenericModel: Codable, CustomStringConvertible {
    
}

protocol Identifiable {
    var identifier: String {get}
}

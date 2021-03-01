//
//  Protocols.swift
//  Tracker
//
//  Created by Tayyab Ali on 13/04/2019.
//  Copyright © 2019 Fantech Labs. All rights reserved.
//

import UIKit

protocol IndecatorDelegate {
    
    func didStartIndecator()
    func didStop(withError errorMessage: String)
}

//
//  ConfigurableCell.swift
//  PushInc
//
//  Created by Tayyab Ali on 6/25/20.
//  Copyright © 2020 Fantechlabs. All rights reserved.
//

import Foundation

public protocol ConfigurableCell: ReusableCell {
    associatedtype T

    func configure(_ item: T, at indexPath: IndexPath)
}

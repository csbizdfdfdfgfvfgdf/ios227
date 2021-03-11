//
//  CollectionDataProvider.swift
//  PushInc
//
//  Created by Tayyab Ali on 6/25/20.
//  Copyright © 2020 Fantechlabs. All rights reserved.
//

import UIKit

public protocol CollectionDataProvider {
    associatedtype T

    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> T?

    func updateItem(at indexPath: IndexPath, value: T)
    func removeItem(at indexPath: IndexPath)
    func insertItem(at indexPath: IndexPath, value: T)
}

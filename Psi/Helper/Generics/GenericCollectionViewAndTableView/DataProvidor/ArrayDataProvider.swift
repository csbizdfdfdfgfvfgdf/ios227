//
//  ArrayDataProvider.swift
//  PushInc
//
//  Created by Tayyab Ali on 6/25/20.
//  Copyright © 2020 Fantechlabs. All rights reserved.
//

import Foundation

public class ArrayDataProvider<T>: CollectionDataProvider {
    
    // MARK: - Internal Properties
    var items: [[T]] = [] 
    
    // MARK: - Lifecycle
    init(array: [[T]]) {
        items = array
    }
    
    // MARK: - CollectionDataProvider
    public func numberOfSections() -> Int {
//        return items.count
        return 1
    }
    
    public func numberOfItems(in section: Int) -> Int {
//        guard section >= 0 && section < items.count else {
//            return 0
//        }
//        return items[section].count
        if items.count > 1 {
            return items[0].count+items[1].count
        } else if items.count > 0 {
            return items[0].count
        }
        return 0
//        return items[0].count+items[1].count
    }
    
    public func item(at indexPath: IndexPath) -> T? {
        guard indexPath.section >= 0 &&
            indexPath.section < items.count &&
            indexPath.row >= 0 &&
            indexPath.row < items[indexPath.section].count else
        {
            let index = indexPath.row - items[0].count
            return items[1][index]
//            return nil
        }
        return items[0][indexPath.row]
//        return items[indexPath.section][indexPath.row]
    }
    
    public func updateItem(at indexPath: IndexPath, value: T) {
        guard indexPath.section >= 0 &&
            indexPath.section < items.count &&
            indexPath.row >= 0 &&
            indexPath.row < items[indexPath.section].count else
        {
            let index = indexPath.row - items[0].count
            items[1][index] = value
            return
        }
        items[0][indexPath.row] = value
//        items[indexPath.section][indexPath.row] = value
    }
    
    public func removeItem(at indexPath: IndexPath) {
        guard indexPath.section >= 0 &&
            indexPath.section < items.count &&
            indexPath.row >= 0 &&
            indexPath.row < items[indexPath.section].count else
        {
            let index = indexPath.row - items[0].count
            items[1].remove(at: index)
            return
        }
        items[0].remove(at: indexPath.row)
//        items[indexPath.section].remove(at: indexPath.row)
    }
    
    public func insertItem(at indexPath: IndexPath, value: T) {
        guard indexPath.section >= 0 &&
            indexPath.section < items.count &&
            indexPath.row >= 0 &&
            indexPath.row < items[indexPath.section].count else
        {
            let index = indexPath.row - items[0].count
            if items.count > 1 {
            items[1].insert(value, at: index)
            } else {
                items[0].insert(value, at: indexPath.row)
            }
            return
        }
        items[0].insert(value, at: indexPath.row)
//        items[indexPath.section].insert(value, at: indexPath.row)
    }
}

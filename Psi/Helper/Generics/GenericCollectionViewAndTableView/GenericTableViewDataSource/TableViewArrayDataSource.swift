//
//  TableViewArrayDataSource.swift
//  PushInc
//
//  Created by Tayyab Ali on 6/26/20.
//  Copyright © 2020 Fantechlabs. All rights reserved.
//

import UIKit

open class TableViewArrayDataSource<T, Cell: UITableViewCell>: TableViewDataSource<ArrayDataProvider<T>, Cell>
    where Cell: ConfigurableCell, Cell.T == T
{
    // MARK: - Lifecycle
    public convenience init(tableView: UITableView, array: [T]) {
        self.init(tableView: tableView, array: [array])
    }

    public init(tableView: UITableView, array: [[T]]) {
        let provider = ArrayDataProvider(array: array)
        super.init(tableView: tableView, provider: provider)
    }

    // MARK: - Public Methods
    public func item(at indexPath: IndexPath) -> T? {
        return provider.item(at: indexPath)
    }

    public func updateItem(at indexPath: IndexPath, value: T) {
        provider.updateItem(at: indexPath, value: value)
    }
}

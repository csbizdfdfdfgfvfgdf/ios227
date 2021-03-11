//
//  TableViewDataSource.swift
//  PushInc
//
//  Created by Tayyab Ali on 6/26/20.
//  Copyright © 2020 Fantechlabs. All rights reserved.
//

import UIKit


open class TableViewDataSource<Provider: CollectionDataProvider, Cell: UITableViewCell>:
    NSObject,
    UITableViewDataSource,
    UITableViewDelegate
    where Cell: ConfigurableCell, Provider.T == Cell.T
{
    // MARK: - Delegates
    public var loadFromBottom: (()-> Void)?
    var delegate: ItemsOrderChangedDelegate?

    // MARK: - Private Properties
    let provider: Provider
    let tableView: UITableView
    let actionsProxy = CellActionProxy()

    // MARK: - Lifecycle
    init(tableView: UITableView, provider: Provider) {
        self.tableView = tableView
        self.provider = provider
        super.init()
        setUp()
    }
    
    func setUp() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return provider.numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provider.numberOfItems(in: section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: Cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        let item = provider.item(at: indexPath)
        if let item = item {
            cell.configure(item, at: indexPath)
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actionsProxy.invoke(action: .didSelect, indexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [])
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {}
    
//    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == provider.numberOfItems(in: indexPath.section) - 1 {
//            print("At Bottom")
//            loadFromBottom?()
//        }
//    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let movedObject = provider.item(at: sourceIndexPath) {
            provider.removeItem(at: sourceIndexPath)
            provider.insertItem(at: destinationIndexPath, value: movedObject)
            self.delegate?.itemsOrderChanged(provider: provider as Any)
            print("Object moved: \(movedObject)")
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight =  scrollView.contentSize.height
        
        if offSetY > contentHeight - scrollView.frame.height {
            print("At Bottom")
            loadFromBottom?()
        }
    }
}

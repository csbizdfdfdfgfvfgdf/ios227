//
//  CollectionDataSource.swift
//  PushInc
//
//  Created by Tayyab Ali on 6/25/20.
//  Copyright © 2020 Fantechlabs. All rights reserved.
//

import UIKit

open class CollectionDataSource<Provider: CollectionDataProvider, Cell: UICollectionViewCell>:
    NSObject,
    UICollectionViewDataSource,
    UICollectionViewDelegate
    where Cell: ConfigurableCell, Provider.T == Cell.T
{
    // MARK: - Delegates
//    public var collectionItemSelectionHandler: ((IndexPath) -> Void)?

    // MARK: - Private Properties
    let provider: Provider
    let collectionView: UICollectionView
    let actionsProxy = CellActionProxy()

    // MARK: - Lifecycle
    init(collectionView: UICollectionView, provider: Provider) {
        self.collectionView = collectionView
        self.provider = provider
        super.init()
        setUp()
        
    }

    func setUp() {
        collectionView.dataSource = self
        collectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(onActionEvent(n:)), name: CellAction.notificationName, object: nil)

    }
    
    deinit {
        print("Remove Action Observer")
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IBActions
    @objc fileprivate func onActionEvent(n: Notification) {
        if let eventData = n.userInfo?["data"] as? CellActionEventData,
            let cell = eventData.cell as? UICollectionViewCell,
            let indexPath = self.collectionView.indexPath(for: cell) {
            actionsProxy.invoke(action: eventData.action, indexPath: indexPath)
        }
    }

    // MARK: - UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return provider.numberOfSections()
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provider.numberOfItems(in: section)
    }

    open func collectionView(_ collectionView: UICollectionView,
         cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier,
            for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        let item = provider.item(at: indexPath)
        if let item = item {
            cell.configure(item, at: indexPath)
        }
        return cell
    }

    open func collectionView(_ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView
    {
        return UICollectionReusableView(frame: CGRect.zero)
    }

    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionItemSelectionHandler?(indexPath)
        actionsProxy.invoke(action: .didSelect, indexPath: indexPath)
    }
    
//    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        let screenSize = UIScreen.main.bounds
//
//        let pageIndex = Int(targetContentOffset.pointee.x / screenSize.width)
//        pageController.currentPage = pageIndex
//    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        actionsProxy.invoke(action: .scrollViewDidEndDecelerating, indexPath: indexPath)

    }
}

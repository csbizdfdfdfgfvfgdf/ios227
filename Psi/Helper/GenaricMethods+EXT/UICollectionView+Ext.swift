//
//  UICollectionView+Ext.swift
//  Marmalade
//
//  Created by Tayyab Ali on 19/10/2019.
//  Copyright © 2019 Tayyab Ali. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableCell {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableCell, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)

        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }
}

//extension UICollectionView {
//    func setEmptyMessage(_ message: String) {
//        let emptyView = EmptyView()
//        emptyView.setMessage(message)
//        self.backgroundView = emptyView
//    }
//    
//    func restore() {
//        self.backgroundView = nil
//    }
//}

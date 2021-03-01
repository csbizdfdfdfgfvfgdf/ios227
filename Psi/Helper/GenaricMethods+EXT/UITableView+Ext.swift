//
//  UITableView+Ext.swift
//  Marmalade
//
//  Created by Tayyab Ali on 19/10/2019.
//  Copyright © 2019 Tayyab Ali. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableCell {
        print(T.reuseIdentifier)
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewCell>(_: T.Type) where T: ReusableCell, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)

    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableCell {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }
}

//extension UITableView {
//    func setEmptyMessage(_ message: String) {
//        let emptyView = EmptyView()
//        emptyView.setMessage(message)
//        self.backgroundView = emptyView
//        self.separatorStyle = .none
//    }
//    
//    func restore() {
//        self.backgroundView = nil
//    }
//    
//    func restoreWithSeparator() {
//        restore()
//        self.separatorStyle = .singleLine
//    }
//}

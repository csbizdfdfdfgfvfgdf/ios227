//
//  CellAction.swift
//  Dropryde
//
//  Created by Tayyab Ali on 8/10/20.
//  Copyright © 2020 Uzair Mughal. All rights reserved.
//

import UIKit

enum CellAction {
    
    case didSelect
    case willDisplay
    case scrollViewDidEndDecelerating
    case swipeToDelete
    case swipeToEdit
    case custom(String)
    
    //hashable
    public var hashValue: Int {
        switch self {
        case .didSelect:
            return 1
        case .willDisplay:
            return 2
        case .scrollViewDidEndDecelerating:
            return 3
        case .swipeToDelete:
            return 4
        case .swipeToEdit:
            return 5
        case .custom(let custom):
            return custom.hashValue
        }
    }
    
    public static func ==(lhs: CellAction, rhs: CellAction) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension CellAction {
    static let notificationName = NSNotification.Name(rawValue: "CellAction")
    
    public func invoke(cell: UIView) {
        NotificationCenter.default.post(name: CellAction.notificationName,
                                        object: nil,
                                        userInfo: ["data": CellActionEventData(action: self, cell: cell)])
    }
}

class CellActionProxy {

    private var actions = [String: ((IndexPath) -> Void)]()
    
    func invoke(action: CellAction, indexPath: IndexPath) {
        let key = "\(action.hashValue)"
        if let action = self.actions[key] {
            action(indexPath)
        }
    }
    
    @discardableResult
    func on(_ action: CellAction, handler: @escaping ((IndexPath) -> Void)) -> Self {
        let key = "\(action.hashValue)"
        self.actions[key] = { indexPath in
            handler(indexPath)
        }
        return self
    }
}

struct CellActionEventData {
    let action: CellAction
    let cell: UIView
}

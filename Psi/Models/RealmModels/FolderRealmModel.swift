//
//  FolderRealmModel.swift
//  Psi
//
//  Created by Tayyab Ali on 12/29/20.
//

import RealmSwift

class FolderRealmModel: Object {
    
    @objc dynamic var menuId: Int64 = 0
    @objc dynamic var menuName: String = ""
    @objc dynamic var pId: Int64 = 0
    
    override class func primaryKey() -> String? {
        return "menuId"
    }
    
    convenience init(menuId: Int64?, menuName: String, pId: Int64) {
        self.init()
        self.menuId = menuId ?? Swift.Int64(UUID().hashValue)
        self.menuName = menuName
        self.pId = pId
    }
}

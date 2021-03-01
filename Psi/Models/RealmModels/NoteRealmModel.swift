//
//  NoteRealmModel.swift
//  Psi
//
//  Created by Tayyab Ali on 12/29/20.
//

import RealmSwift

class NoteRealmModel: Object {
    
    @objc dynamic var itemId: Int64 = 0
    @objc dynamic var content: String = ""
    @objc dynamic var pId: Int64 = 0
    
    override class func primaryKey() -> String? {
        return "itemId"
    }
    
    convenience init(itemId: Int64?, content: String, pId: Int64) {
        self.init()
        self.itemId = itemId ?? Int64(UUID().hashValue)
        self.content = content
        self.pId = pId
    }
}

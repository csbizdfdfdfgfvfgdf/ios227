//
//  FolderModel.swift
//  Psi
//
//  Created by Tayyab Ali on 12/23/20.
//

import Foundation

class FolderModel: Codable {

    var menuId: Int64?
    var menuName: String?
    var orderId: Int?
    var pId: Int64?
    var uId: Int64?
    var userName: String?
    var userType: Int?
    
    enum CodingKeys: String, CodingKey {
        case menuId
        case menuName
        case orderId
        case pId
        case uId
        case userName
        case userType
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        menuId = try values.decodeIfPresent(Int64.self, forKey: .menuId)
        menuName = try values.decodeIfPresent(String.self, forKey: .menuName)
        orderId = try values.decodeIfPresent(Int.self, forKey: .orderId)
        pId = try values.decodeIfPresent(Int64.self, forKey: .pId)
        uId = try values.decodeIfPresent(Int64.self, forKey: .uId)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        userType = try values.decodeIfPresent(Int.self, forKey: .userType)
    }
}

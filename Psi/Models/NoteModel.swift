//
//  NoteModel.swift
//  Psi
//
//  Created by Tayyab Ali on 12/26/20.
//

import Foundation

class NoteModel: Codable {
    
    var itemId: Int64?
    var content: String?
    var orderId: Int?
    var pId: Int64?
    var uId: Int64?
    var userName: String?
    
    enum CodingKeys: String, CodingKey {
        case itemId
        case content
        case orderId
        case pId
        case uId
        case userName
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        itemId = try values.decodeIfPresent(Int64.self, forKey: .itemId)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        orderId = try values.decodeIfPresent(Int.self, forKey: .orderId)
        pId = try values.decodeIfPresent(Int64.self, forKey: .pId)
        uId = try values.decodeIfPresent(Int64.self, forKey: .uId)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
    }
}

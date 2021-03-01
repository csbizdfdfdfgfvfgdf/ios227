//
//  ResponseModel.swift
//  Psi
//
//  Created by Tayyab Ali on 12/23/20.
//

import Foundation

struct ResponseModel: Decodable {
    let message: String
    let UUID: String

    enum CodingKeys: String, CodingKey {
        case message
        case UUID = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        UUID = try values.decodeIfPresent(String.self, forKey: .UUID) ?? ""
    }
}

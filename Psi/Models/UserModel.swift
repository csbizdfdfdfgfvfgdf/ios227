//
//  UserModel.swift
//  Psi
//
//  Created by Tayyab Ali on 12/21/20.
//

import Foundation

class UserModel: Codable {

    var userId: Int64?
    var userName: String?
    var email: String?
    var password: String?
    var confirmPassword: String?
    var phone: String?
    var userType: String?
    var created: String?
    var updated: String?
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case userName
        case email
        case password
        case confirmPassword
        case phone
        case userType
        case created
        case updated
        case token
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decodeIfPresent(Int64.self, forKey: .userId)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        confirmPassword = try values.decodeIfPresent(String.self, forKey: .confirmPassword)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        updated = try values.decodeIfPresent(String.self, forKey: .updated)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }

//    init(userVM: UserViewModel) {
//        self.userId = userVM.userId
//        self.userName = userVM.userName
//        self.email = userVM.email
//        self.password = userVM.password
//        self.confirmPassword = userVM.confirmPassword
//        self.phone = userVM.phone
//        self.userType = userVM.userType.rawValue
//        self.created = userVM.created
//        self.updated = userVM.updated
//    }
}

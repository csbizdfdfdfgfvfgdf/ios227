//
//  MTStore.swift
//  Dropryde
//
//  Created by Tayyab Ali on 9/8/20.
//  Copyright © 2020 Uzair Mughal. All rights reserved.
//

import Foundation

class MTStore {
    
    private var userDefault = UserDefaults.standard
    enum UserDefaultKeys: String {
        var getString: String {
            self.rawValue
        }
        
        case uuid
        case authToken
        case isUserLoggedIn
        case isTipViewHide
    }
    
    func getBool(key: UserDefaultKeys) -> Bool {
        userDefault.bool(forKey: key.getString)
    }
    
    func setBool(_ status: Bool, key: UserDefaultKeys) {
        userDefault.set(status, forKey: key.getString)
    }
    
    func getAuthToken() -> String {
        userDefault.string(forKey: UserDefaultKeys.authToken.getString) ?? ""
    }
    
    func setAuthToken(_ token: String) {
        userDefault.set(token, forKey: UserDefaultKeys.authToken.getString)
    }
    
    func getUuid() -> String {
        userDefault.string(forKey: UserDefaultKeys.uuid.getString) ?? ""
    }
    
    func setUuid(_ token: String) {
        userDefault.set(token, forKey: UserDefaultKeys.uuid.getString)
    }
}


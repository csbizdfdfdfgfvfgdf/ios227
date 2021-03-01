//
//  AppManager.swift
//  Orb App
//
//  Created by Umair on 28/11/2020.
//  Copyright © 2020 Infinite. All rights reserved.
//

import UIKit

class AppManager {
    
    var user: UserViewModel = UserViewModel()
    var selectedFolder: FolderViewModel?
    var selectedNote: NoteViewModel?
    var selectedOption: FlotingButtons?

    fileprivate static let _sharedManager = AppManager()
    
    class var shared : AppManager {
        return _sharedManager
    }
    func resetAllSharedProperties() {
        MTStore().setAuthToken("")
        user = UserViewModel()
    }
}

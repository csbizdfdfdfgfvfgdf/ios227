//
//  RealmManager.swift
//  Psi
//
//  Created by Tayyab Ali on 12/29/20.
//

import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    let config = RealmSwift.Realm.Configuration(
        // Set the new schema version. This must be greater than the previously used
        // version (if you've never set a schema version before, the version is 0).
        schemaVersion: 1,
     
        // Set the block which will be called automatically when opening a Realm with
        // a schema version lower than the one set above
        migrationBlock: { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            if (oldSchemaVersion < 1) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        })

    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    // MARK: - Folders
    func getFoldersFromRealm(pId: Int64) -> [FolderRealmModel]{
        
       // Tell Realm to use this new configuration object for the default Realm
       Realm.Configuration.defaultConfiguration = config

        print(Realm.Configuration.defaultConfiguration.fileURL!)

        let folders =  realm.objects(FolderRealmModel.self).filter("pId == \(pId)")
        
        return folders.compactMap({$0})
    }
    
    func createOrUpdateFolder(realmFolder: FolderRealmModel, successCallBack: @escaping ()-> Void) {
        try! realm.safeWrite {
            realm.add(realmFolder, update: .modified)
            DispatchQueue.main.async {
                successCallBack()
            }
        }
    }
    
    func deleteFolder(menuId: Int64, successCallBack: @escaping ()-> Void) {
        try! realm.safeWrite {
            guard let folderData =  realm.objects(FolderRealmModel.self).filter("menuId == \(menuId)").first else {
                return
            }

            realm.delete(folderData)
            successCallBack()
        }
    }
    
    func getNotesFromRealm(folderId: Int64) -> [NoteRealmModel]{
        let notes =  realm.objects(NoteRealmModel.self).filter("pId == \(folderId)")
        
        return notes.compactMap({$0})
    }
    
    func createOrUpdateNote(realmNote: NoteRealmModel, successCallBack: @escaping ()-> Void) {
        try! realm.safeWrite {
            realm.add(realmNote, update: .modified)
            DispatchQueue.main.async {
                successCallBack()
            }
        }
    }
    
    func deleteNote(itemId: Int64, successCallBack: @escaping ()-> Void) {
        try! realm.safeWrite {
            guard let noteData =  realm.objects(NoteRealmModel.self).filter("itemId == \(itemId)").first else {
                return
            }

            realm.delete(noteData)
            successCallBack()
        }
    }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}

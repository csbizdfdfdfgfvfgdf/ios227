//
//  FolderListViewModel.swift
//  Psi
//
//  Created by Tayyab Ali on 12/23/20.
//

import Foundation

struct FolderListViewModel {
    
    var indecatorDelegate: IndecatorDelegate?
    var folderList = [FolderViewModel]()
    
    mutating func updateFolderList(folders: [FolderViewModel]) {
        self.folderList = folders
    }
}

extension FolderListViewModel {
    
    func fetchFolders(menuId: Int64?, successCallBack: @escaping SuccessListener<[FolderViewModel]>) {
        
        // If User is not signin then load list from local DB
//        if AppManager.shared.user == nil {
//            let objects = RealmManager.shared.getFoldersFromRealm(pId: menuId ?? 0)
//            successCallBack(objects.map(FolderViewModel.init))
//            return
//        }
        
        indecatorDelegate?.didStartIndecator()

        NetworkManager.shared.genericMethodCall(target: .getFolders(menuId: menuId)) { (result: Result<[FolderModel], Swift.Error>) in
            Services.hud.dismiss()
            
            switch result {
            
            case .success(let foldersList):
                successCallBack(foldersList.filter({$0.pId == menuId}).map(FolderViewModel.init).sorted())
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
    
    func createFolder(name: String, folderId: Int64?, successCallBack: @escaping SuccessListener<[FolderViewModel]>) {
        
        // If User is not signin then create Folder in local DB
//        if AppManager.shared.user == nil {
//            let realmFolderModel = FolderRealmModel(menuId: nil, menuName: name, pId: folderId ?? 0)
//            RealmManager.shared.createOrUpdateFolder(realmFolder: realmFolderModel) {
//                successCallBack(FolderViewModel(realmFolderModel))
//            }
//            return
//        }
        
//        var updatedList = self.folderList
        
        var folder = FolderViewModel()
        folder.menuName = name
        folder.parentFolderId = folderId
        folder.orderId = self.folderList.count + 1
        
//        if updatedList.isEmpty {
//            updatedList.append(folder)
//        } else {
//            updatedList.insert(folder, at: 0)
//        }
//
        indecatorDelegate?.didStartIndecator()

        NetworkManager.shared.genericMethodCall(target: .createFolder(list: [folder])/*(name: name, folderId: folderId, orderId: orderId)*/) { (result: Result<[FolderModel], Swift.Error>) in
            Services.hud.dismiss()
            
            switch result {
            
            case .success(let foldersList):
//                guard let folderData = folderData.first else {
//                    return
//                }
                successCallBack(foldersList.map(FolderViewModel.init).sorted())
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
    
    func updateFolder(at index: Int, folderVM: FolderViewModel, successCallBack: @escaping SuccessListener<[FolderViewModel]>) {
        
//        // If User is not signin then Update Folder in local DB
//        if AppManager.shared.user == nil {
//            let realmFolderModel = FolderRealmModel(menuId: self.menuId, menuName: self.menuName, pId: self.pId)
//            RealmManager.shared.createOrUpdateFolder(realmFolder: realmFolderModel) {
//                successCallBack(FolderViewModel(realmFolderModel))
//            }
//            return
//        }

        var updatedFolders = self.folderList
        updatedFolders[index] = folderVM
        
        indecatorDelegate?.didStartIndecator()

        NetworkManager.shared.genericMethodCall(target: .updateFolder(list: updatedFolders)/*(name: self.menuName, folderId: self.folderId, toFolderId: nil)*/) { (result: Result<[FolderModel], Swift.Error>) in
            Services.hud.dismiss()
            
            switch result {
            
            case .success(let foldersList):
//                self.setData(folderData)
//                guard let folderData = folderData.first else {
//                    return
//                }
                successCallBack(foldersList.map(FolderViewModel.init).sorted())
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
    
    func moveFolder(at newIndex: Int?, parentFolderID: Int64?, successCallBack: @escaping SuccessListener<[FolderViewModel]>) {

        guard var cutFolder = AppManager.shared.selectedFolder else {
            return
        }
        
        cutFolder.parentFolderId = parentFolderID
        
        var updatedFolders = self.folderList
        if let cuttedFolderIndex = self.folderList.firstIndex(where: {$0.folderId == cutFolder.folderId}) {
            updatedFolders.remove(at: cuttedFolderIndex)
        }
        
        if newIndex == nil {
            updatedFolders.append(cutFolder)
        } else {
            updatedFolders.insert(cutFolder, at: newIndex!)
        }
//
//        // If User is not signin then Move Folder from local DB
//        if AppManager.shared.user == nil {
//
//            // Add foler to new folder
//            let realmFolderModel = FolderRealmModel(menuId: AppManager.shared.selectedOption == .copy ? nil :  cutFolder.menuId, menuName: cutFolder.menuName, pId: toFolderId)
//            RealmManager.shared.createOrUpdateFolder(realmFolder: realmFolderModel) {
//                successCallBack(FolderViewModel(realmFolderModel))
//            }
//            return
//        }

        indecatorDelegate?.didStartIndecator()

        NetworkManager.shared.genericMethodCall(target: .updateFolder(list: updatedFolders)/*.updateFolder(name: cutFolder.menuName, folderId: cutFolder.folderId, toFolderId: toFolderId)*/) { (result: Result<[FolderModel], Swift.Error>) in
            Services.hud.dismiss()

            switch result {

            case .success(let foldersList):
//                self.setData(folderData)
//                guard let folderData = folderData.first else {
//                    return
//                }
                successCallBack(foldersList.map(FolderViewModel.init).sorted())
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
}

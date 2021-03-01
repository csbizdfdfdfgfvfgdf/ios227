//
//  FolderViewModel.swift
//  Psi
//
//  Created by Tayyab Ali on 12/23/20.
//

import Foundation

struct FolderViewModel {
    var indecatorDelegate: IndecatorDelegate?

    var folderId: Int64?
    var menuName: String = ""
    var orderId: Int = 0
//    var pId: Int64 = 0
    var parentFolderId: Int64?
    
    init(_ item: FolderModel) {
        self.folderId = item.menuId ?? 0
        self.menuName = item.menuName ?? ""
        self.orderId = item.orderId ?? 0
        self.parentFolderId = item.pId
    }
    
    
//    init(_ item: FolderRealmModel) {
//        self.folderId = item.menuId
//        self.menuName = item.menuName
//        self.pId = item.pId
//    }
    
    init() {
        
    }
}

// MARK: - Fetch User Detail
extension FolderViewModel {
    
    func deleteFolder(successCallBack: @escaping ()-> Void) {
        
//        // If User is not signin then Delete Folder from local DB
//        if AppManager.shared.user == nil {
//            RealmManager.shared.deleteFolder(menuId: self.menuId, successCallBack: successCallBack)
//            return
//        }
        
        indecatorDelegate?.didStartIndecator()

        NetworkManager.shared.genericMethodCall(target: .deleteFolder(id: self.folderId ?? 0)) { (result: Result<FolderModel, Swift.Error>) in
            Services.hud.dismiss()
            
            switch result {
            
            case .success(_):
                successCallBack()
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
}

extension FolderViewModel: Comparable {
    static func < (lhs: FolderViewModel, rhs: FolderViewModel) -> Bool {
        lhs.orderId < rhs.orderId
    }
    
    static func == (lhs: FolderViewModel, rhs: FolderViewModel) -> Bool {
        lhs.folderId == rhs.folderId
    }
}

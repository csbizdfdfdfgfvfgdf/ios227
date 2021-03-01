//
//  FolderOrNoteListViewModel.swift
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
        
        indecatorDelegate?.didStartIndecator()

        NetworkManager.shared.genericMethodCall(target: .getFolders(menuId: menuId)) { (result: Result<[FolderModel], Swift.Error>) in
            Services.hud.dismiss()
            
            switch result {
            
            case .success(let folderOrNotesList):
//                updateFolderList(folders: folderOrNotesList.filter({$0.pId == menuId}).map(FolderViewModel.init))
                successCallBack(folderOrNotesList.filter({$0.pId == menuId}).map(FolderViewModel.init))
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
}

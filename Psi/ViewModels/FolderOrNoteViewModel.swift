//
//  FolderViewModel.swift
//  Psi
//
//  Created by Tayyab Ali on 12/23/20.
//

import Foundation

class FolderViewModel {
    var indecatorDelegate: IndecatorDelegate?

    var menuId: Int64 = 0
    var menuName: String = ""
    var orderId: Int = 0
    var pId: Int64 = 0
//    var uId: Int64 = 0
//    var userName: String = ""
//    var userType: Int = 0
    
    init(_ item: FolderOrNoteModel) {
        self.menuId = item.menuId ?? 0
        self.menuName = item.menuName ?? ""
        self.orderId = item.orderId ?? 0
        self.pId = item.pId ?? 0
//        self.uId = item.uId ?? 0
//        self.userName = item.userName ?? ""
//        self.userType = item.userType ??
        
    }
    
    fileprivate func setData(_ item: FolderOrNoteModel) {
        self.menuId = item.menuId ?? 0
        self.menuName = item.menuName ?? ""
        self.orderId = item.orderId ?? 0
        self.pId = item.pId ?? 0
    }
}

// MARK: - Fetch User Detail
extension FolderViewModel {
    
    func createFolder(name: String, pId: Int?, successCallBack: @escaping ()-> Void) {
        
        indecatorDelegate?.didStartIndecator()

        NetworkManager.shared.genericMethodCall(target: .createFolder(name: name, pId: pId)) { (result: Result<FolderOrNoteModel, Swift.Error>) in
            
            switch result {
            
            case .success(let folderData):
                self.setData(folderData)
                successCallBack()
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
}

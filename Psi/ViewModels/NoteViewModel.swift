//
//  NoteViewModel.swift
//  Psi
//
//  Created by Tayyab Ali on 12/26/20.
//

import Foundation

struct NoteViewModel {
    var indecatorDelegate: IndecatorDelegate?
    
    var itemId: Int64 = 0
    var content: String = ""
    var orderId: Int?
    var pId: Int64?
    
    init(_ item: NoteModel) {
        self.itemId = item.itemId ?? 0
        self.content = item.content ?? ""
        self.orderId = item.orderId
        self.pId = item.pId
    }
    
    init(content: String, pId: Int64?, itemId: Int64 = 0, orderId: Int?) {
        self.content = content
        self.pId = pId
        self.itemId = itemId
        self.orderId = orderId
    }
    
    init(_ item: NoteRealmModel) {
        self.content = item.content
        self.pId = item.pId
        self.itemId = item.itemId
    }
    
    init() {
        
    }
}

// MARK: - Fetch User Detail
extension NoteViewModel {
    
    func deleteNote(successCallBack: @escaping ()-> Void) {
//
//        // If User is not signin then Delete Note from local DB
//        if AppManager.shared.user == nil {
//            RealmManager.shared.deleteNote(itemId: self.itemId, successCallBack: successCallBack)
//            return
//        }
//
        indecatorDelegate?.didStartIndecator()
        
        NetworkManager.shared.genericMethodCall(target: .deleteNote(id: self.itemId)) { (result: Result<NoteModel, Swift.Error>) in
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

extension NoteViewModel: Comparable {
    static func < (lhs: NoteViewModel, rhs: NoteViewModel) -> Bool {
        lhs.orderId ?? 0 < rhs.orderId ?? 0
    }
    
    static func == (lhs: NoteViewModel, rhs: NoteViewModel) -> Bool {
        lhs.itemId == rhs.itemId
    }
}

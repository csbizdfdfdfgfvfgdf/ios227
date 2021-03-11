//
//  NotesListViewModel.swift
//  Psi
//
//  Created by Tayyab Ali on 12/26/20.
//

import Foundation

class NotesListViewModel {
    
    var indecatorDelegate: IndecatorDelegate?
    var notesList = [NoteViewModel]()
}

extension NotesListViewModel {
    
    func fetchNotes(folderId: Int64, successCallBack: @escaping SuccessListener<Void>) {
        
        // If User is not signin then load list from local DB
//        if AppManager.shared.user == nil {
//            let objects = RealmManager.shared.getNotesFromRealm(folderId: folderId)
//            self.notesList = objects.map(NoteViewModel.init)
//            successCallBack(())
//            return
//        }
        
        indecatorDelegate?.didStartIndecator()

        NetworkManager.shared.genericMethodCall(target: .getNotes(folderId: folderId)) { (result: Result<[NoteModel], Swift.Error>) in
            Services.hud.dismiss()
            
            switch result {
            
            case .success(let notesList):
                self.notesList = notesList.map(NoteViewModel.init).sorted()
                successCallBack(())
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
    
    func fetchNotesInRootScreen(successCallBack: @escaping SuccessListener<Void>) {
        
        // If User is not signin then load list from local DB
//        if AppManager.shared.user == nil {
//            let objects = RealmManager.shared.getNotesFromRealm(folderId: 0)
//            self.notesList = objects.map(NoteViewModel.init)
//            successCallBack(())
//            return
//        }
        
        indecatorDelegate?.didStartIndecator()

        NetworkManager.shared.genericMethodCall(target: .getNotesOnRootScreen) { (result: Result<[NoteModel], Swift.Error>) in
            Services.hud.dismiss()
            
            switch result {
            
            case .success(let notesList):
                self.notesList = notesList.map(NoteViewModel.init).sorted()
                successCallBack(())
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
    
    func createNote(note: NoteViewModel, successCallBack: @escaping SuccessListener<[NoteViewModel]>) {
        
//        // If User is not signin then create Note in local DB
//        if AppManager.shared.user == nil {
//            let realmNoteModel = NoteRealmModel(itemId: nil, content: self.content, pId: self.pId ?? 0)
//            RealmManager.shared.createOrUpdateNote(realmNote: realmNoteModel) {
//                successCallBack(NoteViewModel(realmNoteModel))
//            }
//            return
//        }
        
//        var updatedNotes = self.notesList
//
//        var note = NoteViewModel()
//        note.content = content
//        note.pId = parentFolderId
        
//        if updatedNotes.isEmpty {
//            updatedNotes.append(note)
//        } else {
//            updatedNotes.insert(note, at: 0)
//        }

        indecatorDelegate?.didStartIndecator()
        NetworkManager.shared.genericMethodCall(target: .createNote(list: [note])/*(content: self.content, folderId: self.pId)*/) { (result: Result<[NoteModel], Swift.Error>) in
            Services.hud.dismiss()
            
            switch result {
            
            case .success(let notes):
//                guard let noteData = noteData.first else {
//                    return
//                }
                successCallBack(notes.map(NoteViewModel.init).sorted())
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
    
    func updateNote(note: NoteViewModel, successCallBack: @escaping SuccessListener<[NoteViewModel]>) {
        
//        // If User is not signin then Update Note in local DB
//        if AppManager.shared.user == nil {
//            let realmNoteModel = NoteRealmModel(itemId: self.itemId, content: self.content, pId: self.pId ?? 0)
//            RealmManager.shared.createOrUpdateNote(realmNote: realmNoteModel) {
//                successCallBack(NoteViewModel(realmNoteModel))
//            }
//            return
//        }
//
//        var note = NoteViewModel()
//        note.itemId = noteId
//        note.content = content
//        note.pId = parentFolderId

        var updatedNotes = self.notesList
        
        guard let index = updatedNotes.firstIndex(of: note) else {
            return
        }
        updatedNotes[index] = note

        indecatorDelegate?.didStartIndecator()
        
        NetworkManager.shared.genericMethodCall(target: .updateNote(list: updatedNotes)/*(content: self.content, folderId: self.pId ?? 0, noteId: self.itemId, orderId: self.orderId)*/) { (result: Result<[NoteModel], Swift.Error>) in
            Services.hud.dismiss()
            
            switch result {
            
            case .success(let notes):
                successCallBack(notes.map(NoteViewModel.init).sorted())
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
    
//    func moveNote(at newIndex: Int?, toFolderId: Int64?, successCallBack: @escaping SuccessListener<[NoteViewModel]>) {
    func moveNote(at newIndex: Int?, toFolderId: Int64?, array: [[Any]]?, successCallBack: @escaping SuccessListener<[NoteViewModel]>, updatedArray: @escaping ([[Any]]?)->Void) {
        var array = array ?? []
        
        guard var cutNote = AppManager.shared.selectedNote else {
            return
        }
        
        cutNote.pId = toFolderId
//        // If User is not signin then Move Folder from local DB
//        if AppManager.shared.user == nil {
//
//            // Add Note to new folder
//            let realmNoteModel = NoteRealmModel(itemId: AppManager.shared.selectedOption == .copy ? nil : cutNote.itemId, content: cutNote.content, pId: toFolderId)
//            RealmManager.shared.createOrUpdateNote(realmNote: realmNoteModel) {
//                successCallBack(NoteViewModel(realmNoteModel))
//            }
//            return
//        }
        
        var updatedNotes = self.notesList

        if let index = self.notesList.firstIndex(where: {$0.itemId == cutNote.itemId}) {
            updatedNotes.remove(at: index)
        }

        if newIndex == nil {
            updatedNotes.append(cutNote)
        } else {
            if let newIndex = newIndex, newIndex > updatedNotes.count {
                let ind = updatedNotes.count
                updatedNotes.insert(cutNote, at: ind)
            } else {
            updatedNotes.insert(cutNote, at: newIndex!)
            }
        }
        
        var arrayNoteList: [NoteViewModel] = []
        for arr in array {
            for ar in arr {
                if let folder = ar as? NoteViewModel {
                    arrayNoteList.append(folder)
                } else {
                    arrayNoteList.append(NoteViewModel())
                }
            }
        }
        let index = array.count > 1 ? 1 : 0
        if let cuttedNoteIndex = arrayNoteList.firstIndex(where: {$0.itemId == cutNote.itemId}) {
            array[index].remove(at: cuttedNoteIndex)
        }
        
        if newIndex == nil {
            array[index].append(cutNote)
        } else {
            array[index].insert(cutNote, at: newIndex!)
        }
        
        indecatorDelegate?.didStartIndecator()
        
        NetworkManager.shared.genericMethodCall(target: .updateNote(list: updatedNotes)/*(content: cutNote.content, folderId: toFolderId, noteId: cutNote.itemId, orderId: 0)*/) { (result: Result<[NoteModel], Swift.Error>) in
            Services.hud.dismiss()
            
            switch result {
            
            case .success(let notes):
                successCallBack(notes.map(NoteViewModel.init).sorted())
                updatedArray(array)
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
}

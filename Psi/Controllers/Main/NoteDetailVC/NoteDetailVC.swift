//
//  NoteDetailVC.swift
//  Psi
//
//  Created by Tayyab Ali on 12/22/20.
//

import UIKit

class NoteDetailVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textView: UITextView!

    // MARK: - Class Properties
    var noteVM: NoteViewModel!
    var delegate: CreateOrUpdateNoteVCDelegate?
    var noteListVM: NotesListViewModel!

    override func setupGUI() {
        // Start Up
        initialSetup()
    }
}

// MARK: - Class Methods
extension NoteDetailVC {
    
    fileprivate func initialSetup() {
        
        navigationItem.title = "Detail"
        textView.text = noteVM.content
        navbarMoreButton()
    }
    
    fileprivate func navbarMoreButton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more-ic"), style: .done, target: self, action: #selector(moreButtonPressed))
    }
}

// MARK: - IBActions
extension NoteDetailVC {
    
    @objc func moreButtonPressed(_ sender: UIBarButtonItem) {
        let editNote = UIAlertAction(title: "Edit Note", style: .default) { (_) in
            self.loadCreateOrUpdateNoteVC(isEditing: true, noteVM: self.noteVM, folderId: self.noteVM.pId, notesListVM: self.noteListVM)
        }
        
        let deleteNote = UIAlertAction(title: "Delete Note", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
            self.delegate?.deleteNote(self.noteVM)
        }
        
        let cancel = UIAlertAction(title: StringsConstants.cancel.getString, style: .cancel, handler: nil)
        
        Services.showAlert(style: .actionSheet, title: nil, message: nil, actions: [editNote, deleteNote, cancel])
    }
}

// MARK: - CreateOrUpdateNoteVCDelegate
extension NoteDetailVC: CreateOrUpdateNoteVCDelegate {

    func noteCreated(_ notes: [NoteViewModel]) {}
    
    func noteUpdated(_ notes: [NoteViewModel]) {
        
        if let note = notes.first(where: {$0.itemId == self.noteVM.itemId}) {
            self.textView.text = note.content
        }
        self.delegate?.noteUpdated(notes)
    }
    
    func deleteNote(_ noteVM: NoteViewModel) {}
}

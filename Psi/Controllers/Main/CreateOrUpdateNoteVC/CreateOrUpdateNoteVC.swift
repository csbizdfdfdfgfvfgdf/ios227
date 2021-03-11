//
//  CreateOrUpdateNoteVC.swift
//  Psi
//
//  Created by Tayyab Ali on 12/22/20.
//

import UIKit

protocol CreateOrUpdateNoteVCDelegate {
    func noteCreated(_ notes: [NoteViewModel], newlyAdded: [NoteViewModel])
    func noteUpdated(_ notes: [NoteViewModel], newlyAdded: NoteViewModel)
    func deleteNote(_ noteVM: NoteViewModel)
}

class CreateOrUpdateNoteVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var textView: CustomTextView!
//    @IBOutlet weak var saveButton: UIButton!

    // MARK: - Class Properties
    var folderId: Int64?
    var delegate: CreateOrUpdateNoteVCDelegate?
    var noteData: NoteViewModel?
    var notesListVM: NotesListViewModel!
    
    override func setupGUI() {
        // Start Up
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    deinit {
        print("observer removed")
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Class Methods
extension CreateOrUpdateNoteVC {
    
    fileprivate func initialSetup() {
        
        navigationItem.title = isEditing ? "Update Note" : "Create Note"
        textView.text = isEditing ? noteData?.content : ""
        textView.addDoneOnKeyboardWithTarget(self, action: #selector(saveButtonPressed))
//        textView.keyboardDismissMode = .onDrag
//        textView.delegate = self
//        saveButton.bindToKeyboard()
    }
}

// MARK: - IBActions
extension CreateOrUpdateNoteVC {
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if textView.text!.isEmpty {
            Services.showErrorAlert(with: "Please write something")
            return
        }
        
        if isEditing {
            updateNote()
            return
        }
        
        createNote()
    }
}

// MARK: - Apis Methods
extension CreateOrUpdateNoteVC {

    fileprivate func createNote() {
        let noteVM = NoteViewModel(content: textView.text!, pId: folderId, orderId: self.notesListVM.notesList.count + 1)
        notesListVM.indecatorDelegate = self
        notesListVM.createNote(note: noteVM) { notesList in
            var notes = self.notesListVM.notesList
            notes.append(contentsOf: notesList)
            self.delegate?.noteCreated(notes, newlyAdded: notesList)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func updateNote() {
        let noteVM = NoteViewModel(content: textView.text!, pId: folderId, itemId: noteData!.itemId, orderId: noteData?.orderId)
        notesListVM.indecatorDelegate = self
        notesListVM.updateNote(note: noteVM) { notes in
            self.delegate?.noteUpdated(notes, newlyAdded: noteVM)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Indecator Delegate
extension CreateOrUpdateNoteVC: IndecatorDelegate {

    func didStartIndecator() {
        Services.startHudAnimation(title: "")
    }

    func didStop(withError errorMessage: String) {
        Services.showErrorAlert(with: errorMessage.html2String)
    }
}

// MARK: - UITextViewDelegate
//extension CreateOrUpdateNoteVC: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
//}

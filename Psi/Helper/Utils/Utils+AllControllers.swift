//
//  Utils+AllControllers.swift
//  SportLocator
//
//  Created by Tayyab ALi on 08/04/2019.
//  Copyright © 2019 Tayyab Ali. All rights reserved.
//

import UIKit
import MapKit

extension UIViewController {
    
    // MARK: - OnBoarding
    
    func loadLoginVC() {
        let vc: LoginVC = getViewController(sbName: .onBoarding, vcName: .LoginVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadSignUpVC() {
        let vc: SignUpVC = getViewController(sbName: .onBoarding, vcName: .SignUpVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Main
    
    func loadFolderAndNotesListVC(folderVM: FolderViewModel, isHomeScreen: Bool) {
        let vc: FolderAndNotesListVC = getViewController(sbName: .main, vcName: .FolderAndNotesListVC)
        vc.isHomeScreen = isHomeScreen
        vc.folderVM = folderVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadCreateOrUpdateNoteVC(isEditing: Bool = false, noteVM: NoteViewModel? = nil, folderId: Int64?, notesListVM: NotesListViewModel) {
        let vc: CreateOrUpdateNoteVC = getViewController(sbName: .main, vcName: .CreateOrUpdateNoteVC)
        vc.isEditing = isEditing
        vc.noteData = noteVM
        vc.folderId = folderId
        vc.notesListVM = notesListVM
        vc.delegate = self as? CreateOrUpdateNoteVCDelegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadNoteDetailVC(noteVM: NoteViewModel, noteListVM: NotesListViewModel) {
        let vc: NoteDetailVC = getViewController(sbName: .main, vcName: .NoteDetailVC)
        vc.noteVM = noteVM
        vc.noteListVM = noteListVM
        vc.delegate = self as? CreateOrUpdateNoteVCDelegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadSettingsVC() {
        let vc: SettingsVC = getViewController(sbName: .main, vcName: .SettingsVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

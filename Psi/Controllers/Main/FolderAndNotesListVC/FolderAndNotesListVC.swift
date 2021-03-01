//
//  FolderAndNotesListVC.swift
//  Psi
//
//  Created by Tayyab Ali on 12/21/20.
//

import UIKit

class FolderAndNotesListVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var tipStackView: UIStackView!

    // MARK: - Class Properties
    fileprivate var folderDataSource: FolderAndNotesDataSource?
    fileprivate var notesDataSource: FolderAndNotesDataSource?
    var isHomeScreen: Bool = true
    var folderListVM = FolderListViewModel()
    var folderVM: FolderViewModel?
    var touchPoint: CGPoint!
    var noteListVM = NotesListViewModel()
    
    var buttonsStackView = UIStackView()
    let overlayView = UIView()
    var floatingButtons = [UIButton]()
    var isLongPressOnTipView = false
    var store = MTStore()
    
    override func setupGUI() {
        // Start Up
        initialSetup()
    }
    
    override func updateGUI() {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isHomeScreen {
            fetchFolders()
        }
    }
}

// MARK: - Class Methods
extension FolderAndNotesListVC {
    
    fileprivate func initialSetup() {
        tableView.backgroundView = nil
        tableView.backgroundColor = .clear
        tableView.register(FolderCell.self)
//        store.setBool(false, key: .isTipViewHide)

        navigationItem.title = isHomeScreen ? "" : folderVM?.menuName
        setupNavigationBarStyle()
        addLongPressHandler()
        addLongPressOnTipView()
        fetchFolders()
        
//        settingsView.isHidden = !isHomeScreen
        tipStackView.isHidden = !isHomeScreen || store.getBool(key: .isTipViewHide)
    }
    
//    fileprivate func navbarSignInButton() {
//        
//        let title = AppManager.shared.user.userType == .visitor ? "Sign In" : AppManager.shared.user.userName
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(signInButtonPressed))
//    }
    
    fileprivate func addLongPressHandler() {
        let longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longPressHandler))
        longGesture.minimumPressDuration = 1
        view.addGestureRecognizer(longGesture)

        setupFlotingButtons()
        addTapGestureOnOverlayView()
    }
    
    fileprivate func addLongPressOnTipView() {
        
        let longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longPressOnTipViewHandler))
        longGesture.minimumPressDuration = 1
        tipStackView.addGestureRecognizer(longGesture)
    }
    
    fileprivate func addTapGestureOnOverlayView() {
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOverlayView))
        overlayView.addGestureRecognizer(tabGesture)
    }
    
//    fileprivate func addTapGestureOnTipView() {
//        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTipView))
//        tipView.addGestureRecognizer(tabGesture)
//    }
    
    fileprivate func setupFlotingButtons() {

        floatingButtons = FlotingButtons.allCases.map { (flotButton) -> UIButton in

            let button = UIButton()
            button.backgroundColor = flotButton.color
            button.setTitle(flotButton.rawValue, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.tag = flotButton.tag
            button.addTarget(self, action: #selector(floatingButtonPressed), for: .touchUpInside)
            return button
        }
        
        buttonsStackView = UIStackView(arrangedSubviews: floatingButtons)
        buttonsStackView.distribution = .fillEqually
        overlayView.frame = self.view.bounds
        overlayView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)

        overlayView.addSubview(buttonsStackView)
        self.navigationController?.view.addSubview(overlayView)
        overlayView.isHidden = true

        // Constraint
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.widthAnchor.constraint(equalTo: overlayView.widthAnchor, constant: -32).isActive = true
        buttonsStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        buttonsStackView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true
        buttonsStackView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true

    }
    
    fileprivate func deleteButtonPressed(_ indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Delete Folder
            self.deleteFolder(index: indexPath.row)
            return
        }
        
        self.deleteNote(index: indexPath.row)
    }
    
    fileprivate func setupData() {
        
        let array = [folderListVM.folderList, noteListVM.notesList] as Any
        
        folderDataSource = FolderAndNotesDataSource(tableView: tableView, array: array as! [[Any]])
        folderDataSource?.actionsProxy.on(.didSelect, handler: { (indexPath) in
            
            if indexPath.section == 0 {
                self.loadFolderAndNotesListVC(folderVM: self.folderListVM.folderList[indexPath.row], isHomeScreen: false)
                return
            }
            
            self.loadNoteDetailVC(noteVM: self.noteListVM.notesList[indexPath.row], noteListVM: self.noteListVM)
        })
        .on(.swipeToEdit, handler: { (indexPath) in
            print("Edit")
            
            self.editButtonPressed(indexPath)
        })
        .on(.swipeToDelete, handler: { (indexPath) in
            
            self.deleteButtonPressed(indexPath)
        })
        updateGUI()
    }
    
    fileprivate func editButtonPressed(_ indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.createOrUpdateFolderNameAlert(isEditing: true, index: indexPath.row)
            return
        }
        
        self.loadCreateOrUpdateNoteVC(isEditing: true, noteVM: self.noteListVM.notesList[indexPath.row], folderId: self.folderVM?.folderId ?? 0, notesListVM: noteListVM)
    }
    
    fileprivate func createOrUpdateFolderNameAlert(isEditing: Bool = false, index: Int = 0) {
        let alertController = UIAlertController(title: isEditing ? "Update Folder" : "Create New Folder", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Folder name"
            
            textField.text = isEditing ? self.folderListVM.folderList[index].menuName : ""
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            if let textField = alertController.textFields?[0] {
                print("Text :: \(textField.text ?? "")")
                
                if textField.text?.isEmpty ?? false {
                    Services.showErrorAlert(with: "Folder name required")
                    return
                }
                
                if isEditing {
                    self.updateFolder(at: index, name: textField.text!)
                    return
                }
                self.createFolder(name: textField.text!)
            }
        })
        
        let cancel = UIAlertAction(title: StringsConstants.cancel.getString, style: .cancel, handler: nil)

        alertController.addAction(cancel)
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - IBActions
extension FolderAndNotesListVC {
    
    @objc func longPressHandler(_ gesture: UIGestureRecognizer) {
        overlayView.isHidden = false

        touchPoint = gesture.location(in: tableView)
        
        let displayButtonsYLocation = touchPoint.y + 100 + ( tipStackView.isHidden ? 0 : tipStackView.frame.height)
//        if displayButtonsYLocation < 100 {
//            buttonsStackView.center = overlayView.center
//            return
//        }
        
        buttonsStackView.frame = .init(x: 16, y: displayButtonsYLocation, width: tableView.frame.width - 32, height: 50)
        print(touchPoint)
    }
    
    @objc func dismissOverlayView() {
        overlayView.isHidden = true
    }
    
//    @objc func dismissTipView() {
//        tipView.isHidden = true
//    }
    
    @objc func longPressOnTipViewHandler(_ gesture: UIGestureRecognizer) {
        isLongPressOnTipView = true
        longPressHandler(gesture)
    }
    
    @objc func floatingButtonPressed(_ sender: UIButton) {

        guard let selectedButton = FlotingButtons(tag: sender.tag) else {
            return
        }
        
        dismissOverlayView()

        print(selectedButton.rawValue)
        switch selectedButton {
//        case .folder:
//            self.createOrUpdateFolderNameAlert()
        case .copy:
            guard let indexPath = self.tableView.indexPathForRow(at: touchPoint) else {
                return
            }
            print(indexPath)
            AppManager.shared.selectedOption = .copy
            
            if indexPath.section == 0 {
                AppManager.shared.selectedFolder = folderListVM.folderList[indexPath.row]
                return
            }
            
            AppManager.shared.selectedNote = noteListVM.notesList[indexPath.row]

        case .cut:
            guard let indexPath = self.tableView.indexPathForRow(at: touchPoint) else {
                return
            }
            print(indexPath)
            AppManager.shared.selectedOption = .cut

            if indexPath.section == 0 {
                AppManager.shared.selectedFolder = folderListVM.folderList[indexPath.row]
                return
            }
            
            AppManager.shared.selectedNote = noteListVM.notesList[indexPath.row]

        case .paste:
            let pastIndexPath = self.tableView.indexPathForRow(at: touchPoint)
            print(pastIndexPath)
            
            if AppManager.shared.selectedFolder == nil && AppManager.shared.selectedNote == nil {
                Services.showErrorAlert(with: "Nothing to past")
                return
            }
            
            if AppManager.shared.selectedFolder != nil {
                // Past Here
                
                var index: Int?
                if pastIndexPath?.section == 0 {
                    index = pastIndexPath?.row
                }
                pasteFolder(at: index)
                return
            }
            
            var index: Int?
            if pastIndexPath?.section == 1 {
                index = pastIndexPath?.row
            }

            pasteNote(at: index)
        case .edit:
            guard let indexPath = self.tableView.indexPathForRow(at: touchPoint) else {
                return
            }
            self.editButtonPressed(indexPath)
            
        default:
            
            // Long Press on tip View
            if isLongPressOnTipView {
                store.setBool(true, key: .isTipViewHide)
                tipStackView.isHidden = true
                isLongPressOnTipView = false
                return
            }
            
            guard let indexPath = self.tableView.indexPathForRow(at: touchPoint) else {
                return
            }
            self.deleteButtonPressed(indexPath)
            break
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
//        if isHomeScreen {
//            Services.showErrorAlert(with: "Note can't be create on root folder. Please go inside any folder to create notes")
//            return
//        }
        self.loadCreateOrUpdateNoteVC(folderId: self.folderVM?.folderId, notesListVM: noteListVM)
    }
    
    @IBAction func createFolderButtonPressed(_ sender: UIButton) {
        self.createOrUpdateFolderNameAlert()
    }
    
//    @objc func signInButtonPressed(_ sender: UIBarButtonItem) {
//        
//        if AppManager.shared.user == nil {
//            loadLoginVC()
//            return
//        }
//        
//        self.logoutButtonPressed()
//    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        loadSettingsVC()
    }
}

// MARK: - Apis Methods
extension FolderAndNotesListVC {

    fileprivate func fetchFolders() {
        folderListVM.indecatorDelegate = self
        folderListVM.fetchFolders(menuId: folderVM?.folderId) { foldersList in
            self.folderListVM.updateFolderList(folders: foldersList)
            self.setupData()

            if self.isHomeScreen {
                self.fetchNotesInRootScreen()
                return
            }
            
            self.fetchNotes()
        }
    }
    
    fileprivate func fetchNotesInRootScreen() {
        noteListVM.indecatorDelegate = self
        noteListVM.fetchNotesInRootScreen { (_) in
            self.setupData()
        }
    }
    
    fileprivate func fetchNotes() {
        noteListVM.indecatorDelegate = self
        noteListVM.fetchNotes(folderId: folderVM?.folderId ?? 0) { _ in
            self.setupData()
        }
    }
    
    fileprivate func createFolder(name: String) {
        
//        let folderVM = self.folderVM == nil ? FolderViewModel() : self.folderVM
        folderListVM.indecatorDelegate = self
        folderListVM.createFolder(name: name,
                               folderId: self.folderVM?.folderId) { foldersList in
//            self.folderListVM.folderList.append(folderVM)//.insert(folderVM!, at: 0)
//            self.setupData()
            AppManager.shared.selectedFolder = nil
            AppManager.shared.selectedOption = nil
            var folders = self.folderListVM.folderList
            folders.append(contentsOf: foldersList)
            self.folderListVM.updateFolderList(folders: folders)
            self.setupData()
        }
    }
    
    fileprivate func updateFolder(at index: Int, name: String) {
        var folderVM = self.folderListVM.folderList[index]
        folderVM.menuName = name

        folderListVM.indecatorDelegate = self
        folderListVM.updateFolder(at: index, folderVM: folderVM) { foldersList in
            self.folderListVM.updateFolderList(folders: foldersList)
            self.setupData()
        }

//        var folderVM = self.folderListVM.folderList[index]
//        folderVM.menuName = name
//        folderVM.indecatorDelegate = self
//        folderVM.updateFolder {folderList in
//            self.folderListVM.folderList[index] = folderVM
//            self.setupData()
//        }
    }
    
    fileprivate func deleteFolder(index: Int) {
        var folderVM = self.folderListVM.folderList[index]
        folderVM.indecatorDelegate = self
        folderVM.deleteFolder {
            self.folderListVM.folderList.remove(at: index)
            self.setupData()
        }
    }
    
    fileprivate func pasteFolder(at index: Int?) {
        
//        if AppManager.shared.selectedFolder?.parentFolderId == folderVM?.folderId {
//            Services.showErrorAlert(with: "Can't past in the same folder")
//            return
//        }
        
        if AppManager.shared.selectedOption == .copy {
            guard let cutFolder = AppManager.shared.selectedFolder else {
                return
            }
            createFolder(name: "copy of:\(cutFolder.menuName)")
            return
        }
        
//        var folderVM = FolderViewModel()
        folderListVM.indecatorDelegate = self
        folderListVM.moveFolder(at: index, parentFolderID: self.folderVM?.folderId) { (foldersList) in
            AppManager.shared.selectedFolder = nil
            AppManager.shared.selectedOption = nil
            self.folderListVM.updateFolderList(folders: foldersList)
            self.setupData()
//            self.folderListVM.folderList.append(folderVM)
//            self.setupData()
        }
    }

    fileprivate func deleteNote(index: Int) {
        var noteVM = self.noteListVM.notesList[index]
        noteVM.indecatorDelegate = self
        noteVM.deleteNote {
            self.noteListVM.notesList.remove(at: index)
            self.setupData()
        }
    }
    
    fileprivate func pasteNote(at index: Int?) {
//        if AppManager.shared.selectedNote?.pId == folderVM?.menuId {
//            Services.showErrorAlert(with: "Can't past in the same folder")
//            return
//        }
        
        if AppManager.shared.selectedOption == .copy {
            createNote()
            return
        }
        
//        var noteVM = NoteViewModel()
        noteListVM.indecatorDelegate = self
        noteListVM.moveNote(at: index, toFolderId: self.folderVM?.folderId) { (notes) in
            AppManager.shared.selectedNote = nil
            AppManager.shared.selectedOption = nil
            self.noteCreated(notes)
        }
    }
    
    fileprivate func createNote() {
        guard let cutNote = AppManager.shared.selectedNote else {
            return
        }
        let noteVM = NoteViewModel(content: "copy of:\(cutNote.content)", pId: self.folderVM?.folderId, orderId: cutNote.orderId)
        noteListVM.indecatorDelegate = self
        noteListVM.createNote(note: noteVM) { notesList in
            var notes = self.noteListVM.notesList
            notes.append(contentsOf: notesList)
            self.noteCreated(notes)
            AppManager.shared.selectedNote = nil
            AppManager.shared.selectedOption = nil
        }
    }
}

// MARK: - Indecator Delegate
extension FolderAndNotesListVC: IndecatorDelegate {

    func didStartIndecator() {
        Services.startHudAnimation(title: "")
    }

    func didStop(withError errorMessage: String) {
        Services.showErrorAlert(with: errorMessage.html2String)
    }
}

// MARK: - CreateOrUpdateNoteVCDelegate
extension FolderAndNotesListVC: CreateOrUpdateNoteVCDelegate {

    func noteCreated(_ notes: [NoteViewModel]) {
//        self.noteListVM.notesList.append(noteVM)
        self.noteListVM.notesList = notes
        self.setupData()
    }
    
    func noteUpdated(_ notes: [NoteViewModel]) {
        self.noteListVM.notesList = notes

//        guard let index = self.noteListVM.notesList.firstIndex(where: {$0.itemId == noteVM.itemId}) else {
//            return
//        }
//        self.noteListVM.notesList[index] = noteVM
        self.setupData()
    }
    
    func deleteNote(_ noteVM: NoteViewModel) {
        guard let index = self.noteListVM.notesList.firstIndex(where: {$0.itemId == noteVM.itemId}) else {
            return
        }
        
        self.deleteNote(index: index)
    }
}

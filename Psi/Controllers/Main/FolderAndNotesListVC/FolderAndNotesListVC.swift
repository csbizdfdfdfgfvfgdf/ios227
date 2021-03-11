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
    
    var storeDataInUserDefalut = true
    var storedArray: [[Any]]?
    
    var array: [[Any]]? {
        set {
            self.storedArray = newValue
            if self.storeDataInUserDefalut {
                self.saveData(array: newValue, storeInFolderID: self.folderVM?.folderId ?? 0)
            } else {
                self.storeDataInUserDefalut = true
            }
        }
        get {
            return self.storedArray
        }
    }
    
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
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
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
        guard let items = self.array else { return }
        if self.getIsFolder(indexPath: indexPath) {
            let index = indexPath.row// - items[0].count
            self.deleteFolder(index: index)//-1)
        }
        self.deleteNote(index: indexPath.row)
        return
        
//        if indexPath.section == 0 {
////        if (((self.array as? [[Any]])?[indexPath.section][indexPath.row] as? FolderViewModel) != nil) {
//            // Delete Folder
//            self.deleteFolder(index: indexPath.row)
//            return
//        }
//
//        self.deleteNote(index: indexPath.row)
    }
    
    fileprivate func setupData() {
//        let array = self.array != nil ? self.array as Any : [folderListVM.folderList, noteListVM.notesList] as Any
//        let array = [folderListVM.folderList, noteListVM.notesList] as Any
//        folderDataSource = FolderAndNotesDataSource(tableView: tableView, array: array as! [[Any]])
        let array = self.loadData(storeInFolderID: self.folderVM?.folderId ?? 0)
        self.storeDataInUserDefalut = false
        self.array = array
        folderDataSource = FolderAndNotesDataSource(tableView: tableView, array: array ?? [])
        folderDataSource?.delegate = self
        notesDataSource?.delegate = self
        folderDataSource?.actionsProxy.on(.didSelect, handler: { (indexPath) in
            if self.getIsFolder(indexPath: indexPath) {
                if let folder = self.getFolder(indexPath: indexPath, arrayItems: nil) {
                    self.loadFolderAndNotesListVC(folderVM: folder, isHomeScreen: false)
                }
                return
            }
            if let note = self.getNote(indexPath: indexPath, arrayItems: nil) {
                self.loadNoteDetailVC(noteVM: note, noteListVM: self.noteListVM)
            }
            
//            if indexPath.section == 0 {
//                self.loadFolderAndNotesListVC(folderVM: self.folderListVM.folderList[indexPath.row], isHomeScreen: false)
//                return
//            }
//
//            self.loadNoteDetailVC(noteVM: self.noteListVM.notesList[indexPath.row], noteListVM: self.noteListVM)
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
//        if let folderModel = self.array?[indexPath.section][indexPath.row] as? FolderViewModel {
//            self.createOrUpdateFolderNameAlert(isEditing: true, index: indexPath.row)
//            return
//        } else if let noteModel = self.array?[indexPath.section][indexPath.row] as? NoteViewModel {
//            self.loadCreateOrUpdateNoteVC(isEditing: true, noteVM: self.noteListVM.notesList[indexPath.row], folderId: self.folderVM?.folderId ?? 0, notesListVM: noteListVM)
//            return
//        }
        
//        if indexPath.section == 0 {
        if self.getIsFolder(indexPath: indexPath) {
            self.createOrUpdateFolderNameAlert(isEditing: true, index: indexPath.row)
            return
        }
        var index = 0
        let arrInd = self.array?.count ?? 0 > 1 ? 1 : 0
        let data = self.array?[arrInd][indexPath.row] as? NoteViewModel
        if let ind = self.noteListVM.notesList.firstIndex(where: {$0.itemId == data?.itemId}) {
            index = ind
        }
        self.loadCreateOrUpdateNoteVC(isEditing: true, noteVM: self.noteListVM.notesList[index], folderId: self.folderVM?.folderId ?? 0, notesListVM: noteListVM)
    }
    
    fileprivate func createOrUpdateFolderNameAlert(isEditing: Bool = false, index: Int = 0) {
        let alertController = UIAlertController(title: isEditing ? "Update Folder" : "Create New Folder", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Folder name"
//            textField.text = isEditing ? self.folderListVM.folderList[index].menuName : ""
            if isEditing {
                var indd = 0
                let arrInd = self.array?.count ?? 0 > 1 ? 1 : 0
                let data = self.array?[arrInd][index] as? FolderViewModel
                if let i = self.folderListVM.folderList.firstIndex(where: {$0.folderId == data?.folderId}) {
                    indd = i
                }
                textField.text = self.folderListVM.folderList[indd].menuName
            } else {
                textField.text = ""
            }
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

            if let folderModel = self.array?[indexPath.section][indexPath.row] as? FolderViewModel {
                AppManager.shared.selectedFolder = folderModel
                return
            } else if let noteModel = self.array?[indexPath.section][indexPath.row] as? NoteViewModel {
                AppManager.shared.selectedNote = noteModel
                return
            }
            
//            if indexPath.section == 0 {
            if self.getIsFolder(indexPath: indexPath) {
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

            if let folderModel = self.array?[indexPath.section][indexPath.row] as? FolderViewModel {
                AppManager.shared.selectedFolder = folderModel
                return
            } else if let noteModel = self.array?[indexPath.section][indexPath.row] as? NoteViewModel {
                AppManager.shared.selectedNote = noteModel
                return
            }
            
//            if indexPath.section == 0 {
            if self.getIsFolder(indexPath: indexPath) {
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
//            if pastIndexPath?.section == 1 {
                index = pastIndexPath?.row
//            }

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
            
            if var array = self.array {
//                let index = array.count-1
                let index = array.count > 1 ? 1 : 0
                array[index].append(contentsOf: foldersList)
                self.array = array
            }
            
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
        var folder: FolderViewModel?
        var array = self.array ?? []
        let ind = array.count > 1 ? 1 : 0//array.count-1
        if let data = array[ind][index/*+1*/] as? FolderViewModel {
            folder = data
        }
        
        if let fol = folder {
            if let listindex = self.folderListVM.folderList.firstIndex(of: fol) {
                var folderVM = self.folderListVM.folderList[listindex]
                folderVM.indecatorDelegate = self
                folderVM.deleteFolder {
                    self.folderListVM.folderList.remove(at: listindex)
                    
                    array[ind].remove(at: index/*+1*/)
                    self.array = array
                    
                    self.setupData()
                }
            }
        }
        
//        var folderVM = self.folderListVM.folderList[index]
//        folderVM.indecatorDelegate = self
//        folderVM.deleteFolder {
//            self.folderListVM.folderList.remove(at: index)
//            self.setupData()
//        }
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
        folderListVM.moveFolder(at: index, parentFolderID: self.folderVM?.folderId, array: self.array) { (foldersList) in
//        folderListVM.moveFolder(at: index, parentFolderID: self.folderVM?.folderId) { (foldersList) in
            AppManager.shared.selectedFolder = nil
            AppManager.shared.selectedOption = nil
            self.folderListVM.updateFolderList(folders: foldersList)
            self.setupData()
//            self.folderListVM.folderList.append(folderVM)
//            self.setupData()
        } updatedArray: { (array) in
            self.array = array
            self.setupData()
        }
    }

    fileprivate func deleteNote(index: Int) {
        var note: NoteViewModel?
        var array = self.array ?? []
        let ind = array.count > 1 ? 1 : 0//array.count-1
        if let data = array[ind][index/*+1*/] as? NoteViewModel {
            note = data
        }
        
        if let no = note {
            if let listindex = self.noteListVM.notesList.firstIndex(of: no) {
                var noteVM = self.noteListVM.notesList[listindex]
                noteVM.indecatorDelegate = self
                noteVM.deleteNote {
                    self.noteListVM.notesList.remove(at: listindex)
                    
                    array[ind].remove(at: index/*+1*/)
                    self.array = array
                    
                    self.setupData()
                }
            }
        }
        
        
//        var noteVM = self.noteListVM.notesList[index]
//        noteVM.indecatorDelegate = self
//        noteVM.deleteNote {
//            self.noteListVM.notesList.remove(at: index)
//
//            if var array = self.array as? [[Any]] {
//                let ind = array.count-1
//                array[ind].remove(at: index+1)
//                self.array = array
//            }
//
//            self.setupData()
//        }
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
//        noteListVM.moveNote(at: index, toFolderId: self.folderVM?.folderId) { (notes) in
        noteListVM.moveNote(at: index, toFolderId: self.folderVM?.folderId, array: self.array) { (notes) in
            AppManager.shared.selectedNote = nil
            AppManager.shared.selectedOption = nil
            self.noteCreated(notes, newlyAdded: notes)
        } updatedArray: { (array) in
            self.array = array
            self.setupData()
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
            self.noteCreated(notes, newlyAdded: notesList)
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

    func noteCreated(_ notes: [NoteViewModel], newlyAdded: [NoteViewModel]) {
//        self.noteListVM.notesList.append(noteVM)
        self.noteListVM.notesList = notes
        
        if var array = self.array {
//            let index = array.count-1
            let index = array.count > 1 ? 1 : 0
            array[index].append(contentsOf: newlyAdded)
            self.array = array
        }
        
        self.setupData()
    }
    
    func noteUpdated(_ notes: [NoteViewModel], newlyAdded: NoteViewModel) {
        self.noteListVM.notesList = notes

        if var array = self.array {
//            let index = array.count-1
            let index = array.count > 1 ? 1 : 0
            array[index].append(newlyAdded)
            self.array = array
        }
        
//        guard let index = self.noteListVM.notesList.firstIndex(where: {$0.itemId == noteVM.itemId}) else {
//            return
//        }
//        self.noteListVM.notesList[index] = noteVM
        self.setupData()
    }
    
    func deleteNote(_ noteVM: NoteViewModel) {
//        guard var index = self.noteListVM.notesList.firstIndex(where: {$0.itemId == noteVM.itemId}) else {
//            return
//        }
        var index = 0
        
        if let array = self.array {
            for arr in array {
                for (ind, ar) in arr.enumerated() {
                    if let note = ar as? NoteViewModel {
                        if note.itemId == noteVM.itemId {
                            index = ind
                        }
                    }
                }
            }
        }
        
        self.deleteNote(index: index)
    }
    
    func saveData(array: [[Any]]?, storeInFolderID: Int64 = 0) {
        let key = getSwappedDataUserDefaultKey(inFolder: storeInFolderID)
        if let mainData = MainFolderNoteModelModel.converDataToStruct(array: array) {
            UserDefaults.standard.setStructArray(mainData, forKey: key)
        }
    }
    
    func loadData(storeInFolderID: Int64 = 0) -> [[Any]]? {
        let key = getSwappedDataUserDefaultKey(inFolder: storeInFolderID)
        let mainData = MainFolderNoteModelModel()
        if UserDefaults.standard.value(forKey: key) != nil {
            let arrOfDetail = UserDefaults.standard.structArrayData(MainFolderNoteModelModel.self, forKey: key)
            let data = mainData.getDataFromUserDefaults(mainModels: arrOfDetail)
            self.storeDataInUserDefalut = false
            self.array = data
        }
        
        var arrayTotalDataCount = 0
        let otherData = [folderListVM.folderList, noteListVM.notesList] as [[Any]]
        let otherDataCount = otherData[0].count + otherData[1].count
        
        if let array = self.array {
            if array.count > 1 {
                arrayTotalDataCount = array[0].count+array[1].count
                if arrayTotalDataCount == otherDataCount {
                    return array
                }
            } else if array.count > 0 {
                arrayTotalDataCount = array[0].count
                if arrayTotalDataCount == otherDataCount {
                    return array
                }
            }
        }
        
        if otherData.count > 1 {
            var fol = otherData[0]
            let note = otherData[1]
            let pass = fol+note
            return [pass]
        } else if otherData.count > 0 {
            let fol = otherData[0]
            return [fol]
        }
        return []
    }
    
//    func getIsFolder(indexPath: IndexPath) -> Bool {
//        guard let items = self.array as? [[Any]] else { return true }
//        guard indexPath.section >= 0 &&
//            indexPath.section < items.count &&
//            indexPath.row >= 0 &&
//            indexPath.row < items[indexPath.section].count
//        else {
//            return false
//        }
//        return true
//
////        if indexPath.section == 0 {
////            return true
////        }
////        return false
//    }
    
    func getIsFolder(indexPath: IndexPath) -> Bool {
        guard let items = self.array else { return true }
        if ((items[indexPath.section][indexPath.row] as? FolderViewModel) != nil) {
            return true
        } else if ((items[indexPath.section][indexPath.row] as? NoteViewModel) != nil) {
            return false
        }
        return true
//        if indexPath.section == 0 {
//            return true
//        }
//        return false
    }
    
    func getFolder(indexPath: IndexPath, arrayItems: [[Any]]?) -> FolderViewModel? {
        let items = arrayItems != nil ? arrayItems! : self.array ?? []
        if items.count > 0 {
            if let folder = items[indexPath.section][indexPath.row] as? FolderViewModel {
                return folder
            }
        }
        return nil
    }
    
    func getNote(indexPath: IndexPath, arrayItems: [[Any]]?) -> NoteViewModel? {
        let items = arrayItems != nil ? arrayItems! : self.array ?? []
        if items.count > 0 {
            if let note = items[indexPath.section][indexPath.row] as? NoteViewModel {
                return note
            }
        }
        return nil
    }
}

extension FolderAndNotesListVC: ItemsOrderChangedDelegate {
    func itemsOrderChanged(provider: Any?) {
        let items = (provider as? ArrayDataProvider<Any>)?.items
        self.array = items
    }
}

//
//  SwapHelper.swift
//  Psi
//
//  Created by YASH COMPUTER on 09/03/21.
//

import Foundation

func getSwappedDataUserDefaultKey(inFolder: Int64) -> String {
    return "itemsOrderChanged+\(inFolder)"
}

//This will get called when the data is being swapped
public protocol ItemsOrderChangedDelegate {
    func itemsOrderChanged(provider: Any?)
}

//This will allow to save custom objects or array of objects to user defaults
extension UserDefaults {
    open func setStruct<T: Codable>(_ value: T?, forKey defaultName: String){
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: defaultName)
    }
    
    open func structData<T>(_ type: T.Type, forKey defaultName: String) -> T? where T : Decodable {
        guard let encodedData = data(forKey: defaultName) else {
            return nil
        }
        return try? JSONDecoder().decode(type, from: encodedData)
    }
    
    open func setStructArray<T: Codable>(_ value: [T], forKey defaultName: String){
        let data = value.map { try? JSONEncoder().encode($0) }
        set(data, forKey: defaultName)
    }
    
    open func structArrayData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T : Decodable {
        guard let encodedData = array(forKey: defaultName) as? [Data] else {
            return []
        }
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
}

//This is the custom mappable class to store the data to user default and use later on
//This will contain the order in which the data have been swapped
class MainFolderNoteModelModel: Codable {
    var folderId: Int64 = 0
    var folderMenuName: String = ""
    var folderOrderId: Int = 0
    var folderParentFolderId: Int64 = 0
    
    var noteItemId: Int64 = 0
    var noteContent: String = ""
    var noteOrderId: Int = 0
    var notePId: Int64 = 0
    
    var isFolder: Bool = false
    
    init() {}
    
    enum CodingKeys: CodingKey {
        case folderId
        case folderMenuName
        case folderOrderId
        case folderParentFolderId
        case noteItemId
        case noteContent
        case noteOrderId
        case notePId
        case isFolder
    }
    
    func getDataFromUserDefaults(mainModels: [MainFolderNoteModelModel]?) -> [[Any]]? {
        var folderViewModel: [FolderViewModel] = []
        var notesViewModel: [NoteViewModel] = []
        var array: [[Any]] = [[]]
        if let mainModels = mainModels {
            for mainModel in mainModels {
                if mainModel.isFolder {
                    if let folder = self.getFolderModel(mainModel: mainModel) {
                        let singleFolderViewModel = FolderViewModel(folder)
                        folderViewModel.append(singleFolderViewModel)
                        if array.count == 0 {
                            array[0][0] = singleFolderViewModel
                        } else {
                            array[0].append(singleFolderViewModel)
                        }
                    }
                }
                if !mainModel.isFolder {
                    if let note = self.getNoteModel(mainModel: mainModel) {
                        let singleNoteViewModel = NoteViewModel(note)
                        notesViewModel.append(singleNoteViewModel)
                        if array.count == 0 {
                            array[0][0] = singleNoteViewModel
                        } else {
                            array[0].append(singleNoteViewModel)
                        }
                    }
                }
            }
        }
        return array
    }
    
    static func converDataToStruct(array: [[Any]]?) -> [MainFolderNoteModelModel]? {
        var mainModel: [MainFolderNoteModelModel] = []
        if let array = array {
            for (section, sectionArray) in array.enumerated() {
                for (row, _) in sectionArray.enumerated() {
                    if let folderViewModel = array[section][row] as? FolderViewModel {
                        if let folderModel = self.getFolderModelFromFolderViewModel(folderViewModel: folderViewModel) {
                            if let model = self.setFolderData(folderModel: folderModel) {
                                mainModel.append(model)
                            }
                        }
                    } else if let noteViewModel = array[section][row] as? NoteViewModel {
                        if let noteModel = self.getNoteModelFromNoteViewModel(noteViewModel: noteViewModel) {
                            if let model = self.setNoteData(noteModel: noteModel) {
                                mainModel.append(model)
                            }
                        }
                    }
                }
            }
        }
        return mainModel
    }
    
    static private func setFolderData(folderModel: FolderModel) -> MainFolderNoteModelModel? {
        let mainModel = MainFolderNoteModelModel()
        mainModel.folderId = folderModel.menuId ?? 0
        mainModel.folderMenuName = folderModel.menuName ?? ""
        mainModel.folderOrderId = folderModel.orderId ?? 0
        mainModel.folderParentFolderId = folderModel.pId ?? 0
        mainModel.isFolder = true
        return mainModel
    }
    
    static private func setNoteData(noteModel: NoteModel) -> MainFolderNoteModelModel? {
        let mainModel = MainFolderNoteModelModel()
        mainModel.noteItemId = noteModel.itemId ?? 0
        mainModel.noteContent = noteModel.content ?? ""
        mainModel.noteOrderId = noteModel.orderId ?? 0
        mainModel.notePId = noteModel.pId ?? 0
        mainModel.isFolder = false
        return mainModel
    }
    
    private func getFolderModel(mainModel: MainFolderNoteModelModel) -> FolderModel? {
        let folderModel = FolderModel()
        folderModel.menuId = mainModel.folderId
        folderModel.menuName = mainModel.folderMenuName
        folderModel.orderId = mainModel.folderOrderId
        folderModel.pId = mainModel.folderParentFolderId
        return folderModel
    }
    
    private func getNoteModel(mainModel: MainFolderNoteModelModel) -> NoteModel? {
        let noteModel = NoteModel()
        noteModel.itemId = mainModel.noteItemId
        noteModel.content = mainModel.noteContent
        noteModel.orderId = mainModel.noteOrderId
        noteModel.pId = mainModel.notePId
        return noteModel
    }
    
    
    static private func getFolderModelFromFolderViewModel(folderViewModel: FolderViewModel) -> FolderModel? {
        let folderModel = FolderModel()
        folderModel.menuId = folderViewModel.folderId
        folderModel.menuName = folderViewModel.menuName
        folderModel.orderId = folderViewModel.orderId
        folderModel.pId = folderViewModel.parentFolderId
        return folderModel
    }
    
    static private func getNoteModelFromNoteViewModel(noteViewModel: NoteViewModel) -> NoteModel? {
        let noteModel = NoteModel()
        noteModel.itemId = noteViewModel.itemId
        noteModel.content = noteViewModel.content
        noteModel.orderId = noteViewModel.orderId
        noteModel.pId = noteViewModel.pId
        return noteModel
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        folderId = try values.decode(Int64.self, forKey: .folderId)
        folderMenuName = try values.decode(String.self, forKey: .folderMenuName)
        folderOrderId = try values.decode(Int.self, forKey: .folderOrderId)
        folderParentFolderId = try values.decode(Int64.self, forKey: .folderParentFolderId)
        noteItemId = try values.decode(Int64.self, forKey: .noteItemId)
        noteContent = try values.decode(String.self, forKey: .noteContent)
        noteOrderId = try values.decode(Int.self, forKey: .noteOrderId)
        notePId = try values.decode(Int64.self, forKey: .notePId)
        isFolder = try values.decode(Bool.self, forKey: .isFolder)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(folderId, forKey: .folderId)
        try container.encode(folderMenuName, forKey: .folderMenuName)
        try container.encode(folderOrderId, forKey: .folderOrderId)
        try container.encode(folderParentFolderId, forKey: .folderParentFolderId)
        try container.encode(noteItemId, forKey: .noteItemId)
        try container.encode(noteContent, forKey: .noteContent)
        try container.encode(noteOrderId, forKey: .noteOrderId)
        try container.encode(notePId, forKey: .notePId)
        try container.encode(isFolder, forKey: .isFolder)
    }
}

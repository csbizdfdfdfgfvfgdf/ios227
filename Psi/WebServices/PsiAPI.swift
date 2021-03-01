//
//  PsiAPI.swift
//  Psi
//
//  Created by Tayyab Ali on 23/04/2020.
//  Copyright © 2019 Fantech Labs. All rights reserved.
//

import UIKit
import Moya
import Alamofire

enum APIEviroment {
    case production
    case development
}

//actual API endpoints
enum PsiAPI {
    
    case register(user: UserViewModel)
    case login(email: String, password: String)
    case forgotPassword(email: String)
    case makeUUID
    
    case getUserDetail
    case getFolders(menuId: Int64?)
    case createFolder(list: [FolderViewModel])//(name: String, folderId: Int64?, orderId: Int)
    case updateFolder(list: [FolderViewModel]) //name: String, folderId: Int64, toFolderId: Int64?
    case deleteFolder(id: Int64)
    
    case getNotesOnRootScreen
    case getNotes(folderId: Int64)
    case createNote(list: [NoteViewModel])//(content: String, folderId: Int64?, orderId: Int)
    case deleteNote(id: Int64)
    case updateNote(list: [NoteViewModel])//(content: String, folderId: Int64, noteId: Int64)
//    case moveNote
}

//end end points
extension PsiAPI: TargetType {
    
    fileprivate var enviromentBaseURL: String{
        
        switch NetworkManager.enviroment {
        case .development: return "http://52.88.158.96:8080/"
        case .production: return "http://52.88.158.96:8080/"
        }
    }
    
    var baseURL: URL{
        
        guard let url  = URL(string: enviromentBaseURL) else { fatalError("baseURL couldnt be configured!") }
        return url
    }
    
    var path: String {
        switch self {
        case .register:
            return "register"
        case .login:
            return "authenticate"
        case .forgotPassword:
            return "auth/retrievePwd"
        case .makeUUID:
            return "auth/makeUuid"
            
        case .getUserDetail:
            return "auth/me"
        case .getFolders(let menueId):
            
            if let id = menueId {
                return "menus/\(id)"
            }
            return "menus"
        case .createFolder:
            return "api/menu/addMenu"
        case .updateFolder:
            return "api/menu/updateMenu"
        case .deleteFolder(let id):
            return "api/menu/delMenu/\(id)"
            
        case .getNotesOnRootScreen:
            return "api/menu/menuItemByUser"
        case .getNotes(let folderId):
            return "api/menu/menuItem/\(folderId)"
        case .createNote:
            return "api/menu/addItem"
        case .deleteNote(let id):
            return "api/menu/delItem/\(id)"
        case .updateNote:
            return "api/menu/updateItem"
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .makeUUID, .getUserDetail, .getFolders, .getNotes, .getNotesOnRootScreen:
            return .get
        case .updateFolder, .updateNote:
            return .put
        case .deleteFolder, .deleteNote:
            return .delete
        default:
            return .post
        }
    }
    
    var task: Task {
                
        switch self {

        case .register(let user):
            let json = ["userName": user.userName,
                        "email": user.email,
                        "password": user.password,
                        "confirmpassword" : user.confirmPassword
            ]
            return .requestParameters(parameters: json, encoding: JSONEncoding.default)
            
        case .login(let email, let password):
            let json = ["userName": email,
                        "password": password
            ]
            return .requestParameters(parameters: json, encoding: JSONEncoding.default)
            
        case .forgotPassword(let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        case .makeUUID:
            return .requestPlain
            
        case .getUserDetail:
            return .requestPlain
            
        case .getFolders(_):
            return .requestPlain

        case .createFolder(let updatedList)://(let name, let pId, let orderId):
            
            var dicArray = [[String: Any]]()
            for (index, value) in updatedList.enumerated() {
                let json = ["menuName": value.menuName,
                            "pId": value.parentFolderId,
                            "orderId": value.orderId,
                            "userType": AppManager.shared.user.userType.intValue
                ] as [String : Any]
                dicArray.append(json)
            }
            return .requestParameters(parameters: [:], encoding: JSONArrayEncoding(array: dicArray))

        case .updateFolder(let updatedList): //let name, let folderId, let toFolderId
            
            var dicArray = [[String: Any]]()
            for (index, value) in updatedList.enumerated() {
                
                let json = ["menuName": value.menuName,
                            "menuId": value.folderId,
                            "pId": value.parentFolderId,
                            "orderId": index,
                            "userType": AppManager.shared.user.userType.intValue
                ] as [String : Any]
                dicArray.append(json)
            }
            return .requestParameters(parameters: [:], encoding: JSONArrayEncoding(array: dicArray))

        case .deleteFolder:
            return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
            
        case .getNotes, .getNotesOnRootScreen:
            return .requestPlain
        case .createNote(let updatedList)://(let content, let folderId, let orderId):
            var dicArray = [[String: Any]]()

            for (index, value) in updatedList.enumerated() {
                
                let json = ["content": value.content,
                            "pId": value.pId,
                            "orderId": value.orderId,
                            "userType": AppManager.shared.user.userType.intValue
                ] as [String : Any]
                dicArray.append(json)
            }
            return .requestParameters(parameters: [:], encoding: JSONArrayEncoding(array: dicArray))

        case .deleteNote:
            return .requestPlain
        case .updateNote(let updatedList)://(let content, let folderId, let noteId, let orderId):
            var dicArray = [[String: Any]]()

            for (index, value) in updatedList.enumerated() {
                
                let json = ["content": value.content,
                            "itemId": value.itemId,
                            "pId": value.pId,
                            "orderId": index,
                            "userType": AppManager.shared.user.userType.intValue
                ] as [String : Any]
                dicArray.append(json)
            }
            return .requestParameters(parameters: [:], encoding: JSONArrayEncoding(array: dicArray))
            
        }
    }
    
    var sampleData: Data{
        return Data()
    }
    
    var headers: [String : String]?{

        var assigned: [String: String] = [
            "Accept": "application/json",
            "Accept-Language": "",
            "Content-Type": "application/json"
        ]
        
        switch self {
        case .login:
            break
        default:
            assigned.updateValue("Bearer \(MTStore().getAuthToken())", forKey: "Authorization")
            assigned.updateValue(MTStore().getUuid(), forKey: "uuid")
        }
        print(MTStore().getUuid())
        return assigned
    }
    
    struct JSONArrayEncoding: ParameterEncoding {
        private let array: [Parameters]

        init(array: [Parameters]) {
            self.array = array
        }

        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            var urlRequest = try urlRequest.asURLRequest()

            let data = try JSONSerialization.data(withJSONObject: array, options: [])

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data

            return urlRequest
        }
    }
}

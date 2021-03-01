//
//  UserViewModel.swift
//  Psi
//
//  Created by Tayyab Ali on 12/22/20.
//

import Foundation

typealias SuccessListener<T> = (T) -> Void

class UserViewModel {
    
    enum UserType: String, Codable {
        case visitor = "VISITOR"
        case registered = "REGISTERED"
        
        var intValue: Int {
            switch self {
            case .visitor:
                return 2
            default:
                return 1
            }
        }
    }
    
    var indecatorDelegate: IndecatorDelegate?

    var userId: Int64 = 0
    var userName: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var phone: String = ""
    var userType: UserType = .visitor
    var created: String = ""
    var updated: String = ""
    
    init() {
        
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    init(email: String, password: String, confirmPassword: String) {
        self.userName = email
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
    
    init(user: UserModel) {
        self.userId = user.userId ?? 0
        self.userName = user.userName ?? ""
        self.email = user.email ?? ""
        self.userType = UserType(rawValue: user.userType ?? "") ?? .visitor
    }
}

// MARK: - Validation
extension UserViewModel {
    func setupLoginValidations() -> ValidationsError {
        
        if email.isEmpty || !isValidEmail(email){
            return .valid_email_error
        }
        
        if password.isEmpty || password.count < 6{
            return .valid_password_error
        }
        
        return .empty
    }
    
    func setupSignupValidations() -> ValidationsError {
        
        if email.isEmpty || !isValidEmail(email){
            return .valid_email_error
        }

        if password.isEmpty || password.count < 6 {
            return .valid_password_error
        }

        if password != confirmPassword {
            return .password_mismatch_error
        }

        return .empty
    }
}

// MARK: - Login/Signup/Forgot Apis
extension UserViewModel {
    
    func login(successCallBack: @escaping ()-> Void) {
        
        indecatorDelegate?.didStartIndecator()

        NetworkManager.shared.genericMethodCall(target: .login(email: self.email, password: self.password)) { (result: Result<UserModel, Swift.Error>) in
            Services.hud.dismiss()
            
            switch result {
            
            case .success(let user):
                MTStore().setAuthToken(user.token ?? "")
                self.fetchUserDetail(successCallBack: successCallBack)
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
    
    func signup(successCallBack: @escaping ()-> Void) {
        
        indecatorDelegate?.didStartIndecator()

        NetworkManager.shared.genericMethodCall(target: .register(user: self)) { (result: Result<UserModel, Swift.Error>) in
            Services.hud.dismiss()

            switch result {
            
            case .success(let _):
//                AppManager.shared.user = UserViewModel(user: user)
                successCallBack()
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
    
    func resetPassword(email: String, successCallBack:  @escaping SuccessListener<String>) {
        
        indecatorDelegate?.didStartIndecator()

        NetworkManager.shared.genericMethodCall(target: .forgotPassword(email: email)) { (result: Result<ResponseModel, Swift.Error>) in
            Services.hud.dismiss()

            switch result {
            
            case .success(let response):
                
                successCallBack(response.message)
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
}

// MARK: - Fetch User Detail
extension UserViewModel {
    
    func fetchUserDetail(successCallBack: @escaping ()-> Void) {
        
        indecatorDelegate?.didStartIndecator()

        NetworkManager.shared.genericMethodCall(target: .getUserDetail) { (result: Result<UserModel, Swift.Error>) in
            
            switch result {
            
            case .success(let user):
                AppManager.shared.user = UserViewModel(user: user)
                successCallBack()
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
    
    func makeUUID(successCallBack: @escaping ()-> Void) {
        
        NetworkManager.shared.genericMethodCall(target: .makeUUID) { (result: Result<ResponseModel, Swift.Error>) in
            
            switch result {
            
            case .success(let data):
                
                MTStore().setUuid(data.UUID)
                successCallBack()
            case .failure(let error):
                self.indecatorDelegate?.didStop(withError: error.localizedDescription)
            }
        }
    }
}

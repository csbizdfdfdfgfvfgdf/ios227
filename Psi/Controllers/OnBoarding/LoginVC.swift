//
//  LoginVC.swift
//  Psi
//
//  Created by Tayyab Ali on 12/18/20.
//

import UIKit

class LoginVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    // MARK: - Base Methods
    override func setupGUI() {
        initialSetup()
    }
}

// MARK: - Class Methods
extension LoginVC {
    
    fileprivate func initialSetup() {
        self.setupNavigationBarStyle()
        navigationItem.title = "Sign In"
        
//        navbarCancelButton()
    }
    
//    fileprivate func navbarCancelButton() {
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
//    }
}

// MARK: - IBActions
extension LoginVC {
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        login()
    }
    
//    @objc func cancelButtonPressed() {
//        self.dismiss(animated: true, completion: nil)
//    }
}

// MARK: - Apis Methods
extension LoginVC {

    fileprivate func login() {
        
        let userVM = UserViewModel(email: emailTF.text!, password: passwordTF.text!)
        let valid = userVM.setupLoginValidations().string
        
        if valid != "" {
            Services.showErrorAlert(with: valid)
            return
        }
        
        userVM.indecatorDelegate = self
        userVM.login {
            Utils.switchToMain()
        }
    }
}

// MARK: - Indecator Delegate
extension LoginVC: IndecatorDelegate {

    func didStartIndecator() {
        Services.startHudAnimation(title: "")
    }

    func didStop(withError errorMessage: String) {
        Services.showErrorAlert(with: errorMessage.html2String)
    }
}

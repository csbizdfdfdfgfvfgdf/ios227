//
//  SignUpVC.swift
//  Psi
//
//  Created by Tayyab Ali on 12/18/20.
//

import UIKit

class SignUpVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!

    // MARK: - Base Methods
    override func setupGUI() {
        initialSetup()
    }
}

// MARK: - Class Methods
extension SignUpVC {
    
    fileprivate func initialSetup() {
        self.setupNavigationBarStyle()
        navigationItem.title = "Sign Up"
    }
}

// MARK: - IBActions
extension SignUpVC {
    
    @IBAction func privacyPolicyButtonPressed(_ sender: UIButton) {
        openBrowserWith(url: "https://google.com")
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        signUp()
    }
}

// MARK: - Apis Methods
extension SignUpVC {

    fileprivate func signUp() {
        
        let userVM = UserViewModel(email: emailTF.text!, password: passwordTF.text!, confirmPassword: confirmPasswordTF.text!)
        let valid = userVM.setupSignupValidations().string
        
        if valid != "" {
            Services.showErrorAlert(with: valid)
            return
        }
        
        userVM.indecatorDelegate = self
        userVM.signup {
            
            let okAction = UIAlertAction(title: StringsConstants.ok_message.getString, style: .default, handler: {_ in
                self.navigationController?.popViewController(animated: true)
            })
            Services.showAlert(style: .alert, title: StringsConstants.success_message.getString, message: "Signup completed, please login to continue.", actions: [okAction])
        }
    }
}

// MARK: - Indecator Delegate
extension SignUpVC: IndecatorDelegate {

    func didStartIndecator() {
        Services.startHudAnimation(title: "")
    }

    func didStop(withError errorMessage: String) {
        Services.showErrorAlert(with: errorMessage.html2String)
    }
}

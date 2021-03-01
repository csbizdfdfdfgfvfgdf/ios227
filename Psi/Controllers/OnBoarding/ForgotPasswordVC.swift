
//
//  ForgotPasswordVC.swift
//  Psi
//
//  Created by Tayyab Ali on 12/18/20.
//

import UIKit

class ForgotPasswordVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTF: UITextField!
        
    // MARK: - Class Properties
    
    override func setupGUI() {
        // Start Up
        initialSetup()
    }
}

// MARK: - Class Methods
extension ForgotPasswordVC {
    
    fileprivate func initialSetup() {

    }
}

// MARK: - IBActions
extension ForgotPasswordVC {
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        if emailTF.text!.isEmpty || !isValidEmail(emailTF.text!) {
            Services.showErrorAlert(with: ValidationsError.valid_email_error.string)
            return
        }
        userForgotPassword()
    }
}

// MARK: - Api Methods
extension ForgotPasswordVC {
    
    func userForgotPassword() {
        let userVM = UserViewModel()
        userVM.indecatorDelegate = self
        userVM.resetPassword(email: emailTF.text!) { (message) in
            let action = UIAlertAction(title: StringsConstants.ok_message.getString, style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }

            Services.showAlert(style: .alert, title: StringsConstants.success_message.getString, message: message.html2String, actions: [action])
        }
    }
}

// MARK: - Indecator Delegate
extension ForgotPasswordVC: IndecatorDelegate {

    func didStartIndecator() {
        Services.startHudAnimation(title: "")
    }

    func didStop(withError errorMessage: String) {
        Services.showErrorAlert(with: errorMessage)
    }
}

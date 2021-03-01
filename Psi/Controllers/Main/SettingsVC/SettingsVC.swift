//
//  SettingsVC.swift
//  Psi
//
//  Created by Tayyab Ali on 12/21/20.
//

import UIKit

class SettingsVC: BaseVC {
    
    // MARK: - IBoutlets
    @IBOutlet weak var signInView: UIButton!
    @IBOutlet weak var signUpView: UIButton!
    @IBOutlet weak var logoutView: UIButton!
    
    // MARK: - Class Properties
    
    override func setupGUI() {
        // Initial Setup
        initialSetup()
    }
}

// MARK: - Class Methods
extension SettingsVC {
    
    fileprivate func initialSetup() {
        self.title = "Settings"
        
        let isLoggedIn = AppManager.shared.user.userType == .registered
        signInView.isHidden = isLoggedIn
        signUpView.isHidden = isLoggedIn
        logoutView.isHidden = !isLoggedIn
    }
}

// MARK: - IBActions
extension SettingsVC {
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        loadLoginVC()
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        loadSignUpVC()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        logoutButtonPressed()
    }
}

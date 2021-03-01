//
//  SplashVC.swift
//  Psi
//
//  Created by Tayyab Ali on 12/18/20.
//

import UIKit

class SplashVC: BaseVC {
    
    override func setupGUI() {
        
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            self?.proceedToNextScreen()
        }
    }
}

// MARK: - Class Methods
extension SplashVC {

    fileprivate func proceedToNextScreen() {
                
        let store = MTStore()
        
        if store.getUuid().isEmpty {
            makeUUID()
            return
        }
        fetchUserDetail()
//
//        if MTStore().getAuthToken().isEmpty {
//            Utils.switchToMain()
//            return
//        }
//        
//        fetchUserDetail()
    }
}

// MARK: - Apis Methods
extension SplashVC {

    fileprivate func fetchUserDetail() {
        
        let userVM = UserViewModel()
        userVM.indecatorDelegate = self
        userVM.fetchUserDetail {
            Utils.switchToMain()
        }
    }
    
    fileprivate func makeUUID() {
        let userVM = UserViewModel()
        userVM.indecatorDelegate = self
        userVM.makeUUID {
            Utils.switchToMain()
        }
    }
}

// MARK: - Indecator Delegate
extension SplashVC: IndecatorDelegate {

    func didStartIndecator() {
        Services.startHudAnimation(title: "")
    }

    func didStop(withError errorMessage: String) {
        AppManager.shared.resetAllSharedProperties()
        Utils.switchToMain()
    }
}

//
//  Utils+UIViewControllerExtension.swift
//  Foodie Canada
//
//  Created by Tayyab Ali on 30/03/2019.
//  Copyright © 2019 FantechLabs. All rights reserved.
//

import UIKit
import AVFoundation
import SafariServices

extension UIViewController {
    
    func isHideTabBar(status: Bool) {
        self.tabBarController?.tabBar.isHidden = status
    }
    
    func getViewController<T: UIViewController>(sbName: SB_IdentifireStrings, vcName: VCIdentifireStrings) -> T {
        
        let sb = UIStoryboard(name: sbName.rawValue, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: vcName.rawValue) as! T
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        return vc
        
    }
    
    func logoutButtonPressed() {
        
        let logoutAction = UIAlertAction(title: StringsConstants.logout.getString, style: .destructive, handler: { action in
            self.logout()
        })
        let cancelAction = UIAlertAction(title: StringsConstants.cancel.getString, style: .cancel, handler: nil)
        
        Services.showAlert(style: .alert, title: StringsConstants.logout.getString, message: StringsConstants.logout_detail_message.getString, actions: [logoutAction, cancelAction], completion: nil)
    }
        
    @objc func logout() {
        AppManager.shared.resetAllSharedProperties()
        Utils.switchToMain()
    }
    
    func openBrowserWith(url: String) {
        
        guard let url = URL(string: url) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    func setupNavigationBarStyle(largeTitleColor: UIColor = Theme.secondaryColor!, backgoundColor: UIColor = .white, tintColor: UIColor = Theme.secondaryColor!, preferredLargeTitle: Bool = false) {
        
        let navbar = navigationController!.navigationBar
        navbar.prefersLargeTitles = preferredLargeTitle
        navbar.isTranslucent = false
        navbar.tintColor = tintColor
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.backgroundColor = backgoundColor
            
            navbar.standardAppearance = navBarAppearance
            navbar.compactAppearance = navBarAppearance
            navbar.scrollEdgeAppearance = navBarAppearance
            
        } else {
            
            // Fallback on earlier versions
            navbar.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navbar.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
            navbar.superview?.backgroundColor = backgoundColor
        }
    }
}

extension UIViewController {

    func addChildViewControllerWithView(_ childViewController: UIViewController, toView view: UIView? = nil) {
        let view: UIView = view ?? self.view

        childViewController.removeFromParent()
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    func removeChildViewController(_ childViewController: UIViewController) {
        childViewController.removeFromParent()
        childViewController.willMove(toParent: nil)
        childViewController.removeFromParent()
        childViewController.didMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

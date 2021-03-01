//
//  BaseVC.swift
//  Linly
//
//  Created by Tayyab Ali on 9/22/20.
//  Copyright © 2020 Tayyab Ali. All rights reserved.
//

import UIKit
import AVKit

class BaseVC: UIViewController {

    /*One Time code setup*/
    func setupGUI() -> Void {
    }
    
    /*Code to reload the view. No One time code should be part of it*/
    func updateGUI() -> Void {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGUI()
        updateGUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

//
//  CustomTextField.swift
//  Linly
//
//  Created by Tayyab Ali on 9/22/20.
//  Copyright © 2020 Tayyab Ali. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 0.5, width: self.frame.width, height: 0.5)
        bottomLine.backgroundColor = Theme.primaryTextColor?.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
    }
}

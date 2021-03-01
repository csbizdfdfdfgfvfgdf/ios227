//
//  CustomSegmentControl.swift
//  Psi
//
//  Created by Tayyab Ali on 12/18/20.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.size.height / 2.0
//        layer.borderColor = Theme.borderColor?.cgColor
//        layer.borderWidth = 1.0
        layer.masksToBounds = true
        clipsToBounds = true
        
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = .clear
        } else {
            tintColor = .clear
        }
        
        let segmentStringSelected: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        let segmentStringHighlited: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor : Theme.secondaryDarkTextColor!
        ]
        
        setTitleTextAttributes(segmentStringHighlited, for: .normal)
        setTitleTextAttributes(segmentStringSelected, for: .selected)
        setTitleTextAttributes(segmentStringHighlited, for: .highlighted)
        
        backgroundColor = UIColor("0x#FCFCFC")

        for i in 0...subviews.count - 1{
            if let subview = subviews[i] as? UIImageView{
                subview.layer.cornerRadius = bounds.height / 2

                if i == self.selectedSegmentIndex {
                    subview.backgroundColor = Theme.secondaryColor
                }else{
                    subview.backgroundColor = .clear
                }
            }
        }
    }
}

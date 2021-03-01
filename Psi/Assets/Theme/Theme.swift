//
//  Theme.swift
//  dropryde-ios
//
//  Created by Uzair Mughal on 4/20/20.
//  Copyright © 2020 Uzair Mughal. All rights reserved.
//

import UIKit

class Theme: UIColor {
    
    //    static let sfProRegular = "SFProDisplay-Regular"
    //    static let sfProMedium = "SFProDisplay-Medium"
    //    static let sfProBold = "SFProDisplay-Bold"
    
    static func setFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Regular", size: size)!
    }
    
    static func setMediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Medium", size: size)!
    }
    
    static let appBackgroundColor = UIColor(named: "AppBackgroundColor")
    
    static let primaryColor = UIColor(named: "primaryColor")
    static let primaryTextColor = UIColor(named: "primaryTextColor")
    static let primaryDarkTextColor = UIColor(named: "primaryDarkTextColor")
    static let primaryLightTextColor = UIColor(named: "primaryLightTextColor")
    
    static let secondaryColor = UIColor(named: "secondaryColor")
    static let secondaryDarkColor = UIColor(named: "secondaryDarkColor")
    static let secondaryTextColor = UIColor(named: "secondaryTextColor")
    static let secondaryDarkTextColor = UIColor(named: "secondaryDarkTextColor")
    
    static let shadowColor = UIColor(named: "ShadowColor")
    static let borderColor = UIColor(named: "borderColor")
    
    static let receiverChatBackgroundColor = UIColor(named: "receiverTextColor")
    static let senderChatBackgroundColor = UIColor(named: "senderTextColor")

}

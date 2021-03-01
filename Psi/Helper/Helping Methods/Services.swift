//
//  Services.swift
//  Edit.me
//
//  Created by Tayyab Ali on 19/06/2019.
//  Copyright © 2019 Tayyab Ali. All rights reserved.
//

import UIKit
import JGProgressHUD
import AVFoundation
//import SDWebImage
//import ActionSheetPicker_3_0

extension UIViewController {
    
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIWindow.key?.rootViewController?.topMostViewController()
    }
}

class Services {
    
    static var rootViewController: UIViewController? {
        return UIApplication.shared.topMostViewController()
    }
    
    static func showAlert(style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: StringsConstants.ok_message.getString, style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        rootViewController?.present(alert, animated: true, completion: completion)
        
    }
    
    static func showErrorAlert(with message: String) {
        showAlert(style: .alert, title: StringsConstants.error_message.getString, message: message)
    }
    
    static var hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()

    //Start Animation of indecator
    static func startHudAnimation(title: String) {
        hud.textLabel.text = title
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.position = .center
        hud.show(in: rootViewController!.view)
    }

    static func dismissHud( text: String, detailText: String, delay: TimeInterval, completion: (() -> Void)? = nil) {

        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.tintColor = .white

        self.hud.textLabel.text = text
        self.hud.detailTextLabel.text = detailText
        //            self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: delay, animated: true)

        let when = DispatchTime.now() + delay + 0.5

        DispatchQueue.main.asyncAfter(deadline: when) {
            completion?()
            self.hud.detailTextLabel.text = ""
        }
    }
}

// MARK: - ActionSheet Picker Methods
//extension Services {
//    
//    static func alertSelection(on: UIViewController, title: String, initialValue: String, valuesArray: [String], style: UIAlertController.Style, completion: @escaping(String, Int)-> Void) {
//        var initialValue = valuesArray.contains(initialValue) == true ? initialValue : valuesArray[0]
//        var selectedIndex = valuesArray.firstIndex(of: initialValue) ?? 1
//        
//        ActionSheetStringPicker.show(withTitle: title,
//                                     rows: valuesArray,
//                                     initialSelection: selectedIndex,
//                                     doneBlock: { picker, value, index in
//                                        initialValue = valuesArray[value]
//                                        selectedIndex = value
//                                        completion(initialValue, selectedIndex)
//                                        
//                                        print("picker = \(String(describing: picker))")
//                                        print("value = \(value)")
//                                        print("index = \(String(describing: index))")
//                                        return
//        },
//                                     cancel: { picker in
//                                        return
//        },
//                                     origin: on.view)
//    }
//    
//    static func dateTimePicker(with initialDate: Date?, maxDate: Date? = nil, miniDate: Date? = nil, title: String, pickerMode: UIDatePicker.Mode, on: UIViewController, completion: @escaping(Date)-> Void) {
//        
//        let datePicker = ActionSheetDatePicker(title: title,
//                                               datePickerMode: pickerMode,
//                                               selectedDate: initialDate,
//                                               doneBlock: { picker, date, origin in
//                                                print("picker = \(String(describing: picker))")
//                                                print("date = \(String(describing: date))")
//                                                print("origin = \(String(describing: origin))")
//                                                completion(date as! Date)
//        },
//                                               cancel: { picker in
//                                                return
//        },
//                                               origin: on.view)
//        datePicker?.minimumDate = miniDate
//        datePicker?.maximumDate = maxDate
//        datePicker?.show()
//    }
//}

//MARK:- Alert Selection Methods
//extension Services {
//
//    static func alertSelection(on: UIViewController, title: String, initialValue: String, valuesArray: [String], style: UIAlertController.Style, completion: @escaping(String, Int)-> Void) {
//
//        var initialValue = valuesArray.contains(initialValue) == true ? initialValue : valuesArray[0]
//        var selectedIndex = valuesArray.firstIndex(of: initialValue) ?? 0
//
//        let pickerViewValues: [[String]] = [valuesArray.map { ($0).description }]
//        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: valuesArray.firstIndex(of: initialValue) ?? 0)
//
//        let alert = UIAlertController(style: style, title: title, message: "")
//
//        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
//
//            DispatchQueue.main.async {
//                UIView.animate(withDuration: 1) {
//                    initialValue = valuesArray[index.row]
//                    selectedIndex = index.row
//                }
//            }
//
//        }
//        alert.addAction(UIAlertAction(title: StringsConstants.ok_message, style: .default, handler: { action in
//            completion(initialValue, selectedIndex)
//
//        }))
//
//        alert.addAction(UIAlertAction(title: StringsConstants.cancel, style: .cancel, handler: nil))
//
//        on.present(alert, animated: true, completion: nil)
//    }
//}

// MARK: - Image Picker
extension Services {
    
//    static func setImage(imageView: UIImageView, imageUrl: String?, placeholder imageName: String) {
//        
//        if imageUrl == nil {
//            imageView.image = UIImage(named: imageName)
//            return
//        }
//        
//        guard let  URL = URL(string: imageUrl!) else {
//            imageView.image = UIImage(named: imageName)
//            return
//        }
//        
//        imageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
//        imageView.sd_setImage(with: URL, placeholderImage: UIImage(named: imageName), options: .scaleDownLargeImages, completed: nil)
//    }
    
//    static func setButtonImage(button: UIButton, imageUrl: String?, placeholder imageName: String) {
//
//        if imageUrl == nil {
//            button.imageView?.image = UIImage(named: imageName)
//            return
//        }
//
//        guard let  URL = URL(string: imageUrl!) else {
//            button.imageView?.image = UIImage(named: imageName)
//            return
//        }
//
//        button.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
//        button.sd_setImage(with: URL, for: .normal, placeholderImage: UIImage(named: imageName), options: .progressiveLoad, completed: nil)
//    }
    
    static func copyVideoAndGetUrl(videoUrl: URL) -> URL? {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent("copy.mov")
        
        guard let data = try? Data(contentsOf: videoUrl) else { return nil }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
                return nil
            }
        }
        
        do {
            try data.write(to: fileURL)
            return fileURL
            
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }

}

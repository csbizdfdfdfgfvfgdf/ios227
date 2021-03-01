//
//  Helping Methods.swift
//  SportLocator
//
//  Created by Nouman Naseer on 10/04/2019.
//  Copyright © 2019 Nouman Naseer. All rights reserved.
//

import UIKit

//"yyyy-dd-MM" - dd-MM-yyyy - MMMM d, yyyy - MM/dd/yyyy hh:mm a - "HH:mm" - EEEE - hh:mm a

enum dateForamte : String{
    case yearDayMonth = "yyyy-MM-dd"
    case dayMonthYear = "dd-MM-yyyy"
    case month = "MMM d, yyyy"
    case dateWithTime = "MM-dd-yyyy HH:mm"
    case twentyFourHour = "HH:mm:ss"
    case onlyDay = "EEE"
    case twelveHour = "hh:mm a"
    case meridiemSymbol = "a"
    case getMonth = "LLL"
    case monthAndYear = "MMMM, yyyy"
    case time = "h:mm a"
    case monthAndDate = "dd MMM"
    case dayWithTime = "EEEE hh:mm a"
    
    case universalFormatDateTime = "yyyy-MM-dd HH:mm:ss"
    case universalTwelveHourFormatDateTime = "yyyy-MM-dd hh:mm:ss"
    case secondUniversalTimeDateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
}

func openBrowserWith(url: String) {
    
    if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

func setDateFormate(date: Date,formate: dateForamte)-> Date {
    
    let dts = dateToString(date: date, formate: formate)
    let std = stringToDate(date: dts, formate: formate)
    
    return std
}


func dateToString(date: Date,formate: dateForamte)-> String {
    
    let dateFormatter: DateFormatter  = DateFormatter()
    dateFormatter.dateFormat = formate.rawValue
    dateFormatter.timeZone = TimeZone.current//(abbreviation: "UTC")
    return dateFormatter.string(from: date)
}


func stringToDate(date: String, formate: dateForamte)-> Date {
    
    let dateFormatter: DateFormatter  = DateFormatter()
    dateFormatter.dateFormat =  formate.rawValue
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let dateStr = dateFormatter.date(from: date)
    
    return dateStr ?? Date()
}

func convertDateIntoSeconds(date: Date) -> Int {
    
    let calendar = Calendar.current
    
    let hour = calendar.component(.hour, from: date)
    let minutes = calendar.component(.minute, from: date)
    let seconds = calendar.component(.second, from: date)
    
    let secondInHours = hour * 3600
    let secondInMin = minutes * 60
    
    return (secondInHours + secondInMin + seconds)
    
}

func roundDateDown(date: Date, toNearestMinuites: Int)-> Date {
    
    let calendar = Calendar.current
    let rightNow = Date()
    let nextDiff = toNearestMinuites - calendar.component(.minute, from: rightNow) % toNearestMinuites
    let roundedDate = calendar.date(byAdding: .minute, value: nextDiff, to: rightNow) ?? Date()
    
    return roundedDate
}

func timeIntervelToDate(timeInterval: Double) -> Date {
    
    return Date(timeIntervalSince1970: TimeInterval(timeInterval))
    
}

func timeDifference(startDate: Date, endDate: Date) -> (Int, Int, Int) {
    let timeDifference = Int(endDate.timeIntervalSince1970) - Int(startDate.timeIntervalSince1970)
    let minutes = (timeDifference / 60) % 60
    let hours = (timeDifference / 3600)
    let day = (timeDifference / 86400)
    
    return (day, hours, minutes)
}

func countdownTimeString(time:TimeInterval) -> String {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
}

func makePhoneCallUsing(number: String) {
    guard let number = URL(string: "tel://" + number) else { return }
    UIApplication.shared.open(number)
}

func getNumberFromString(value: String) -> Int {
    
    if let number = Int(value.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
        return number
    }
    
    return 0
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

func changeSearchBarBackgroundColor(searchBar: UISearchBar, color: UIColor) {

    searchBar.barTintColor = color
    
    if #available(iOS 13, *) {
        searchBar.searchTextField.backgroundColor = color
    }
}

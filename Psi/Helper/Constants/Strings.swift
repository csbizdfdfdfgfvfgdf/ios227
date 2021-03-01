//
//  Strings.swift
//  Edit.me
//
//  Created by Tayyab Ali on 17/06/2019.
//  Copyright © 2019 Tayyab Ali. All rights reserved.
//

import Foundation

enum StringsConstants: String {
    
    var getString : String {
        return self.rawValue
    }
    
    case empty = ""
    
    //MARK: - Navbar Title
    case sign_in = "Sign in"
    case forgot_password_navbar_title = "Forgot Password"
    
    //MARK: - Basic Alert Strings
    case success_message = "Success"
    case error_message = "Error"
    case ok_message = "Ok"
    case cancel = "Cancel"
    case alert = "Alert"
    case logout = "Logout"
    case logout_detail_message = "Are you sure for Logout?"

    //    static let select = "select an option"
    //    static let confirm_message = "Confirm"
    //    static let proceed = "Proceed"
    //    static let copy = "Copy"
    //    static let edit = "Edit"
    //    static let duplicate = "Duplicate"
    //    static let delete = "Delete"
    //    static let delete_detail_message = "You really want to delete this item?"
    //    static let no = "no"
    //    static let yes = "yes"
    //    static let logout_message = "Logout"
    //    static let logout_detail_message = "Are you sure for Logout?"
    //    static let saved = "Saved!"
    //    static let done = "Done"
    //    static let select_to_import = "Select to import"
    
    // MARK: - Camera Strings
    static let camera = "Camera"
    static let gallery = "Gallery"
    static let image_save = "Your altered image has been saved to your photos."
    static let camara_permission_required = "camara permission is required to use this feature"
    static let choose_option = "choose option"
    static let camera_not_available = "Camera not Available"
    
    // MARK: - OnBoarding
    case not_logged_in = "Please login to continue"
    case terms = "Terms"
    case privacy_policy = "Privacy Policy"
    case cookies_policy = "Cookies Policy"
    case change_number = "Learn what happens when your number changes."
    // MARK: - Forgot
    //    static let reset_password_link_send = "Reset Link is send to your email. Please check your email"
    
    // MARK: - MAIN
    case add_to_bag = "Add To Bag"
    case add_to_wishlist = "Add To Wishlist"
    case empty_cart_list = "Your cart list is empty."
    
    //Fields validations check
    //    static let valid = "valid"
    //    static let select_date = "Select Date"
    //    static let item_size = "Select Size"
    //    static let field_error_string = "%@ is required"
    //    static let credentials_error = "Please enter valid credentials"
    
    //Notification string
    //    static let notify_Date = "Select Date For Notification"
    
    //    case loading = "loading..."
    
}

//Validations
enum ValidationsError: String {
    
    var string : String {
        return self.rawValue
    }
    case empty = ""
    case valid_username_error = "Please enter a valid username"
    case valid_email_error = "Please enter a valid email"
    case valid_password_error = "Password should be 6 character long"
    case password_mismatch_error = "Password mismatch"
    case name_error = "Please enter username"
    //    case last_name_error = "Please enter last name"
    case phone_number_error = "Please enter a valid phone number"
    case address_error = "Please enter your address"
    case city_name_error = "Please select city"
    //    case state_error = "Please enter a valid state"
    case zip_code_error = "Please enter zip code"
    case country_error = "Please select country"
    //    case years_of_info_error = "Please enter years of information"
    //    case license_error = "Please enter your license"
    //    case vehicle_error = "Please select atleast 1 vehicle"
    //    case signature_required = "Signature required"
    //    case empty_order_images = "Atlease 1 order image is required"
    //    case empty_pod = "POD is required"
    //    case empty_pop = "POP is required"
    //    case empty_signature_error = "Signature image is required"
    //    case empty_note = "Please write something..."
    //    case empty_records = "There are no %@ available at this time."
    //    case confirm_total_pieces = "Please confirm the total number of pieces"
    case unknown_error = "Unknown Error"
}

enum SB_IdentifireStrings : String {
    
    case onBoarding = "OnBoarding"
    case main = "Main"
}

//MARK: - VC Identiofiers
enum VCIdentifireStrings : String {
    
    // ONBOARDING
    case LoginVC
    case SignUpVC
    
    // MAIN
    case FolderAndNotesListVC
    case CreateOrUpdateNoteVC
    case NoteDetailVC
    case SettingsVC
}

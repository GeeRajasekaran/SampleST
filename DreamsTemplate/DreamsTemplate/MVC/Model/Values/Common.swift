//
//  Common.swift
//  Gigs
//
//  Created by dreams on 03/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import Foundation
import UIKit

class alertNetwork {
    
    var aDictGetLangInfo = SESSION.getLangInfo()
    var aDictNetwork = [String:Any]()
    var ALERT_NO_INTERNET = ""
    var ALERT_TYPE_NO_DATA = ""
    var ALERT_TYPE_SERVER_ERROR = ""
    var ALERT_NO_INTERNET_DESC = ""
    var ALERT_NO_RECORDS_FOUND = ""
    var ALERT_LOADING_CONTENT = ""

    init() {
        
        if let dict = aDictGetLangInfo["common_used_texts"] as? [String : Any] {
            aDictNetwork = dict
        }
        if let alert = aDictNetwork["lg7_please_enable_i"]as? String {
            ALERT_NO_INTERNET = alert
        }
//         = aDictNetwork["lg7_please_enable_i"] as! String
        ALERT_TYPE_NO_DATA = aDictNetwork["lg7_no_data_were_fo"] as? String ?? ""
        ALERT_TYPE_SERVER_ERROR = aDictNetwork["lg7_oops__problem_o"] as? String ?? ""
        ALERT_NO_INTERNET_DESC = aDictNetwork["lg7_oops_itseems_li"] as? String ?? ""
        ALERT_NO_RECORDS_FOUND = aDictNetwork["lg7_no_records_foun"] as? String ?? ""
        ALERT_LOADING_CONTENT = aDictNetwork["lg7_loading"] as? String ?? ""
    }
}

//Color
//let APP_PRIMARY_COLOR :String = "d42129"
let APP_PRIMARY_COLOR :String = SESSION.getPrimaryColorCode()

let APP_SECONDARY_COLOR :String = "646464"
let FB_COLOR :String = "4b75bd"
let GOOGLE_COLOR :String = "fe5240"
let APP_NAME = "ServRep"

let WEB_DATE_FORMAT :String = "yyyy-MM-dd"
let WEB_TIME_FORMAT :String = "hh:mm a"

let GOOGLE_API_KEY = "AIzaSyD-0NQvG8kMoI7kgYfRqH6nApt2qAOQNDo"

//Button Name
let BTN_OK :String = "Ok"
let BTN_CANCEL :String = "Cancel"
let BTN_YES :String = "Yes"
let BTN_NO :String = "No"
let BTN_DONE :String = "Done"
let BTN_NEXT :String = "Next"

//Register Field Title
let REG_NAME :String = "Name"
let REG_FIRST_NAME :String = "Firstname"
let REG_LAST_NAME :String = "Lastname"
let REG_USER_NAME :String = "Username"
let REG_PHONE :String = "Phone"
let REG_EMAIL :String = "Email Address"
let REG_MOBILE :String = "Mobile Number"
let REG_PASSWORD :String = "Password"
let REG_REPEAT_PASSWORD :String = "Repeat Password"
let REG_COUNTRY :String = "Country"
let REG_STATE :String = "State"
let REG_ADDRESS :String = "Address"
let REG_CITY :String = "City"
let REG_ZIPCODE :String = "Zip Code"
let REG_LANGUAGE :String = "Language"
let REG_PROFESSION :String = "Profession"
let REG_ADDRESS_LINE :String = "Address Line"
let REG_SUGGESTION :String = "Suggestion about you"

let APP_ALERT_TITLE_USERNAME :String = "User name"
let APP_ALERT_TITLE_PASSWORD :String = "Password"
let APP_ALERT_TITLE_EMAIL_ID :String = "Email id"
let APP_ALERT_TITLE_MOBILE_NO :String = "Mobile number"
let APP_ALERT_TITLE_CONTRY_CODE :String = "Country code"
let APP_ALERT_TITLE_NAME :String = "Name"
let APP_ALERT_TITLE_FIRST_NAME :String = "First name"
let APP_ALERT_TITLE_LAST_NAME :String = "Last name"
let APP_ALERT_TITLE_MUST_LOGIN : String = "For Place an Order you must Logged In"
let APP_ALERT_TITLE_CHOOSE_PAYMENT_TYPE : String = "Choose any one Payment Type"
let APP_ALERT_TITLE_REASON :String = "Reason"
let APP_ALERT_TITLE_ACCOUNT_HOLDER_NAME :String = "Account Holder Name"
let APP_ALERT_TITLE_ACCOUNT_NO :String = "Account Number"
let APP_ALERT_TITLE_BANK_NAME :String = "Bank Name"
let APP_ALERT_TITLE_BANK_ADDRESS :String = "Bank Address"
let APP_ALERT_TITLE_SORT_CODE :String = "Sort Code"
let APP_ALERT_TITLE_ROUTING_NUMBER :String = "Routing Number"
let APP_ALERT_TITLE_IFSC_CODE :String = "IFSC Code"
let APP_ALERT_TITLE_MUST_LOCATIONON : String = "ServRep app would like to use your current location to display it on the app. It is secure and private"


let SCREEN_TITLE_LOGIN = "Login"
let SCREEN_TITLE_MY_PROFILE = "My Profile"
let SCREEN_TITLE_REGISTER = "Register"
let SCREEN_TITLE_MY_REQUESTS = "My Requests"
let SCREEN_TITLE_MY_SERVICES = "My Services"
let SCREEN_TITLE_HISTORY = "History"
let SCREEN_TITLE_CHAT_HISTORY = "Chat History"
let SCREEN_TITLE_LOGOUT = "Logout"

let SCREEN_TITLE_HOME = "Home"
let SCREEN_TITLE_FORGET_PASSSWORD = "Forgot Password"
let SCREEN_TITLE_CHANGE_PASSWORD = "Change Password"
let SCREEN_TITLE_SETTINGS = "Settings"


let STRIPE_CARD_NUMBER = "Number"
let STRIPE_CARD_EXPIRES = "Expires"
let STRIPE_CARD_CVV = "CVV"

//let GREEN_COLOR = "33af90"
//let BLACK_COLOR = "515050"
//let YELLOW_COLOR = "fdbd35"
//let BLUE_COLOR = "5ea6d7"
//let RED_COLOR = "d86060"

// Loading Title

let LOADING_DEFAULT_TITLE = "Loading.."
let LOADING_PLEASEWAIT_TITLE = "Please wait.."

// Stripe Content Title
let CONTENT_TITLE_REASON = "REASON"
let CONTENT_TITLE_ACC_HOLDER_NAME = "ACCOUNT HOLDER NAME"
let CONTENT_TITLE_ACC_NO = "ACCOUNT NUMBER"
let CONTENT_TITLE_IBAN = "IBAN"
let CONTENT_TITLE_BANK_NAME = "BANK NAME"
let CONTENT_TITLE_BANK_ADDRESS = "BANK ADDRESS"
let CONTENT_TITLE_SORT_CODE = "SORT CODE(UK)"
let CONTENT_TITLE_ROUTING_NUMBER = "ROUTING NUMBER(US)"
let CONTENT_TITLE_IFSC_CODE = "IFSC CODE(INDIAN)"

let LOGIN_THROUGH_NORMAL = 1
let LOGIN_THROUGH_FB = 2
let LOGIN_THROUGH_GOOGLE = 3

// Paypal Content Title
let CONTENT_TITLE_PAYPAL_EMAIL_ID = "PAYPAL EMAIL ID"

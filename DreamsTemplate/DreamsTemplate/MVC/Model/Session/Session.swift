//
//  Session.swift
//  DriverUtilites
//
//  Created by Guru Prasad chelliah on 10/24/17.
//  Copyright © 2017 project. All rights reserved.
//

import UIKit

class Session: NSObject {
    
    static let sharedInstance: Session = {
        
        let instance = Session()
        
        // setup code
        
        return instance
    }()
    
    
    // MARK: - Shared Methods
    
    func setAppLaunchIsFirstTime(isLogin : Bool) {
        
        
        UserDefaults.standard.set(isLogin, forKey: "app_launch_first_time")
        userdefaultsSynchronize()
    }
    
    func IsAppLaunchFirstTime() -> Bool {
        
        if  UserDefaults.standard.object(forKey: "app_launch_first_time") == nil {
            
            return true
        }
        
        return UserDefaults.standard.bool(forKey: "app_launch_first_time")
    }

    
    // Set and get user id
    
    func setIsUserLogIN(isLogin : Bool) {
        
        UserDefaults.standard.set(isLogin, forKey: "user_log_in")
        userdefaultsSynchronize()
    }
    
    func isUserLogIn() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "user_log_in")
    }
    
    func setIsUserLogINFirstTime(isLogin : Bool) {
        
        UserDefaults.standard.set(isLogin, forKey: "user_log_in_FirstTime")
        userdefaultsSynchronize()
    }
    
    func isUserLogInFirstTime() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "user_log_in_FirstTime")
    }
    
    // Set and get App Language Name
    func setAppLanguage(aStrAppLang : String) {
        
        UserDefaults.standard.set(aStrAppLang, forKey: "app_lang")
        userdefaultsSynchronize()
    }
    
    func getAppLanguage() -> String {
        
        if let appLang = UserDefaults.standard.string(forKey: "app_lang") {
            return appLang
        }
        return ""
        
    }
    
    // Set and get App Language Name
    func setLocationName(aStrLocName : String) {
        
        UserDefaults.standard.set(aStrLocName, forKey: "loc_name")
        userdefaultsSynchronize()
    }
    
    func getLocationName() -> String {
        
        if let appLang = UserDefaults.standard.string(forKey: "loc_name") {
            return appLang
        }
        return ""
        
    } //
    
    // Set and get App Language Image
    func setAppLanguageImage(aStrAppLang : String) {
        
        UserDefaults.standard.set(aStrAppLang, forKey: "app_lang_image")
        userdefaultsSynchronize()
    }
    
    func getAppLanguageImage() -> String {
        
        if let appLang = UserDefaults.standard.string(forKey: "app_lang_image") {
            return appLang
        }
        return ""
        
    } //
    
    
    // Set and get user id
    func setUserId(aStrUserId : String) {
        
        UserDefaults.standard.set(aStrUserId, forKey: "user_id")
        userdefaultsSynchronize()
    }
    
    func getUserId() -> String {
        
        if let userid = UserDefaults.standard.string(forKey: "user_id") {
            return userid
        }
        return ""
        
    } //let K_USER_id = "userid"
    
   
    // facebook id
    
    func setUserFacebookId(aStrUserId : String) {
        
        UserDefaults.standard.set(aStrUserId, forKey: "user_fbid")
        userdefaultsSynchronize()
    }
    
    func getUserFacebookId() -> String {
        
        if let userid = UserDefaults.standard.string(forKey: "user_fbid") {
            return userid
        }
        return ""
        
    }
   
    func setUserSignupdetailsForFB(fbId : String, uname:String, token:String) {
        
        UserDefaults.standard.set(fbId, forKey: "user_fbid")
        UserDefaults.standard.set(uname, forKey: "user_fbname")
        UserDefaults.standard.set(token, forKey: "user_fbtoken")
//        UserDefaults.standard.set(profilepicurl, forKey: "user_fbprofilepic")

        
        userdefaultsSynchronize()
    }
    
    func getUserSignupdetailsForFB() -> (String,String,String) {
        
        var userid = ""
        var username = ""
        var usertoken = ""
        
        if let user = UserDefaults.standard.string(forKey: "user_fbid") {
            userid = user
        }
        if let usern = UserDefaults.standard.string(forKey: "user_fbname") {
            username = usern
        }
        if let usert = UserDefaults.standard.string(forKey: "user_fbtoken") {
            usertoken = usert
        }
        return (userid,username,usertoken )
        
    }
    // Lat Long
    
    func setUserLatLong(lat: String,long:String) {
        
        UserDefaults.standard.set(lat, forKey: "user_Lat")
        UserDefaults.standard.set(long, forKey: "user_Long")
        userdefaultsSynchronize()
    }
    
    func getUserLatLong() -> (String,String) {
        
        var userlat = ""
        var userlong = ""
        
        if let usern = UserDefaults.standard.string(forKey: "user_Lat") {
            userlat = usern
        }
        if let usert = UserDefaults.standard.string(forKey: "user_Long") {
            userlong = usert
        }
         return (userlat,userlong )
    }
    
    func setUserUpdatedLatLonginGoogleSearch(lat: String,long:String) {
        
        UserDefaults.standard.set(lat, forKey: "user_Lat_Updated")
        UserDefaults.standard.set(long, forKey: "user_Long_Updated")
        userdefaultsSynchronize()
    }
    
    func getUserUpdatedLatLonginGoogleSearch() -> (String,String) {
        
        var userlat = ""
        var userlong = ""
        
        if let usern = UserDefaults.standard.string(forKey: "user_Lat_Updated") {
            userlat = usern
        }
        if let usert = UserDefaults.standard.string(forKey: "user_Long_Updated") {
            userlong = usert
        }
        return (userlat,userlong )
    }
    
    // Google
    
    func setUserSignupdetailsForGoogle(Id : String, uname:String, email:String?) {
        
        UserDefaults.standard.set(Id, forKey: "user_Goid")
        UserDefaults.standard.set(uname, forKey: "user_Goname")
        UserDefaults.standard.set(email, forKey: "user_Goemail")
        UserDefaults.standard.set(email, forKey: "user_email")
        
        //        UserDefaults.standard.set(profilepicurl, forKey: "user_fbprofilepic")
        
        
        userdefaultsSynchronize()
    }
    
    func getUserSignupdetailsForGoogle() -> (String,String,String) {
        
        var userid = ""
        var username = ""
        var useremail = ""
        
        if let user = UserDefaults.standard.string(forKey: "user_Goid") {
            userid = user
        }
        if let usern = UserDefaults.standard.string(forKey: "user_Goname") {
            username = usern
        }
        if let usermail = UserDefaults.standard.string(forKey: "user_Goemail") {
            useremail = usermail
        }
        return (userid,username,useremail )
        
    }
    func setUserFbSigninStatus(status : Bool) {
        
        UserDefaults.standard.set(status, forKey: "Fb_status")
        userdefaultsSynchronize()
    }
    
    func getUserFbsigninStatus() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "Fb_status")
    }
    func setUserGoogleSigninStatus(status : Bool) {
        
        UserDefaults.standard.set(status, forKey: "Google_status")
        userdefaultsSynchronize()
    }
    
    func getUserGoogleStatus() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "Google_status")
    }
    
    func setUserGoogleId(aStrUserId : String) {
        
        UserDefaults.standard.set(aStrUserId, forKey: "user_Gooid")
        userdefaultsSynchronize()
    }
    
    func getUserGoogleId() -> String {
        
        if let userid = UserDefaults.standard.string(forKey: "user_Gooid") {
            return userid
        }
        return ""
        
    }
    //App language
    func setLangInfo(dictInfo: [String:Any]) {
        
        UserDefaults.standard.set(dictInfo, forKey: "lang_info")
        userdefaultsSynchronize()
    }
    func getLangInfo() -> [String:Any] {
        
        if let info = UserDefaults.standard.dictionary(forKey: "lang_info") {
             return info
        }
       return [:]
    }
    //Splash screen
    func setSplashScreenStatus(status : Bool) {
        
        UserDefaults.standard.set(status, forKey: "Splash_status")
        userdefaultsSynchronize()
    }
    
    func getSplashScreenStatus() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "Splash_status")
    }
    
    // Set and get password
    func setCurrentPassword(password : String) {
        
        UserDefaults.standard.set(password, forKey: "current_pwd")
        userdefaultsSynchronize()
    }
    
    func getCurrentPassword() -> String {
        
        return UserDefaults.standard.string(forKey: "current_pwd")!
    }
    // SET and get Token
    
    func setUserToken(aStrUserToken : String) {
        
        UserDefaults.standard.set(aStrUserToken, forKey: "user_Token")
        userdefaultsSynchronize()
    }
    
    func getUserToken() -> String {
        
        if let token = UserDefaults.standard.string(forKey: "user_Token") {
            return token
        }
        return ""
        
    }
    
    // Set and get Base iIage URL
    func setBaseImageUrl(aStrImageUrl : String) {
        
        UserDefaults.standard.set(aStrImageUrl, forKey: "base_image_url")
        userdefaultsSynchronize()
    }
    
    func getBaseImageUrl() -> String {
        
        return UserDefaults.standard.string(forKey: "base_image_url")!
    }
    
    // Set and get student id
    func setStudentId(aStrUserId : String) {
        
        UserDefaults.standard.set(aStrUserId, forKey: "student_id")
        userdefaultsSynchronize()
    }
    
    func getStudentId() -> String {
        
        return UserDefaults.standard.string(forKey: "student_id")!
    }
    
    // Set and get user name
    
    func setUserName(aStrUserName : String) {
        
        UserDefaults.standard.set(aStrUserName, forKey: "user_name")
        userdefaultsSynchronize()
    }
    
    func getUserName() -> String {
        if let name = UserDefaults.standard.string(forKey: "user_name") {
            return name
        }
        return ""
    }
    func setCurrentChatUserName(aStrUserName : String) {
        
        UserDefaults.standard.set(aStrUserName, forKey: "chatuser_name")
        userdefaultsSynchronize()
    }
    
    func getCurrentChatUserName() -> String {
        if let name = UserDefaults.standard.string(forKey: "chatuser_name") {
            return name
        }
        return ""
    }
    func setUserEmail(aStrUserName : String) {
        
        UserDefaults.standard.set(aStrUserName, forKey: "user_email")
        userdefaultsSynchronize()
    }
    
    func getUserEmail() -> String {
        if let name = UserDefaults.standard.string(forKey: "user_email") {
            return name
        }
        return ""
    }
    
    func setUserSubscriptionStatus(status : Bool) {
        
        UserDefaults.standard.set(status, forKey: "UserSubscription_status")
        userdefaultsSynchronize()
    }
    
    func getUserSubscriptionStatus() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "UserSubscription_status")
    }
    func setUserSubscriptionType(type : String) {
        
        UserDefaults.standard.set(type, forKey: "UserSubscription_Type")
        userdefaultsSynchronize()
    }
    
    func getUserSubscriptionType() -> String {
        
        if let type = UserDefaults.standard.string(forKey: "UserSubscription_Type") {
            return type
        }
        return ""
    }
    func setUserIDcardStatus(status : Bool) {
        
        UserDefaults.standard.set(status, forKey: "UserIDcard_status")
        userdefaultsSynchronize()
    }
    
    func getUserIDcardStatus() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "UserIDcard_status")
    }
    // Set and get paypal id
    
    func setPaypalId(aStrPaypalId : String) {
        
        UserDefaults.standard.set(aStrPaypalId, forKey: "paypal_email")
        userdefaultsSynchronize()
    }
    
    func getPaypalId() -> String {
        if let name = UserDefaults.standard.string(forKey: "paypal_email") {
            return name
        }
        return ""
    }
    
    // Set and get user image
    func setUserImage(aStrUserImage : String) {
        
        UserDefaults.standard.set(aStrUserImage, forKey: "user_image")
        userdefaultsSynchronize()
    }
    
    func getUserImage() -> String {
        
        if let image = UserDefaults.standard.string(forKey: "user_image") {
            return image
        }
        return ""
    }
    //ID card
    func setUserIDcardImage(aStrUserImage : String) {
        
        UserDefaults.standard.set(aStrUserImage, forKey: "user_IDcardimage")
        userdefaultsSynchronize()
    }
    
    func getUserIDCardImage() -> String {
        
        if let image = UserDefaults.standard.string(forKey: "user_IDcardimage") {
            return image
        }
        return ""
    }
    func setSessionId(strSessionId: String) {
        
        UserDefaults.standard.set(strSessionId, forKey: "session_id")
        userdefaultsSynchronize()
    }
    
    func getSessionId() -> String {
        
        return UserDefaults.standard.string(forKey: "session_id")!
    }
    
    
    // Set and get device token
    func setDeviceToken(deviceToken : String) {
        
        UserDefaults.standard.set(deviceToken, forKey: "device_token")
        userdefaultsSynchronize()
    }
    
    func getDeviceToken() -> String {
        
        if UserDefaults.standard.string(forKey: "device_token") != nil {
            return UserDefaults.standard.string(forKey: "device_token")! as String
        }
        
        return ""
    }
    
    func setUserInfo(dictInfo: [String:String]) {
        
        UserDefaults.standard.set(dictInfo, forKey: "user_info")
        userdefaultsSynchronize()
    }
    
    func getUserInfo() -> [String:String] {
        
        return UserDefaults.standard.dictionary(forKey: "user_info") as! [String : String]
    }
    
    
    func setBannerInfo(dictInfo: [[String:String]]) {
        
        UserDefaults.standard.set(dictInfo, forKey: "banner_info")
        userdefaultsSynchronize()
    }
    
    func getBannerInfo() -> [[String:String]] {
        
        if UserDefaults.standard.array(forKey: "banner_info") != nil {
            return UserDefaults.standard.array(forKey: "banner_info") as! [[String : String]]
        }
        
        let aAryInfo = [[String : String]]()
        return aAryInfo
    }
    
    func setIsUPushNotificationStatus(isLogin : Bool) {
        
        UserDefaults.standard.set(isLogin, forKey: "push_notification_status")
        userdefaultsSynchronize()
    }
    
    func getPushNotificationStatus() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "push_notification_status")
    }
    
    func setPassword(strSessionId: String) {
        
        UserDefaults.standard.set(strSessionId, forKey: "password")
        userdefaultsSynchronize()
    }
    
    func getPassword() -> String {
        
        return UserDefaults.standard.string(forKey: "password")!
    }
    
    // Set and get user id
    
    func setIsUploadAnswer(isAnswer : Bool) {
        
        UserDefaults.standard.set(isAnswer, forKey: "is_upload")
        userdefaultsSynchronize()
    }
    
    func isUploadAnswer() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "is_upload")
    }
    
    //Set and Get Upload Document Photos
    
    func setUploadDocument(dictInfo: [[String:AnyObject]]) {
        
        UserDefaults.standard.set(dictInfo, forKey: "imageupload")
        userdefaultsSynchronize()
    }
    
    func getUploadDocument() -> [[String:Any]] {
        
        if UserDefaults.standard.array(forKey: "imageupload") != nil {
            return UserDefaults.standard.array(forKey: "imageupload") as! [[String : Any]]
        }
        
        let aAryInfo = [[String : Any]]()
        return aAryInfo
    }
    
    // Set and get video recoreder permission
    
    func setIsPhotoLibraryPermisson(isAnswer : Bool) {
        
        UserDefaults.standard.set(isAnswer, forKey: "photo_permission")
        userdefaultsSynchronize()
    }
    
    func isPhotoLibraryPermisson() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "photo_permission")
    }
    
    // MARK: - Private Methods
    
    private func userdefaultsSynchronize() {
        
        UserDefaults.standard.synchronize()
    }
    
    // MARk:- Set and Get user price option
    
    func setUserPriceOption(option:String,price:String,extraprice:String) {
        
        UserDefaults.standard.set(option, forKey: "user_price_option")
        UserDefaults.standard.set(price, forKey: "gigs_price")
        UserDefaults.standard.set(extraprice, forKey: "extra_gig_price")
        userdefaultsSynchronize()
    }
    
    func getUserPriceOption() -> (String,String,String) {
        
        var priceoption = ""
        var gigsprice = ""
        var gigsextraprice = ""

        if let option = UserDefaults.standard.string(forKey: "user_price_option") {
            priceoption = option
        }
        if let price = UserDefaults.standard.string(forKey: "gigs_price") {
            gigsprice = price
        }
        if let extraprice = UserDefaults.standard.string(forKey: "extra_gig_price") {
            gigsextraprice = extraprice
        }
        return (priceoption, gigsprice, gigsextraprice)
        
    }
    
    func setColorCode(dictInfo: [String:Any]) {
        
        UserDefaults.standard.set(dictInfo, forKey: "color_code")
        userdefaultsSynchronize()
    }
    
    func getColorCode() -> [String:Any] {
        
        return UserDefaults.standard.dictionary(forKey: "color_code") as! [String : String]
    }
    
    func setPrimaryColorCode(colorCode: String) {
        
        var aStr = colorCode
        
        aStr = aStr.replacingOccurrences(of: "#", with: "", options: .literal, range: nil)
        UserDefaults.standard.set(aStr, forKey: "primary_color_code")
        userdefaultsSynchronize()
    }
    
    func getPrimaryColorCode() -> String  {
        
        if UserDefaults.standard.string(forKey: "primary_color_code") == nil {
            
            return "d42129"
        }
        
        return UserDefaults.standard.string(forKey: "primary_color_code")!
    }
}

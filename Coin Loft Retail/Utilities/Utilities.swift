//
//  Utilities.swift
//  CabInn
//
//  Created by Apple on 26/01/2016.
//  Copyright © 2016 CabInn. All rights reserved.
//

import Foundation
import SystemConfiguration

class Utilities: NSObject {
    static let sharedInstance = Utilities()
    private override init() {}
    
    //MARK: User Defaults
    
    /**
    Sets String in UserDefault against respective key.
    
    @param value String value that needs to saved in userDefaults.
    @param key String key against the value.
    @returns nil
    */
    func setStringForKey(value:String,key:String) {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    /**
     Returns String Value against passed key.
     
     @param key String key against the value.
     @returns String
     */
    func getStringForKey(key:String)->String? {
        return NSUserDefaults.standardUserDefaults().stringForKey(key)
    }
    
    /**
     Sets Integer in UserDefault against respective key.
     
     @param value Int value that needs to saved in userDefaults.
     @param key String key against the value.
     @returns nil
     */
    func setIntForKey(value:Int,key:String) {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    /**
     Returns Int Value against passed key.
     
     @param key String key against the value.
     @returns Int
     */
    func getIntForKey(key:String)->Int? {
        return NSUserDefaults.standardUserDefaults().integerForKey(key)
    }
    
    /**
     Sets Bool in UserDefault against respective key.
     
     @param value bool value that needs to saved in userDefaults.
     @param key String key against the value.
     @returns nil
     */
    func setBoolForKey(value:Bool,key:String) {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    /**
     Returns Bool Value against passed key.
     
     @param key String key against the value.
     @returns Bool
     */
    func getBoolForKey(key:String)->Bool? {
        return NSUserDefaults.standardUserDefaults().boolForKey(key)
    }
    
    /**
     Sets Anyobject in UserDefault against respective key.
     
     @param value anyObject value that needs to saved in userDefaults.
     @param key String key against the value.
     @returns nil
     */
    func setObjectForKey(userData:AnyObject?,key:String) {
        NSUserDefaults.standardUserDefaults().setObject(userData, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    /**
     Returns AnyObject against passed key.
     
     @param key String key against the value.
     @returns String
     */
    func getObjectForKey(key:String) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(key)!
    }
    
    /**
     Sets bottom border of text field.
     @param textField UITextField
     */
    func setTextFieldBottomBorder(textField:UITextField,borderColor:UIColor) {
        let bottomBorderLayer = CALayer()
        bottomBorderLayer.frame = CGRectMake(0, textField.frame.height - 1, textField.frame.width, 1.0)
        bottomBorderLayer.backgroundColor = borderColor.CGColor
        textField.layer.addSublayer(bottomBorderLayer)
    }
    
    /**
     Sets bottom border of view.
     @param view UIView
     */
    func setViewBottomBorder(view:UIView,borderColor:UIColor) {
        let bottomBorderLayer = CALayer()
        bottomBorderLayer.frame = CGRectMake(0, view.frame.height - 1, view.frame.width, 1.0)
        bottomBorderLayer.backgroundColor = borderColor.CGColor
        view.layer.addSublayer(bottomBorderLayer)
    }
    
    /**
     Sets Top border of view.
     @param view UIView
     */
    func setViewTopBorder(view:UIView,borderColor:UIColor) {
        let topBorderLayer = CALayer()
        topBorderLayer.frame = CGRectMake(0, 0, view.frame.width, 1.0)
        topBorderLayer.backgroundColor = borderColor.CGColor
        view.layer.addSublayer(topBorderLayer)
    }
    
    func setViewRightBorder(view:UIView,borderColor:UIColor) {
        let rightBorderLayer = CALayer()
        rightBorderLayer.frame = CGRectMake(70, 0, 1, 70)
        rightBorderLayer.backgroundColor = borderColor.CGColor
        view.layer.addSublayer(rightBorderLayer)
    }

    /**
     Returns bool , email is valid or not.
     @param email String
     returns bool
     */
    func isValidEmail(email:String) -> Bool {        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluateWithObject(email)
    }
    
    /**
     Returns bool , bitcoin address is valid or not.
     @param address String
     returns bool
     */
    func isValidBitcoinAddress(address:String) -> Bool {
        let bitcoinAddressRegEx = "^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$"
        let addressPredicate = NSPredicate(format:"SELF MATCHES %@", bitcoinAddressRegEx)
        return addressPredicate.evaluateWithObject(address)
    }
    
    
    //MARK: Check Reachablity
    
    /**
    Returns true if network is available else false.
    @returns Bool
    */
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags.ConnectionAutomatic
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

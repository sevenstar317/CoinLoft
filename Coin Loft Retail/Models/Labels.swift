//
//  Labels.swift
//  Coin Loft Retail
//
//  Created by Apple on 12/08/2016.
//  Copyright © 2016 Coin Loft. All rights reserved.
//

import UIKit

class Labels: NSObject {
    
    var lbl1: String?
    var lbl2 : String?
    var lbl3: String?
    var lbl4 : String?
    var lbl5 : String?
    var lbl6 : String?
    var lbl7 : String?
    var lbl8 : String?
    var lbl9 : String?
    var lbl10 :String?
    var lbl11: String?
    var lbl12 : String?
    var lbl13: String?
    var lbl14 : String?
    var lbl15 : String?
    var lbl16 : String?
    var lbl17 : String?
    var lbl18 : String?
    var lbl19 : String?
    var lbl20 :String?
    var lbl21: String?
    var lbl22 : String?
    var lbl23: String?
    var lbl24 : String?
    var lbl25 : String?
    var lbl26 : String?
    var lbl27 : String?
    var lbl28 : String?
    var lbl29 : String?
    var lbl30 :String?
    var lbl31: String?
    var lbl32 : String?
    var lbl33: String?
    var lbl34 : String?
    var lbl35 : String?
    var lbl36 : String?
    var lbl37 : String?
    var lbl38 : String?
    var lbl39 : String?
    var lbl40 :String?
    var lbl41 :String?
    var lbl42 :String?
    var lbl43 :String?
    var lbl44 :String?
    var lbl45 :String?
    var lbl46 :String?
    var lbl47 :String?
    var lbl48 :String?
    
    var lbl99 :String?
    var err1 :String?
    var err2 :String?
    var err180 :String?
    
    class var sharedInstance : Labels {
        struct singleton {
            static let instance = Labels()
        }
        return singleton.instance
    }
    
    func populateLabels(data:AnyObject) {
        
        let labels = (data["labels"] as? [String:AnyObject]) ?? [:]
        lbl1 = (labels["label.00001"] as? String) ?? "BITCOIN"
        lbl2 = (labels["label.00002"] as? String) ?? "ETHEREUM"
        lbl3 = (labels["label.00003"] as? String) ?? "Sell digital currencies"
        lbl4 = (labels["label.00004"] as? String) ?? "Enter the customer’s mobile number"
        lbl5 = (labels["label.00005"] as? String) ?? "A 4 digit security code will be sent to the customer"
        lbl6 = "  \((labels["label.00006"] as? String) ?? "Submit")"
        lbl7 = "  \((labels["label.00007"] as? String) ?? "Cancel")"
        lbl8 = (labels["label.00008"] as? String) ?? "Please enter a valid Australian mobile phone number"
        lbl9 = (labels["label.00009"] as? String) ?? "Enter 4 digit security code"
        lbl10 = (labels["label.00010"] as? String) ?? "Digit code must contain 4 digits"
        lbl11 = (labels["label.00011"] as? String) ?? "Customer should have received SMS with 4 digit code"
        lbl12 = (labels["label.00012"] as? String) ?? "Resend 4 digit code"
        lbl13 = (labels["label.00013"] as? String) ?? "Enter dollar amount"
        lbl14 = (labels["label.00014"] as? String) ?? "Enter amount between $transMinValue and $transMaxValue"
        lbl15 = (labels["label.00015"] as? String) ?? "Scan wallet address"
        lbl16 = (labels["label.00016"] as? String) ?? "Order confirmation"
        lbl17 = (labels["label.00017"] as? String) ?? "Please collect payment from the customer"
        lbl18 = (labels["label.00018"] as? String) ?? "OK"
        lbl19 = (labels["label.00019"] as? String) ?? "PIN code must contain 4 digits"
//        lbl20 = (labels["label.00020"] as? String) ?? "Enter dollar amount"
        lbl21 = (labels["label.00021"] as? String) ?? "Enter your merchant PIN code to confirm the order"
        lbl22 = (labels["label.00022"] as? String) ?? "Sale is complete"
        lbl23 = (labels["label.00023"] as? String) ?? "Digital currency will be delivered to the customer's address soon"
        lbl24 = (labels["label.00024"] as? String) ?? "Customer will receive an SMS once it has been completed"
        lbl25 = (labels["label.00025"] as? String) ?? "Start New Transaction"
        lbl26 = (labels["label.00026"] as? String) ?? "Settings"
        lbl27 = (labels["label.00027"] as? String) ?? "Mobile phone number is required"
        lbl28 = (labels["label.00028"] as? String) ?? "Digit code is required"
        lbl29 = (labels["label.00029"] as? String) ?? "Please enter amount in AUD $"
        lbl30 = (labels["label.00030"] as? String) ?? "New code was successfully sent"
        lbl31 = (labels["label.00031"] as? String) ?? "Wallet address is required"
        lbl32 = (labels["label.00032"] as? String) ?? "Wallet address is incorrect"
        lbl33 = (labels["label.00033"] as? String) ?? "Please enter you merchant PIN code"
        lbl34 = (labels["label.00034"] as? String) ?? "Please login"
        lbl35 = (labels["label.00035"] as? String) ?? "Merchant code"
        lbl36 = (labels["label.00036"] as? String) ?? "Merchant Password"
        lbl37 = (labels["label.00037"] as? String) ?? "Login"
        lbl38 = (labels["label.00038"] as? String) ?? "Invalid merchant code or password"
        lbl39 = (labels["label.00039"] as? String) ?? "Security code confirm must be equal to security code"
        lbl40 = (labels["label.00040"] as? String) ?? "Set Merchant Security Code (4 digits)"
        lbl41 = (labels["label.00041"] as? String) ?? "Enter Security Code again to confirm"
        lbl42 = (labels["label.00042"] as? String) ?? "Save"
        lbl43 = (labels["label.00043"] as? String) ?? "Confirm"
        lbl44 = (labels["label.00044"] as? String) ?? "Address"
        lbl45 = (labels["label.00045"] as? String) ?? "Security code is incorrect"
        lbl46 = (labels["label.00046"] as? String) ?? "Logout"
        lbl47 = (labels["label.00047"] as? String) ?? "Sell"
        lbl48 = (labels["label.00048"] as? String) ?? "You are logged in as"
        
        lbl99 = (labels["label.00099"] as? String) ?? "xxx"

        
        let errors = (data["errors"] as? [String:AnyObject]) ?? [:]
        err1 = (errors["0"] as? String) ?? "Success"
        err2 = (errors["1"] as? String) ?? "Order can not be found"
        err180 = (errors["180"] as? String) ?? "Please enter security code that has been sent to customer via SMS"
        
    }
}

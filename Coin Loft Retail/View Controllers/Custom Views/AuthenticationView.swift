//
//  AuthenticationView.swift
//  Coin Loft Retail
//
//  Created by Apple on 12/08/2016.
//  Copyright © 2016 Coin Loft. All rights reserved.
//

import UIKit
import LocalAuthentication

protocol AuthenticationViewDelegate:NSObjectProtocol {
    func onAuthenticationViewOkayTapped(isTouchIDMatched:Bool)
    func onAuthenticationViewCrossTapped()
}

class AuthenticationView: UIView {
    
    @IBOutlet weak var textFieldMerchantPin: UITextField!
    var delegate: AuthenticationViewDelegate?
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        textFieldMerchantPin.keyboardType = UIKeyboardType.NumberPad
        self.addDoneButton(textFieldMerchantPin)
    }
    
    @IBAction func btnTouchIDTap(sender: AnyObject) {
        
        if Utilities.sharedInstance.getBoolForKey(MERCHANT_FINGER_PRINT) == true {
            let context = LAContext()
            if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error:nil) {
                context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
                                       localizedReason: "Logging in with Touch ID",
                                       reply: { (success : Bool, error : NSError? ) -> Void in
                                        
                                        dispatch_async(dispatch_get_main_queue(), {
                                            if success {
                                                if self.delegate != nil {
                                                    self.delegate?.onAuthenticationViewOkayTapped(true)
                                                }
                                            }
                                            
                                            if error != nil {
                                                
                                                var message : NSString
                                                
                                                switch(error!.code) {
                                                case LAError.AuthenticationFailed.rawValue:
                                                    message = "There was a problem verifying your identity."
                                                    break;
                                                case LAError.UserCancel.rawValue:
                                                    message = "You pressed cancel."
                                                    break;
                                                case LAError.UserFallback.rawValue:
                                                    message = "You pressed password."
                                                    break;
                                                default:
                                                    message = "Touch ID may not be configured"
                                                    break;
                                                }
                                                
                                                let alert = UIAlertView(title: "Error", message: message as String, delegate: nil, cancelButtonTitle: "Okay")
                                                alert.show()
                                                
                                            }
                                        })
                                        
                })
            } else {
                
                let alert = UIAlertView(title: "Error", message: "Touch ID not available", delegate: nil, cancelButtonTitle: "Okay")
                alert.show()
                
            }
        }
        
    }
    
    
    @IBAction func onBtnCrossTap(sender: AnyObject) {
        if self.delegate != nil {
            self.delegate?.onAuthenticationViewCrossTapped()
        }
    }
    
    @IBAction func onOKBtnTap(sender: AnyObject) {
        if self.delegate != nil {
            self.delegate?.onAuthenticationViewOkayTapped(false)
        }
    }
    
    func addDoneButton(target:UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
                                            target: self, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        target.inputAccessoryView = keyboardToolbar
    }
}


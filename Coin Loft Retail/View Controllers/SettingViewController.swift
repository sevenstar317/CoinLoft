//
//  SettingViewController.swift
//  Coin Loft Retail
//
//  Created by Apple on 10/08/2016.
//  Copyright © 2016 Coin Loft. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, ErrorViewDelegate {

    @IBOutlet weak var lblMerchantCode: UILabel!
    @IBOutlet weak var lblMerchantPasword: UILabel!
    @IBOutlet weak var lblSecurityCode: UILabel!
    @IBOutlet weak var lblConfirmSecurityCode: UILabel!
    
    @IBOutlet weak var textFieldMerchantCode: UITextField!
    @IBOutlet weak var textFieldMerchantPassword: UITextField!
    @IBOutlet weak var textFieldMerchantSecurityCode: UITextField!
    @IBOutlet weak var textFieldConfirmCode: UITextField!
    @IBOutlet weak var switchFingerPrint: UISwitch!
    
    
    @IBOutlet weak var constraintBackBtnTop: NSLayoutConstraint!
    @IBOutlet weak var constraintSettingLabelTop: NSLayoutConstraint!
    @IBOutlet weak var constraintFirstLabelTop: NSLayoutConstraint!
    
    var errorView : ErrorView!
    var serviceStatus : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblMerchantCode.text = Labels.sharedInstance.lbl35!
        lblMerchantPasword.text = Labels.sharedInstance.lbl36!
        lblSecurityCode.text = Labels.sharedInstance.lbl40!
        lblConfirmSecurityCode.text = Labels.sharedInstance.lbl41!
        
        self.textFieldMerchantCode.layer.cornerRadius = 5.0
        self.textFieldMerchantPassword.layer.cornerRadius = 5.0
        self.textFieldMerchantSecurityCode.layer.cornerRadius = 5.0
        self.textFieldConfirmCode.layer.cornerRadius = 5.0
        
        if Utilities.sharedInstance.getStringForKey(MERCHANT_CODE) != nil {
            self.textFieldMerchantCode.text = Utilities.sharedInstance.getStringForKey(MERCHANT_CODE)!
            self.textFieldMerchantPassword.text = Utilities.sharedInstance.getStringForKey(MERCHANT_PASSWORD)!
            self.textFieldMerchantSecurityCode.text = Utilities.sharedInstance.getStringForKey(MERCHANT_SECURITY_CODE)!
            self.textFieldConfirmCode.text = Utilities.sharedInstance.getStringForKey(MERCHANT_SECURITY_CODE)!
        }

    }
    
    override func viewDidLayoutSubviews() {
        if IS_IPHONE4 {
            constraintBackBtnTop.constant = 20.0
            constraintSettingLabelTop.constant = 30.0
            constraintFirstLabelTop.constant = 5.0
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func onBtnBackTap(sender: AnyObject) {
        
        if textFieldMerchantCode.text?.characters.count > 0 &&
            textFieldMerchantPassword.text?.characters.count > 0 &&
            textFieldMerchantSecurityCode.text?.characters.count > 0 &&
            textFieldConfirmCode.text?.characters.count > 0 {
            
            if textFieldMerchantSecurityCode.text?.characters.count == 4 {
                
                if textFieldMerchantSecurityCode.text! == textFieldConfirmCode.text! {
                    Utilities.sharedInstance.setStringForKey(textFieldMerchantCode.text!, key: MERCHANT_CODE)
                    Utilities.sharedInstance.setStringForKey(textFieldMerchantPassword.text!, key: MERCHANT_PASSWORD)
                    Utilities.sharedInstance.setStringForKey(textFieldMerchantSecurityCode.text!, key: MERCHANT_SECURITY_CODE)
                    Utilities.sharedInstance.setBoolForKey(switchFingerPrint.on, key: MERCHANT_FINGER_PRINT)
                    Utilities.sharedInstance.setBoolForKey(true, key: MERCHANT_REGISTERED)
                    
                    self.authenticateMerchant()
                } else {
                    self.showError(Labels.sharedInstance.lbl39)
                }
                
            } else {
                self.showError("4 digit Security Code required")
            }
            
        } else {
            
        }
        
    }
    
    func authenticateMerchant() {
        
        Utilities.sharedInstance.setStringForKey(textFieldMerchantPassword.text!, key: MERCHANT_PASSWORD)
        let secret = Utilities.sharedInstance.getStringForKey(MERCHANT_PASSWORD)
        var nonce = String(NSDate().timeIntervalSince1970)
        nonce = nonce.stringByReplacingOccurrencesOfString(".", withString: "")
        Utilities.sharedInstance.setStringForKey(nonce, key: NONCE)
        let payload : String = "GET\n\(URL_STATUS)\n\(nonce)\n"
        print(payload)
        let hash = payload.hmac(CryptoAlgorithm.SHA256, key: secret!)
        Utilities.sharedInstance.setStringForKey(hash, key: HASH)
        
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
        NetworkManager.sharedNetworkClient().processGetRequestWithPath(URL_STATUS,
           parameter: nil,
           success: { (status:Int32, processedData:AnyObject!) in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                SVProgressHUD.dismiss()
                print(processedData)
                let statusObject = processedData["status"] as! [String:AnyObject]
                let status = statusObject["status"] as! String
                if status == "OK" {
                    self.serviceStatus = true
                    Utilities.sharedInstance.setBoolForKey(true, key: SERVICE_STATUS)
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    self.serviceStatus = false
                    Utilities.sharedInstance.setBoolForKey(false, key: SERVICE_STATUS)
                    self.showError("Please Authenticate will correct credentials.")
            }
        
        }) { (status:Int32,msg:String!, error:NSError!) in
            SVProgressHUD.dismiss()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.showError(msg)
            print("Error")
        }
    }
    
    
    
    func showError(errorMsg:String!) {
        var nibArray : [AnyObject] =  NSBundle.mainBundle().loadNibNamed("ErrorView", owner: self, options: nil)
        errorView = nibArray[0] as! ErrorView
        errorView.frame = UIScreen.mainScreen().bounds
        errorView.delegate = self
        errorView.errorlabel.text = errorMsg
        self.view.bringSubviewToFront(errorView)
        self.view.addSubview(errorView)
    }
    
    // MARK: - ErrorViewDelegate Methods
    func onOkayTapped() {
        errorView.removeFromSuperview()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

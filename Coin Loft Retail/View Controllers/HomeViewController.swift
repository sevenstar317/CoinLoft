//
//  HomeViewController.swift
//  Coin Loft Retail
//
//  Created by Apple on 09/08/2016.
//  Copyright © 2016 Coin Loft. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ErrorViewDelegate, AuthenticationViewDelegate {

    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnBitcoin: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnEthereum: UIButton!
    
    var errorView:ErrorView!
    var authenticationView:AuthenticationView!
    var serviceStatus = false
    var comment : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setSettingBtnAttributedString("Settings")
        self.getUXData()
        
//        var nonce = String(NSDate().timeIntervalSince1970)
//        nonce = nonce.stringByReplacingOccurrencesOfString(".", withString: "")
////        let json = "{\"mobileOTP\":true,\"mobile\":\"474778450\"}"
//        let secret : String = "jRZmut6I"
//        let key : String = "GET\n/status\n\(nonce)\n"
//        print(key)
//        print(key.hmac(CryptoAlgorithm.SHA256, key: secret))
//        print("hash")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.serviceStatus = Utilities.sharedInstance.getBoolForKey(SERVICE_STATUS)!
    }
    
    func setSettingBtnAttributedString(str:String) {
        let dottedString : NSMutableAttributedString = NSMutableAttributedString(string: str)
        let dashed =  NSUnderlineStyle.PatternDot.rawValue | NSUnderlineStyle.StyleSingle.rawValue
        dottedString.addAttribute(NSUnderlineStyleAttributeName, value: dashed, range: NSMakeRange(0, dottedString.length))
        dottedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(rgba: "#407709"), range: NSMakeRange(0, dottedString.length))
        self.btnSetting.setAttributedTitle(dottedString, forState: .Normal)
    }
    
    
    // MARK: - Web Services
    
    // Fetch UXData for dynamic labeling
    func getUXData() {
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
        NetworkManager.sharedNetworkClient().processUXDataRequestWithPath(URL_UXDATA,
           parameter: nil,
           success: { (status:Int32, processedData:AnyObject!) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            Labels.sharedInstance.populateLabels(processedData)
            self.lblInfo.text = Labels.sharedInstance.lbl3!
            self.btnBitcoin.setTitle(Labels.sharedInstance.lbl1!, forState: UIControlState.Normal)
            self.btnEthereum.setTitle(Labels.sharedInstance.lbl2!, forState: UIControlState.Normal)
            self.setSettingBtnAttributedString(Labels.sharedInstance.lbl26!)
            self.getStatus()
        
        }) { (status:Int32,msg:String!, error:NSError!) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            self.serviceStatus = false
            Labels.sharedInstance.populateLabels([])
            self.comment = msg
        }
    }
    
    // Fetch status of the service
    func getStatus() {
        
        let secret = Utilities.sharedInstance.getStringForKey(MERCHANT_PASSWORD)
        
        if secret != nil {
            var nonce = String(NSDate().timeIntervalSince1970)
            nonce = nonce.stringByReplacingOccurrencesOfString(".", withString: "")
            Utilities.sharedInstance.setStringForKey(nonce, key: NONCE)
            let payload : String = "GET\n\(URL_STATUS)\n\(nonce)\n"
            print(payload)
            let hash = payload.hmac(CryptoAlgorithm.SHA256, key: secret!)
            Utilities.sharedInstance.setStringForKey(hash, key: HASH)
        }
        
        NetworkManager.sharedNetworkClient().processGetRequestWithPath(URL_STATUS,
        parameter: nil,
        success: { (status:Int32, processedData:AnyObject!) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            print(processedData)
            let statusObject = processedData["status"] as! [String:AnyObject]
            let status = statusObject["status"] as! String
            let comment = statusObject["comment"] as! String
            if status == "OK" {
                self.serviceStatus = true
                self.comment = comment
            } else {
                self.serviceStatus = false
                self.comment = comment
            }
                                                                        
        }) { (status:Int32,msg:String!, error:NSError!) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            self.serviceStatus = false
            self.comment = msg
//            if self.comment == "invalid nonce" {
//                
//            }
            self.showError(msg)
        }
    
    }
    
    
    // MARK: - Event Methods
    @IBAction func onBtnBuyBitcoinTap(sender: AnyObject) {
        if serviceStatus {
            Utilities.sharedInstance.setStringForKey(CURRENCY_BTC, key: CURRENCY_TYPE)
            self.performSegueWithIdentifier("MobileNumberSegue", sender: self)
        } else {
            if self.comment != nil {
                self.showError(self.comment!)
            } else {
                self.showError("An Error Occurred. Try again")
            }
        }
    }
    
    @IBAction func onBtnBuyEthereumTap(sender: AnyObject) {
        if serviceStatus {
            Utilities.sharedInstance.setStringForKey(CURRENCY_ETH, key: CURRENCY_TYPE)
            self.performSegueWithIdentifier("MobileNumberSegue", sender: self)
        } else {
            if self.comment != nil {
                self.showError(self.comment!)
            } else {
                self.showError("An Error Occurred. Try again")
            }
        }
    }
    
    @IBAction func onBtnSetttingTap(sender: AnyObject) {
        
        if Utilities.sharedInstance.getBoolForKey(MERCHANT_REGISTERED) == false {
            self.performSegueWithIdentifier("SettingSegue", sender: self)
        } else {
            var nibArray : [AnyObject] =  NSBundle.mainBundle().loadNibNamed("AuthenticationView", owner: self, options: nil)
            authenticationView = nibArray[0] as! AuthenticationView
            authenticationView.frame = UIScreen.mainScreen().bounds
            authenticationView.delegate = self
            self.view.bringSubviewToFront(authenticationView)
            self.view.addSubview(authenticationView)
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

    // MARK: - AuthenthicateViewDelegate Methods
    func onAuthenticationViewOkayTapped(isTouchIDMatched: Bool) {
        if isTouchIDMatched == true ||
            self.authenticationView.textFieldMerchantPin.text! == Utilities.sharedInstance.getStringForKey(MERCHANT_SECURITY_CODE) {
            authenticationView.removeFromSuperview()
            self.performSegueWithIdentifier("SettingSegue", sender: self)
        }
    }
    
    func onAuthenticationViewCrossTapped() {
        authenticationView.removeFromSuperview()
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

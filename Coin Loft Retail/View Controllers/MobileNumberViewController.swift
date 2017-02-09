//
//  MobileNumberViewController.swift
//  Coin Loft Retail
//
//  Created by Apple on 09/08/2016.
//  Copyright © 2016 Coin Loft. All rights reserved.
//

import UIKit

class MobileNumberViewController: UIViewController,ErrorViewDelegate {

    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var lblCustomerNum: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var constraintLogoTop: NSLayoutConstraint!
    @IBOutlet weak var constraintTopLabelTop: NSLayoutConstraint!
    @IBOutlet weak var constraintTextFieldTop: NSLayoutConstraint!
    @IBOutlet weak var constraintSubmitTop: NSLayoutConstraint!
    
    var errorView:ErrorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblCustomerNum.text = Labels.sharedInstance.lbl4!
        lblInfo.text = Labels.sharedInstance.lbl5!
        lblError.text = Labels.sharedInstance.lbl8!
        btnSubmit.setTitle(Labels.sharedInstance.lbl6, forState: UIControlState.Normal)
        btnCancel.setTitle(Labels.sharedInstance.lbl7, forState: UIControlState.Normal)
        
        textFieldPhoneNumber.keyboardType = UIKeyboardType.PhonePad
        textFieldPhoneNumber.layer.cornerRadius = 5.0
        self.addDoneButton(textFieldPhoneNumber)
    }
    
    override func viewDidLayoutSubviews() {
        if IS_IPHONE4 {
            constraintLogoTop.constant = 10.0
            constraintTopLabelTop.constant = 5.0
            constraintTextFieldTop.constant = 5.0
            constraintSubmitTop.constant = 5.0
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func onBtnSubmitTap(sender: AnyObject) {
        
        if textFieldPhoneNumber.text?.characters.count == 10 {
            self.lblError.hidden = true
            SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
            
            let params : [String: AnyObject] = ["mobileOTP":true,
                                                "mobile":textFieldPhoneNumber.text!]
        
            let number : String = "\"\(textFieldPhoneNumber.text!)\""
            let json = "{\"mobile\":\(number),\"mobileOTP\":true}"
            
            let secret = Utilities.sharedInstance.getStringForKey(MERCHANT_PASSWORD)
            var nonce = String(NSDate().timeIntervalSince1970)
            nonce = nonce.stringByReplacingOccurrencesOfString(".", withString: "")
            Utilities.sharedInstance.setStringForKey(nonce, key: NONCE)
            let payload : String = "POST\n\(URL_VALIDATE_CUSTOMER_PHONE)\n\(nonce)\n\(json)"
            print(payload)
            let hash = payload.hmac(CryptoAlgorithm.SHA256, key: secret!)
            print(hash)
            Utilities.sharedInstance.setStringForKey(hash, key: HASH)
            
            NetworkManager.sharedNetworkClient().processPostRequestWithPath(URL_VALIDATE_CUSTOMER_PHONE,
                parameter: params,
                success: { (status:Int32, processedData:AnyObject!) in
                    SVProgressHUD.dismiss()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    let code = processedData["code"] as! Int
                    if code == 0 {
                        Customer.sharedInstance.populateCustomer(processedData)
                        self.performSegueWithIdentifier("SecurityCodeSegue", sender: self)
                    } else {
                        self.showError("An Error Occurred. Try again")
                    }
                    
                }, failure: { (status:Int32,msg:String!, error:NSError!) in
                    SVProgressHUD.dismiss()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    if status == 180 {
                        self.performSegueWithIdentifier("SecurityCodeSegue", sender: self)
                    } else {
                        self.showError(msg)
                        print("error")
                    }
            })
        } else {
            self.lblError.hidden = false
        }
        
    }
    
    @IBAction func onBtnCancelTap(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Utility methods
    func showError(errorMsg:String!) {
        var nibArray : [AnyObject] =  NSBundle.mainBundle().loadNibNamed("ErrorView", owner: self, options: nil)
        errorView = nibArray[0] as! ErrorView
        errorView.frame = UIScreen.mainScreen().bounds
        errorView.delegate = self
        errorView.errorlabel.text = errorMsg
        self.view.bringSubviewToFront(errorView)
        self.view.addSubview(errorView)
    }
    
    func addDoneButton(target:UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        target.inputAccessoryView = keyboardToolbar
    }
    
    // MARK: - ErrorViewDelegate Methods
    func onOkayTapped() {
        errorView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SecurityCodeSegue" {
            let destinationVC = segue.destinationViewController as! SecurityCodeViewController
            destinationVC.userMobileNumber = textFieldPhoneNumber.text!
            self.textFieldPhoneNumber.text = ""
        }
    }
 

}

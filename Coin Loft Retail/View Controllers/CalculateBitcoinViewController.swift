//
//  CalculateBitcoinViewController.swift
//  Coin Loft Retail
//
//  Created by Apple on 10/08/2016.
//  Copyright © 2016 Coin Loft. All rights reserved.
//

import UIKit

class CalculateBitcoinViewController: UIViewController,ErrorViewDelegate, UITextFieldDelegate,QRCodeReaderDelegate {

    @IBOutlet weak var lblAmountInfo: UILabel!
    @IBOutlet weak var lblScanInfo: UILabel!
    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var lblBitcoinValue: UILabel!
    @IBOutlet weak var lblWalletAddress: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var constraintLogoTop: NSLayoutConstraint!
    @IBOutlet weak var constraintTopLabelTop: NSLayoutConstraint!
    @IBOutlet weak var constraintAmountViewTop: NSLayoutConstraint!
    @IBOutlet weak var constraintAmountViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintTextFieldTop: NSLayoutConstraint!
    
    var errorView : ErrorView!
    var userMobileNumber:String!
    var virtualCurrency : Float!
    var orderID:String!
    
    var transMinValue = 0
    var transMaxValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.lblAmountInfo.text = Labels.sharedInstance.lbl29!
        self.lblScanInfo.text = Labels.sharedInstance.lbl15!
        self.btnSubmit.setTitle(Labels.sharedInstance.lbl6, forState: UIControlState.Normal)
        self.btnCancel.setTitle(Labels.sharedInstance.lbl7, forState: UIControlState.Normal)
        
        self.textFieldAmount.keyboardType = UIKeyboardType.NumberPad
        self.textFieldAmount.layer.cornerRadius = 5.0
        self.textFieldAmount.layer.borderWidth = 2.0
        self.textFieldAmount.layer.borderColor = UIColor(rgba: "#cccccc").CGColor
        self.textFieldAmount.delegate = self
        
        transMinValue = Int(Customer.sharedInstance.transMinValue)!
        transMaxValue = Int(Customer.sharedInstance.transMaxValue)!
        self.textFieldAmount.placeholder = "Limited between $\(transMinValue) and $\(transMaxValue)"
        self.lblError.text = "Allowed Value betweeen $\(transMinValue) and $\(transMaxValue)"
        
        if Utilities.sharedInstance.getStringForKey(CURRENCY_TYPE) == CURRENCY_BTC {
            lblBitcoinValue.text = "=0.00 BTC"
        } else if Utilities.sharedInstance.getStringForKey(CURRENCY_TYPE) == CURRENCY_ETH {
            lblBitcoinValue.text = "=0.00 ETH"
        }
        
        self.addDoneButton(self.textFieldAmount)
        self.getRates()
        
    }
    
    override func viewDidLayoutSubviews() {
        if IS_IPHONE4 {
            constraintLogoTop.constant = 5.0
            constraintTopLabelTop.constant = 0.0
            constraintAmountViewTop.constant = 0.0
            constraintAmountViewHeight.constant = 100.0
            constraintTextFieldTop.constant = 5.0
        }
    }
    
    func getRates() {
        
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
        
        let secret = Utilities.sharedInstance.getStringForKey(MERCHANT_PASSWORD)
        var nonce = String(NSDate().timeIntervalSince1970)
        nonce = nonce.stringByReplacingOccurrencesOfString(".", withString: "")
        Utilities.sharedInstance.setStringForKey(nonce, key: NONCE)
        let payload : String = "GET\n\(URL_RATES)\n\(nonce)\n"
        print(payload)
        let hash = payload.hmac(CryptoAlgorithm.SHA256, key: secret!)
        Utilities.sharedInstance.setStringForKey(hash, key: HASH)
        
        NetworkManager.sharedNetworkClient().processGetRequestWithPath(URL_RATES,
            parameter: nil,
            success: { (status:Int32, processedData:AnyObject!) in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                SVProgressHUD.dismiss()
                Rates.sharedInstance.populateRates(processedData)
                                                                        
        }) { (status:Int32,msg:String!, error:NSError!) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
            self.showError(msg)
            print("Error")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Events
    @IBAction func onBtnScanQRCodeTap(sender: AnyObject) {
        // Create the reader object
        let reader : QRCodeReader =  QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
        
        // Instantiate the view controller
        let readerVC : QRCodeReaderViewController = QRCodeReaderViewController(cancelButtonTitle: "Cancel",
                                                                               codeReader: reader,
                                                                               startScanningAtLoad: true,
                                                                               showSwitchCameraButton: true,
                                                                               showTorchButton: true)
        
        // Set the presentation style
        readerVC.modalPresentationStyle = UIModalPresentationStyle.FormSheet;
        
        // Define the delegate receiver
        readerVC.delegate = self;
        
        self.presentViewController(readerVC, animated: true, completion: nil)
    }
    
    @IBAction func onBtnSubmitTap(sender: AnyObject) {
        
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
        
        var URL = ""
        
        if Utilities.sharedInstance.getStringForKey(CURRENCY_TYPE) == CURRENCY_BTC {
            URL = "\(URL_QUOTE)/AUD/\(CURRENCY_BTC)/\(textFieldAmount.text!)"
        } else {
            URL = "\(URL_QUOTE)/AUD/\(CURRENCY_ETH)/\(textFieldAmount.text!)"
        }
        
        let secret = Utilities.sharedInstance.getStringForKey(MERCHANT_PASSWORD)
        var nonce = String(NSDate().timeIntervalSince1970)
        nonce = nonce.stringByReplacingOccurrencesOfString(".", withString: "")
        Utilities.sharedInstance.setStringForKey(nonce, key: NONCE)
        let payload : String = "GET\n\(URL)\n\(nonce)\n"
        print(payload)
        let hash = payload.hmac(CryptoAlgorithm.SHA256, key: secret!)
        Utilities.sharedInstance.setStringForKey(hash, key: HASH)
        
        NetworkManager.sharedNetworkClient().processGetRequestWithPath(URL,
            parameter: nil,
            success: { (status:Int32, processedData:AnyObject!) in
                let code = processedData["code"] as! Int
                if code == 0 {
                    let quote = processedData["quote"] as! [String:AnyObject]
                    let quoteID = quote["id"] as! String
                    self.placeOrder(quoteID, walletAddress: self.lblWalletAddress.text!)
                } else {
                    self.showError("An Error Occurred. Try again")
                }
                
            }, failure: { (status:Int32,msg:String!, error:NSError!) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                SVProgressHUD.dismiss()
                self.showError(msg)
                print("error")
        })
    }
    
    func placeOrder(quoteId:String, walletAddress:String) {
            
        let params : [String: AnyObject] = ["quoteId": quoteId,
                                            "customerMobile":userMobileNumber,
                                            "walletAddress":walletAddress]
        
//        params = ["quoteId": quoteId,
//                  "customerMobile":userMobileNumber,
//                  "walletAddress":"18Vm8AvDr9Bkvij6UfVR7MerCyrz3KS3h4"]
        
        let id : String = "\"\(quoteId)\""
        let number : String = "\"\(userMobileNumber)\""
        let address : String = "\"\(walletAddress)\""
        let json = "{\"quoteId\":\(id),\"customerMobile\":\(number),\"walletAddress\":\(address)}"
        
        let secret = Utilities.sharedInstance.getStringForKey(MERCHANT_PASSWORD)
        var nonce = String(NSDate().timeIntervalSince1970)
        nonce = nonce.stringByReplacingOccurrencesOfString(".", withString: "")
        Utilities.sharedInstance.setStringForKey(nonce, key: NONCE)
        let payload : String = "POST\n\(URL_ORDER)\n\(nonce)\n\(json)"
        print(payload)
        let hash = payload.hmac(CryptoAlgorithm.SHA256, key: secret!)
        print(hash)
        Utilities.sharedInstance.setStringForKey(hash, key: HASH)
        
        NetworkManager.sharedNetworkClient().processPostRequestWithPath(URL_ORDER,
            parameter: params,
            success: { (status:Int32, processedData:AnyObject!) in
                SVProgressHUD.dismiss()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let code = processedData["code"] as! Int
                if code == 0 {
                    let order = processedData["order"] as! [String:AnyObject]
                    self.orderID = order["id"] as! String
                    self.performSegueWithIdentifier("OrderConfirmationSegue", sender: self)
                } else {
                    self.showError("An Error Occurred. Try again")
                }
                
            }, failure: { (status:Int32,msg:String!, error:NSError!) in
                SVProgressHUD.dismiss()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.showError(msg)
                print("error")
        })
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
    
    //MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(textField: UITextField) {
        let amount = Int(textFieldAmount.text!)
        
        if amount < self.transMinValue || amount > self.transMaxValue {
            self.lblError.hidden = false
        } else {
            self.lblError.hidden = true
            
            if Utilities.sharedInstance.getStringForKey(CURRENCY_TYPE) == CURRENCY_BTC {
                virtualCurrency = Float(textFieldAmount.text!)! / Float(Rates.sharedInstance.BTCValue)!
                self.lblBitcoinValue.text = String(format: "=%.8f BTC",virtualCurrency)
            } else if Utilities.sharedInstance.getStringForKey(CURRENCY_TYPE) == CURRENCY_ETH {
                virtualCurrency = Float(textFieldAmount.text!)! / Float(Rates.sharedInstance.ETHValue)!
                self.lblBitcoinValue.text = String(format: "=%.8f ETH",virtualCurrency)
            }
        }
    }
    
    // MARK: - QRCodeReaderDelegate methods
    func readerDidCancel(reader: QRCodeReaderViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reader(reader: QRCodeReaderViewController!, didScanResult result: String!) {
        self.dismissViewControllerAnimated(true) { 
            print(result)
            
            if Utilities.sharedInstance.isValidBitcoinAddress(result) {
                self.lblWalletAddress.hidden = false
                self.lblWalletAddress.textColor = UIColor(rgba: "#9F9F9B")
                self.lblWalletAddress.text = result
            } else {
                self.lblWalletAddress.hidden = false
                self.lblWalletAddress.text = "Invalid Bitcoin Address"
                self.lblWalletAddress.textColor = UIColor.redColor()
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "OrderConfirmationSegue" {
            let destVC = segue.destinationViewController as! OrderConfirmationViewController
            destVC.amount = textFieldAmount.text!
            destVC.bitcoins = String(virtualCurrency)
            destVC.walletAddress = lblWalletAddress.text!
            destVC.orderID = self.orderID
        }
    }
 

}

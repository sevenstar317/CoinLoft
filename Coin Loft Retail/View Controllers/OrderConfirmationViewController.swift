//
//  OrderConfirmationViewController.swift
//  Coin Loft Retail
//
//  Created by Apple on 10/08/2016.
//  Copyright © 2016 Coin Loft. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController,PaymentViewDelegate,ErrorViewDelegate {

    @IBOutlet weak var lblOrderConfirmation: UILabel!
    @IBOutlet weak var lblAmountValue: UILabel!
    @IBOutlet weak var lblBTCValue: UILabel!
    @IBOutlet weak var lblWalletAddress: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var collectPaymentView : CollectPaymentView!
    
    @IBOutlet weak var constraintLogoTop: NSLayoutConstraint!
    @IBOutlet weak var constraintTopLabelTop: NSLayoutConstraint!
    @IBOutlet weak var constraintAmountViewTop: NSLayoutConstraint!
    @IBOutlet weak var constraintSubmitTop: NSLayoutConstraint!
    
    var amount : String!
    var bitcoins : String!
    var walletAddress : String!
    var orderID: String!
    var errorView:ErrorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblOrderConfirmation.text = Labels.sharedInstance.lbl16
        btnCancel.setTitle(Labels.sharedInstance.lbl7!, forState: UIControlState.Normal)
        
        self.lblAmountValue.text = "$\(amount)"
        if Utilities.sharedInstance.getStringForKey(CURRENCY_TYPE) == CURRENCY_BTC {
            self.lblBTCValue.text = "=\(bitcoins) BTC"
        } else if Utilities.sharedInstance.getStringForKey(CURRENCY_TYPE) == CURRENCY_ETH {
            self.lblBTCValue.text = "=\(bitcoins) ETH"
        }
        
        self.lblWalletAddress.text = walletAddress
    }
    
    override func viewDidLayoutSubviews() {
        
        if IS_IPHONE4 {
            constraintLogoTop.constant = 10.0
            constraintTopLabelTop.constant = 5.0
            constraintAmountViewTop.constant = 0.0
            constraintSubmitTop.constant = 10.0
        }
    }

    @IBAction func onBtnConfirmTap(sender: AnyObject) {
        
        var nibArray : [AnyObject] =  NSBundle.mainBundle().loadNibNamed("CollectPaymentView", owner: self, options: nil)
        collectPaymentView = nibArray[0] as! CollectPaymentView
        collectPaymentView.frame = UIScreen.mainScreen().bounds
        collectPaymentView.delegate = self
        self.view.addSubview(collectPaymentView)
    }
    
    @IBAction func onBtnCancelTap(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - PaymentViewDelegate Methods
    
    func onPaymentViewCrossTapped() {
        collectPaymentView.removeFromSuperview()
    }
    
    func onPaymentViewOkayTapped(isTouchIDMatched: Bool) {
        
        if isTouchIDMatched == true ||
        collectPaymentView.textFieldMerchantPin.text! == Utilities.sharedInstance.getStringForKey(MERCHANT_SECURITY_CODE) {
            self.completePayment()
        }
    }
    
    func completePayment() {
        
        let params : [String: AnyObject] = ["orderId": orderID]
        
        let id : String = "\"\(orderID)\""
        let json = "{\"orderId\":\(id)}"
        
        let secret = Utilities.sharedInstance.getStringForKey(MERCHANT_PASSWORD)
        var nonce = String(NSDate().timeIntervalSince1970)
        nonce = nonce.stringByReplacingOccurrencesOfString(".", withString: "")
        Utilities.sharedInstance.setStringForKey(nonce, key: NONCE)
        let payload : String = "POST\n\(URL_PAYMENT)\n\(nonce)\n\(json)"
        print(payload)
        let hash = payload.hmac(CryptoAlgorithm.SHA256, key: secret!)
        print(hash)
        Utilities.sharedInstance.setStringForKey(hash, key: HASH)
        
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
        NetworkManager.sharedNetworkClient().processPostRequestWithPath(URL_PAYMENT,
            parameter: params,
            success: { (status:Int32, processedData:AnyObject!) in
                SVProgressHUD.dismiss()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let code = processedData["code"] as! Int
                if code == 0 {
                    self.collectPaymentView.removeFromSuperview()
                    let thankyouViewController = self.storyboard?.instantiateViewControllerWithIdentifier("thankYouVC") as! ThankyouViewController
                    self.navigationController?.pushViewController(thankyouViewController, animated: true)
                } else {
                    self.showError("An Error Occurred. Try again")
                }
                
            }, failure: { (status:Int32,msg:String!, error:NSError!) in
                SVProgressHUD.dismiss()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.showError(msg)
        })
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ThankyouViewController.swift
//  Coin Loft Retail
//
//  Created by Apple on 10/08/2016.
//  Copyright © 2016 Coin Loft. All rights reserved.
//

import UIKit

class ThankyouViewController: UIViewController {

    @IBOutlet weak var lblThankyou: UILabel!
    @IBOutlet weak var lblCurrencyDeliveredInfo: UILabel!
    @IBOutlet weak var lblReceiveSMSInfo: UILabel!
    @IBOutlet weak var btnNewTransaction: UIButton!
    @IBOutlet weak var constraintLogoTop: NSLayoutConstraint!
    @IBOutlet weak var constraintTextTopFieldTop: NSLayoutConstraint!
    @IBOutlet weak var constraintBtnTop: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblCurrencyDeliveredInfo.text = Labels.sharedInstance.lbl23!
        lblReceiveSMSInfo.text = Labels.sharedInstance.lbl24!
        btnNewTransaction.setTitle(Labels.sharedInstance.lbl25!, forState: UIControlState.Normal)
        self.btnNewTransaction.layer.cornerRadius = 5.0
    }
    @IBOutlet weak var constraintSecondLabelTop: NSLayoutConstraint!
    
    override func viewDidLayoutSubviews() {
        if IS_IPHONE4 {
            constraintLogoTop.constant = 5.0
            constraintTextTopFieldTop.constant = 5.0
            constraintSecondLabelTop.constant = 5.0
            constraintBtnTop.constant = 5.0
        }
    }

    @IBAction func onBtnNewTrasactionTap(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
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

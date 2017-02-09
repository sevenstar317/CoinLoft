//
//  ErrorView.swift
//  Coin Loft Retail
//
//  Created by Apple on 10/08/2016.
//  Copyright © 2016 Coin Loft. All rights reserved.
//

import UIKit

protocol ErrorViewDelegate:NSObjectProtocol {
    func onOkayTapped()
}

class ErrorView: UIView {
    
    @IBOutlet weak var btnOkay: UIButton!
    @IBOutlet weak var errorlabel: UILabel!
    var delegate: ErrorViewDelegate?
    
    override func layoutSubviews() {
        self.btnOkay.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
    }

    @IBAction func onBtnOkayTap(sender: AnyObject) {
        if delegate != nil {
            self.delegate?.onOkayTapped()
        }
    }
}

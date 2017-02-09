//
//  Rates.swift
//  Coin Loft Retail
//
//  Created by Apple on 11/08/2016.
//  Copyright © 2016 Coin Loft. All rights reserved.
//

import UIKit

class Rates: NSObject {
    
    var BTCValue:String!
    var ETHValue:String!
    
    class var sharedInstance : Rates {
        struct singleton {
            static let instance = Rates()
        }
        return singleton.instance
    }
    
    private override init() {}
    
    func populateRates(data:AnyObject) {
        
        let rates = data["rates"] as! [String:AnyObject]
        let AUD = rates["AUD"] as! [String:AnyObject]
        let BTC = AUD["BTC"] as! [String:AnyObject]
        let ETH = AUD["ETH"] as! [String:AnyObject]
        
        self.BTCValue = BTC["Value"] as! String
        self.ETHValue = ETH["Value"] as! String
    }
}

//
//  Customer.swift
//  Coin Loft Retail
//
//  Created by Apple on 11/08/2016.
//  Copyright © 2016 Coin Loft. All rights reserved.
//

import UIKit

class Customer: NSObject {
    
    var id : String!
    var tier : Int!
    var identityVerified : Bool!
    var mobile : String!
    var transMinValue: String!
    var transMaxValue: String!
    var dailyMaxValue: String!
    var weeklyMaxValue: String!
    var fourWeeklyMaxValue: String!
    
    class var sharedInstance : Customer {
        struct singleton {
            static let instance = Customer()
        }
        return singleton.instance
    }
    
    private override init() {}
    
    func populateCustomer(data:AnyObject) {
        let customer                = data["customer"] as! [String:AnyObject]
        let limits                  = customer["limits"] as! [String:AnyObject]
        self.id                     = customer["id"] as! String
        self.tier                   = customer["tier"] as! Int
        self.identityVerified       = customer["identityVerified"] as! Bool
        self.mobile                 = customer["mobile"] as! String
        self.transMinValue          = limits["transMinValue"] as! String
        self.transMaxValue          = limits["transMaxValue"] as! String
        self.weeklyMaxValue         = limits["weeklyMaxValue"] as! String
        self.fourWeeklyMaxValue     = limits["4weeklyMaxValue"] as! String
    }
    
}

//
//  Constants.swift
//  Coin Loft Retail
//
//  Created by Apple on 10/08/2016.
//  Copyright © 2016 Coin Loft. All rights reserved.
//

import Foundation
import UIKit


//iPhone resolutions
let IS_IPHONE4  = UIScreen.mainScreen().bounds.height == 480 ? true : false
let IS_IPHONE5  = UIScreen.mainScreen().bounds.height == 568 ? true : false
let IS_IPHONE6  = UIScreen.mainScreen().bounds.height == 667 ? true : false
let IS_IPHONE6P = UIScreen.mainScreen().bounds.height == 736 ? true : false

// Network Constants
let URL_UXDATA = "/uxdata"
let URL_STATUS = "/status"
let URL_VALIDATE_CUSTOMER_PHONE = "/customer/validate"
let URL_VALIDATE_CUSTOMER_OTP = "/customer/validateOTP"
let URL_RATES = "/rates"
let URL_QUOTE = "/quote"
let URL_ORDER = "/order"
let URL_PAYMENT = "/order/payment"


// User Defaults Constants
let CURRENCY_TYPE = "currencyType"
let CURRENCY_BTC = "BTC"
let CURRENCY_ETH = "ETH"
let NONCE = "nonce"
let HASH = "hash"
let MERCHANT_CODE = "merchantCode"
let MERCHANT_PASSWORD = "merchantPassword"
let MERCHANT_SECURITY_CODE = "merchantSecurityCode"
let MERCHANT_FINGER_PRINT = "merchantFingerPrint"
let MERCHANT_REGISTERED = "isMerchantRegistered"
let SERVICE_STATUS = "serviceStatus"
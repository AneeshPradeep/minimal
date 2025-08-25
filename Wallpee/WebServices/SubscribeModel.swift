//
//  SubscribeModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 14/6/24.
//

import UIKit
import StoreKit

class SubscribeModel: NSObject {
    
    let title: String
    var price: Double
    var purchased: Bool
    let productID: String
    var product: SKProduct?
    
    init(title: String, price: Double, purchased: Bool, productID: String, product: SKProduct?) {
        self.title = title
        self.price = price
        self.purchased = purchased
        self.productID = productID
        self.product = product
    }
}

extension SubscribeModel {
    
    static func shared() -> [SubscribeModel] {
        return [
            /*
            SubscribeModel(
                title: "Simply Watch Ads".localized(),
                price: 0.00,
                purchased: false,
                productID: ProductID.free,
                product: nil),
            */
            
            SubscribeModel(
                title: "Monthly".localized(),
                price: 4.99, //129.000 VND
                purchased: false,
                productID: ProductID.monthly,
                product: nil),
            
            SubscribeModel(
                title: "Annual".localized(),
                price: 39.99, //999.000 VND
                purchased: false,
                productID: ProductID.annual,
                product: nil),
            
            SubscribeModel(
                title: "Unlimited".localized(),
                price: 79.99, //1.999.000 VND
                purchased: false,
                productID: ProductID.unlimited,
                product: nil),
        ]
    }
}

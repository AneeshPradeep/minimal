//
//  ReceiptModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 14/6/24.
//

import UIKit

struct ReceiptModel {
    
    let latest_receipt: String
    
    //latest_receipt_info
    let purchase_date: String
    let expires_date: String
    let in_app_ownership_type: String //Đã thanh toán chưa
    let subscription_group_identifier: String
    let product_id: String
    let isPurchased: Bool //Dựa trên biến 'in_app_ownership_type'
    
    //pending_renewal_info
    let auto_renew_product_id: String
    let original_transaction_id: String
    
    /*
     - 1: true. 0: false
     - 1: đăng ký tự động gia hạn
     - 0: đã hủy tự động gia hạn
     */
    let auto_renew_status: String
}

class Receipt: NSObject {
    
    private let model: ReceiptModel
    
    var latest_receipt: String {
        return model.latest_receipt
    }
    
    //latest_receipt_info
    var purchase_date: String {
        return model.purchase_date
    }
    var expires_date: String {
        return model.expires_date
    }
    var in_app_ownership_type: String {
        return model.in_app_ownership_type
    }
    var subscription_group_identifier: String {
        return model.subscription_group_identifier
    }
    var product_id: String {
        return  model.product_id
    }
    var isPurchased: Bool {
        return model.isPurchased
    }
    
    //pending_renewal_info
    var auto_renew_product_id: String {
        return model.auto_renew_product_id
    }
    var original_transaction_id: String {
        return model.original_transaction_id
    }
    var auto_renew_status: String {
        return model.auto_renew_status
    }
    
    init(model: ReceiptModel) {
        self.model = model
    }
}

extension Receipt {
    
    convenience init(dict: [String: Any]) {
        let latest_receipt = "\(dict["latest_receipt"] ?? "")"
        
        //latest_receipt_info
        var purchase_date = ""
        var expires_date = ""
        var in_app_ownership_type = ""
        var subscription_group_identifier = ""
        var product_id = ""
        
        if let array = dict["latest_receipt_info"] as? NSArray {
            let newArray = array
                .sortedArray(using: [
                    NSSortDescriptor(key: "purchase_date", ascending: false)
                ])
                .compactMap({ $0 as? [String: Any] })
            
            if let dict = newArray.first {
                purchase_date = "\(dict["purchase_date"] ?? "")"
                expires_date = "\(dict["expires_date"] ?? "")"
                in_app_ownership_type = "\(dict["in_app_ownership_type"] ?? "")"
                subscription_group_identifier = "\(dict["subscription_group_identifier"] ?? "")"
                product_id = "\(dict["product_id"] ?? "")"
            }
        }
        
        let isPurchased = in_app_ownership_type == "PURCHASED"
        
        //pending_renewal_info
        var auto_renew_product_id = ""
        var original_transaction_id = ""
        var auto_renew_status = ""
        
        if let array = dict["pending_renewal_info"] as? NSArray,
           let dict = array.compactMap({ $0 as? [String: Any] }).first
        {
            auto_renew_product_id = "\(dict["auto_renew_product_id"] ?? "")"
            original_transaction_id = "\(dict["original_transaction_id"] ?? "")"
            auto_renew_status = "\(dict["auto_renew_status"] ?? "")"
        }
        
        let model = ReceiptModel(
            latest_receipt: latest_receipt,
            purchase_date: purchase_date,
            expires_date: expires_date,
            in_app_ownership_type: in_app_ownership_type,
            subscription_group_identifier: subscription_group_identifier,
            product_id: product_id,
            isPurchased: isPurchased,
            auto_renew_product_id: auto_renew_product_id,
            original_transaction_id: original_transaction_id,
            auto_renew_status: auto_renew_status)
        
        self.init(model: model)
    }
}

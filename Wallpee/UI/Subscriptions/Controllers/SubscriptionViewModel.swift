//
//  SubscriptionViewModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 14/6/24.
//

import UIKit
import StoreKit

class SubscriptionViewModel: NSObject {
    
    //MARK: - Properties
    private let parentVC: SubscriptionVC
    
    lazy var products: [SKProduct] = []
    
    lazy var items: [SubscribeModel] = {
        return SubscribeModel.shared()
    }()
    
    var selectedItem: SubscribeModel?
    
    var desTxt: String {
        return "✓ No Ads".localized() + "\n" + "✓ All Wallpapers".localized()
    }
    
    var hud: HUD?
    
    //MARK: - Initializes
    init(parentVC: SubscriptionVC) {
        self.parentVC = parentVC
    }
}

//MARK: - GET Data

extension SubscriptionViewModel {
    
    func loadProducts() {
        parentVC.monthlyView.updateUI(txt: items[0].title, priceTxt: "--")
        parentVC.annualView.updateUI(txt: items[1].title, priceTxt: "--")
        parentVC.unlimitedView.updateUI(txt: items[2].title, priceTxt: "--")
        
        if products.count <= 0 {
            hud = HUD.hud(kWindow)
        }
        
        ProductID.store.requestProducts { [weak self] success, products in
            guard let `self` = self else {
                self?.hud?.removeHUD {}
                return
            }
            
            if success {
                self.products = products ?? []
                
                for product in self.products {
                    let productID = product.productIdentifier
                    
                    if let index = self.items.firstIndex(where: {
                        $0.productID == productID
                    }) 
                    {
                        self.items[index].price = product.price.doubleValue
                        self.items[index].product = product
                        self.items[index].purchased = ProductID.store.isProductPurchase(productID)
                    }
                }
                
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
        }
    }
    
    func updateUI() {
        parentVC.monthlyView.subtitleLbl.isHidden = true
        parentVC.annualView.subtitleLbl.isHidden = true
        parentVC.unlimitedView.subtitleLbl.isHidden = true
        
        parentVC.contentView.enableBuyButton(enable: true)
        
        let purchasedItems = items.filter({ $0.purchased })
        
        let monthly = purchasedItems.first(where: { $0.productID == ProductID.monthly })
        let annual = purchasedItems.first(where: { $0.productID == ProductID.annual })
        let unlimited = purchasedItems.first(where: { $0.productID == ProductID.unlimited })
        
        //Unlimited
        if unlimited != nil {
            parentVC.unlimitedView.subtitleLbl.isHidden = false
            parentVC.unlimitedView.subtitleLbl.text = appDL.isPremium ? "Paid".localized() : "One-time payment".localized()
        }
        //Annual || Monthly
        else {
            if let json = WebService.shared.getJSONFile(WebService.shared.receiptFN) as? [String: Any] {
                let f = ProductID.store.expireFormatter()
                
                let receipt = Receipt(dict: json)
                
                if receipt.expires_date != "",
                    let expires_date = f.date(from: receipt.expires_date)
                {
                    f.locale = .current
                    f.timeZone = .current
                    f.amSymbol = "AM"
                    f.pmSymbol = "PM"
                    f.dateFormat = "HH:mm a, dd/MM/yyyy"
                    
                    //Chuyển từ UTC đến Current
                    let time = f.string(from: expires_date)
                    
                    //Lấy ngày hiện tại từ thiết bị
                    let f = ProductID.store.currentFormatter()
                    
                    //Ngày hiện tại đến UTC
                    let str = f.string(from: Date())
                    f.timeZone = TimeZone(abbreviation: "GMT")
                    
                    var title = ""
                    
                    if let current_date = f.date(from: str) {
                        //Nếu current_date > expires_date thì nên đăng ký lại
                        let expired = current_date > expires_date
                        title = expired ? "Expired:".localized() : "Renewed at:".localized()
                    }
                    
                    //Monthly
                    if monthly != nil {
                        parentVC.monthlyView.subtitleLbl.isHidden = false
                        parentVC.monthlyView.subtitleLbl.text = title + " " + time
                        
                    }
                    //Annual
                    else if annual != nil {
                        parentVC.annualView.subtitleLbl.isHidden = false
                        parentVC.annualView.subtitleLbl.text = title + " " + time
                    }
                }
            }
        }
        
        let prMonthly = products.first(where: {
            $0.productIdentifier == ProductID.monthly
        })
        let prAnnual = products.first(where: {
            $0.productIdentifier == ProductID.annual
        })
        let prUnlimited = products.first(where: {
            $0.productIdentifier == ProductID.unlimited
        })
        
        //Monthly
        if let product = prMonthly {
            let priceTxt = ProductID.store.getPriceFormatted(for: product)
            parentVC.monthlyView.updateUI(txt: items[0].title, priceTxt: priceTxt)
        }
        
        //Annual
        if let product = prAnnual {
            let priceTxt = ProductID.store.getPriceFormatted(for: product)
            parentVC.annualView.updateUI(txt: items[1].title, priceTxt: priceTxt)
        }
        
        //Unlimited
        if let product = prUnlimited {
            let priceTxt = ProductID.store.getPriceFormatted(for: product)
            parentVC.unlimitedView.updateUI(txt: items[2].title, priceTxt: priceTxt)
        }
        
        //Nếu chưa mua bất kỳ gói nào thì trả về chọ mặc định "Unlimited"
        if purchasedItems.count <= 0 {
            selectedItem = items[2]
            parentVC.contentView.selectedView(index: 2, items: items)
            
        } else {
            if let first = purchasedItems.first,
               let index = items.firstIndex(where: {
                   $0.productID == first.productID
               }) 
            {
                selectedItem = items[index]
                parentVC.contentView.selectedView(index: index, items: items)
            }
        }
        
        hud?.removeHUD {}
    }
}

//MARK: - Actions

extension SubscriptionViewModel {
    
    func infoDidTap() {
        let mesTxt = "Payment will be charged to iTunes Account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase. No cancellation of the current subscription is allowed during active subscription period. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.".localized()
        
        CustomizeAlert.shared.customizeAlert(
            type: .other,
            iconImage: UIImage(named: "alert-info"),
            titleTxt: "Subscription Info".localized(),
            mesTxt: mesTxt,
            isTV: true,
            cancelStr: "") { act in }
    }
    
    func buySubscriptionDidTap() {
        //Đã chọn Gói nào
        guard let item = selectedItem else {
            return
        }
        
        //Đã lấy SKProduct từ API hay chưa
        guard let product = item.product else {
            return
        }
        
        let price = " \"\(ProductID.store.getPriceFormatted(for: product))\"."
        
        var titleTxt = ""
        var mesTxt = "Subscription for".localized() + price
        
        let today = Date()
        let cal = Calendar(identifier: .gregorian)
        var nextDate: Date?
        
        switch item.productID {
        case ProductID.monthly:
            titleTxt = "Monthly Subscription".localized()
            nextDate = cal.date(byAdding: .month, value: 1, to: today)
            break
            
        case ProductID.annual:
            titleTxt = "Annual Subscription".localized()
            nextDate = cal.date(byAdding: .year, value: 1, to: today)
            break
            
        case ProductID.unlimited:
            titleTxt = "Unlimited Subscription".localized()
            break
            
        default:
            break
        }
        
        var fromDate = ""
        var toDate = ""
        
        if let nextDate = nextDate {
            let f = createDateFormatter()
            f.dateFormat = "dd/MM/yyyy"
            
            fromDate = f.string(from: today)
            toDate = f.string(from: nextDate)
            
            let timeTxt = fromDate + " - " + toDate
            mesTxt = mesTxt + "\n" + timeTxt
        }
        
        CustomizeAlert.shared.customizeAlert(
            type: .other,
            iconImage: UIImage(named: "alert-info"),
            titleTxt: titleTxt,
            mesTxt: mesTxt + "\n\n" + desTxt) { act in
                if act == "OK" {
                    if ProductID.store.canMakePayments() {
                        ProductID.store.buyProduct(product)
                    }
                }
            }
    }
    
    func openTermsOfUse() {
        let link = WebService.shared.getFromAPIKeyFile(key: "TermsOfUse")
        openURL(link: link)
    }
    
    func openPrivacyPolicy() {
        var key = "PrivacyPolicyForIAP_VN"
        
        if appDL.currentLanguage.code == "en" {
            key = "PrivacyPolicyForIAP_EN"
        }
        
        let link = WebService.shared.getFromAPIKeyFile(key: key)
        openURL(link: link)
    }
    
    private func openURL(link: String) {
        guard let url = URL(string: link) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

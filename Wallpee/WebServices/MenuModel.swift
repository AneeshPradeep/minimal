//
//  MenuModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 9/6/24.
//

import UIKit

class MenuModel {
    
    enum MenuType: String {
        case downloaded
        case language
        case earn
        case termsAndConditions
        case support
        case rateUs
        case shareApp
    }
    
    let name: String
    let icon: UIImage?
    let type: MenuType
    
    init(name: String, icon: UIImage?, type: MenuType) {
        self.name = name
        self.icon = icon
        self.type = type
    }
}

//MARK: - Shared

extension MenuModel {
    
    class func shared() -> [MenuModel] {
        return [
            MenuModel(name: "Downloaded".localized(), icon: UIImage(named: "setting-downloaded"), type: .downloaded),
            MenuModel(name: "Language".localized(), icon: UIImage(named: "setting-language"), type: .language),
            MenuModel(name: "Earn".localized(), icon: UIImage(named: showNotif() ? "setting-coin-notif" : "setting-coin"), type: .earn),
            MenuModel(name: "T&C".localized(), icon: UIImage(named: "setting-termAndCondition"), type: .termsAndConditions),
            MenuModel(name: "Support".localized(), icon: UIImage(named: "setting-support"), type: .support),
            MenuModel(name: "Rate Us".localized(), icon: UIImage(named: "setting-rateUs"), type: .rateUs),
            MenuModel(name: "Share App".localized(), icon: UIImage(named: "setting-share"), type: .shareApp),
        ]
    }
    
    class func showNotif() -> Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        
        let f = createDateFormatter()
        f.dateFormat = "yyyyMMdd"
        
        let today = f.string(from: Date())
        var isShow = false
        
        if let result = CoreDataStack.fetchDailyRewards().first(where: {
            $0.createdTime == today
        }) {
            let isEarn = result.earn == false
            
            let v_1 = ((isEarn && (hour >= 7)) || (isEarn && KeyManager.shared.getDailyRewards() == false))
            let v_2 = (KeyManager.shared.getSpin() ?? 0) > 0
            
            isShow = v_1 || v_2
        }
        
        return isShow
    }
}

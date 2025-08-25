//
//  ShareModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit

class ShareModel {
    
    let title: String
    var image: UIImage?
    let type: ShareType
    
    enum ShareType: String {
        case instagram
        case facebook
        case imessage
        case copyLink
        case more
    }
    
    init(title: String, image: UIImage?, type: ShareType) {
        self.title = title
        self.image = image
        self.type = type
    }
}

//MARK: - Share

extension ShareModel {
    
    class func shared() -> [ShareModel] {
        return [
            ShareModel(title: "Facebook".localized(), image: UIImage(named: "share-facebook"), type: .facebook),
            ShareModel(title: "iMessage".localized(), image: UIImage(named: "share-imessage"), type: .imessage),
            ShareModel(title: "Instagram".localized(), image: UIImage(named: "share-instagram"), type: .instagram),
            ShareModel(title: "More".localized(), image: UIImage(named: "share-more"), type: .more),
        ]
    }
}

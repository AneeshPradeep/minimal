//
//  UIScreen+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 3/6/24.
//

import UIKit

internal extension UIScreen {
    
    static var current: UIScreen {
        return kWindow?.screen ?? UIScreen.main
    }
}

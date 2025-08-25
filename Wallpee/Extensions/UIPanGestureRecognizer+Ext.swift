//
//  UIPanGestureRecognizer+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 3/6/24.
//

import UIKit

internal extension UIPanGestureRecognizer {
    
    ///Hủy Pan
    func cancel() {
        isEnabled = false
        isEnabled = true
    }
}

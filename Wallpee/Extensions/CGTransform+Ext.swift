//
//  CGTransform+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 6/6/24.
//

import UIKit

internal extension CGAffineTransform {
    
    static func transform(parent: CGRect, soChild child: CGRect, aspectFills rect: CGRect) -> Self {
        let childRatio = child.width / child.height
        let rectRatio = rect.width / rect.height
        
        let scaleX = rect.width / child.width
        let scaleY = rect.height / child.height
        
        let scaleFactor = rectRatio < childRatio ? scaleY : scaleX
        
        let offsetX = rect.midX - parent.midX
        let offsetY = rect.midY - parent.midY
        let centerOffsetX = (parent.midX - child.midX) * scaleFactor
        let centerOffsetY = (parent.midY - child.midY) * scaleFactor
        
        let translateX = offsetX + centerOffsetX
        let translateY = offsetY + centerOffsetY
        
        let scaleTransform = CGAffineTransform(scaleX: scaleY, y: scaleY)
        let translateTransform = CGAffineTransform(translationX: translateX, y: translateY)
        
        return scaleTransform.concatenating(translateTransform)
    }
}

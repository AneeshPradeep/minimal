//
//  UIView+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 3/6/24.
//

import UIKit

internal extension UIView {
    
    func roundCorners(with corner: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        let mask = CAShapeLayer()
        mask.path = path
        
        layer.mask = mask
    }
    
    var frameInWindow: CGRect? {
        superview?.convert(frame, to: nil)
    }
    
    func setAnchorPoint(anchorPoint: CGPoint) {
        let layer = self.layer
        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * layer.anchorPoint.x, y: self.bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(layer.affineTransform())
        oldPoint = oldPoint.applying(layer.affineTransform())
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = anchorPoint
    }
}

//
//  CGPoint+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import UIKit

extension CGPoint {
    
    func angle(to comparisonPoint: CGPoint, startPositionOffsetAngle: CGFloat, rotationOffsetAngle: CGFloat) -> CGFloat {
        
        // Clockwise = 1
        let circleDrawDirection: CGFloat = 1
        let originX = comparisonPoint.x - x
        let originY = circleDrawDirection * (comparisonPoint.y - y)
        
        let bearingRadians = atan2f(Float(originY), Float(originX))
        
        let offsetDegreeForTopPosition: CGFloat = 90
        let _startPositionOffsetAngle = startPositionOffsetAngle * circleDrawDirection
        let _rotationOffsetAngle = rotationOffsetAngle * circleDrawDirection
        
        var bearingDegrees = CGFloat(bearingRadians).radiansToDegrees() - offsetDegreeForTopPosition - _startPositionOffsetAngle + _rotationOffsetAngle
        
        while bearingDegrees < 0 {
            bearingDegrees += 360
        }
        
        return bearingDegrees
    }
}

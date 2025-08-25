//
//  CGFloat+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 16/6/24.
//

import UIKit

internal extension CGFloat {
    
    func radiansToDegrees() -> CGFloat {
        return self * 180 / .pi
    }
    
    func degreesToRadians() -> CGFloat {
        return self * .pi / 180
    }
    
    static var flipRotation: CGFloat {
        return .pi
    }
    
    static func circularSegmentHeight(radius: CGFloat, from degree: CGFloat) -> CGFloat {
        return 2 * radius * sin(degree / 2.0 * CGFloat.pi / 180)
    }
    
    static func radius(circularSegmentHeight: CGFloat, from degree: CGFloat) -> CGFloat {
        return circularSegmentHeight / (2 * sin(degree / 2.0 * CGFloat.pi / 180))
    }
}

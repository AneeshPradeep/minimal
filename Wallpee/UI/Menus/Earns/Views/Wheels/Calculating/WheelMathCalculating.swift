//
//  WheelMathCalculating.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import UIKit

protocol WheelMathCalculating: AnyObject {
    
    var frame: CGRect { get set }
    var mainFrame: CGRect! { get set }
    var preferences: SFWConfiguration.WheelPreferences? { get set }
}

extension WheelMathCalculating {
    
    var radius:CGFloat {
        return mainFrame.height / 2.0
    }
    
    var rotationOffset:CGFloat {
        return (mainFrame.width) / 2 + abs(preferences?.layerInsets.top ?? 0)
    }
    
    func circularSegmentHeight(from degree: CGFloat) -> CGFloat {
        return .circularSegmentHeight(radius: radius, from: degree)
    }
    
    func updateSizes(updateFrame: Bool = true) {
        if let layerInsets = preferences?.layerInsets {
            self.mainFrame = CGRect(origin: CGPoint(x: abs(layerInsets.left), y: abs(layerInsets.top)), size: frame.size)
            
            if updateFrame {
                self.frame = frame.inset(by: layerInsets)
            }
            
        } else {
            self.mainFrame = self.frame
        }
    }
}

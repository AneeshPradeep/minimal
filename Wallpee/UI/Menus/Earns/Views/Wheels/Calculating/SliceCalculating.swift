//
//  SliceCalculating.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import Foundation
import CoreGraphics

protocol SliceCalculating {
    var slices: [Slice] { get set }
}

extension SliceCalculating {
    
    var sliceDegree: CGFloat {
        guard slices.count > 0 else {
            return 0
        }
        return 360.0 / CGFloat(slices.count)
    }
    
    var theta: CGFloat {
        return sliceDegree * .pi / 180.0
    }
    
    func computeRadian(from finishIndex:Int) -> CGFloat {
        return CGFloat(finishIndex) * sliceDegree
    }
    
    func index(fromAngle angle: CGFloat) -> Int {
        guard sliceDegree > 0 else { return 0 }
        
        var _angle = angle + sliceDegree / 2
        
        if _angle > 360 {
            _angle -= 360
        }
        
        let index = Int((_angle / sliceDegree).rounded(.down))
        
        return min(index, slices.count - 1)
    }
    
    func segmentHeight(radius: CGFloat) -> CGFloat {
        return radius * (1 - cos(sliceDegree / 2 * CGFloat.pi / 180))
    }
}

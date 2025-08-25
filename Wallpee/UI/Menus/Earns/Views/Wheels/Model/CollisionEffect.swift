//
//  CollisionEffect.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import UIKit

public struct CollisionEffect {
    
    /// The force that will affect to collision effect, should be more than 0
    public var force: Double
    
    /// The angle which will be rotated a View
    public var angle: CGFloat
    
    /// Initializes collision effect
    /// - Parameters:
    ///   - force: The force that will affect to collision effect, should be more than 0, default value is 10
    ///   - angle: The angle which will be rotated a View, default value is 30
    public init(force: Double = 10, angle: CGFloat = 30) {
        self.force = force
        self.angle = angle
    }
}

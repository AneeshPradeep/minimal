//
//  ContinuousCollisionCalculator.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import UIKit

class ContinuousCollisionCalculator {
    
    /// The time when the last collision accrued
    var lastCollisionTime: CFTimeInterval = 0
    
    /// Interval between collisions
    private var CollisionInterval: CFTimeInterval?
    
    /// Current collision index
    private var currentCollisionIndex: Int = 0
    
    /// Rotation degree offset
    var rotationDegreeOffset: CGFloat = 0
    
    func calculateCollisionInterval(sliceDegree: CGFloat, rotationDegreeOffset: CGFloat, fullRotationDegree: CGFloat, speed: CGFloat, speedAcceleration: CGFloat) {
        self.rotationDegreeOffset = rotationDegreeOffset
        CollisionInterval = CFTimeInterval(sliceDegree / (fullRotationDegree * speed * speedAcceleration))
    }
    
    func calculateCollisionsIfNeeded(timestamp: CFTimeInterval, onCollision: ((_ progress: Double?) -> Void)? = nil) {
        guard let collisionInterval = self.CollisionInterval else { return }
        
        let interval = currentCollisionIndex == 0 ? collisionInterval - Double(rotationDegreeOffset) : collisionInterval
        
        if lastCollisionTime + interval < timestamp {
            lastCollisionTime = timestamp
            currentCollisionIndex += 1
            onCollision?(nil)
        }
    }
    
    /// Resets parameters
    func reset() {
        CollisionInterval = nil
        currentCollisionIndex = 0
    }
}

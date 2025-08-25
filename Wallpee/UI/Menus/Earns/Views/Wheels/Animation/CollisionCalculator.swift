//
//  CollisionCalculator.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import UIKit

/// Calculates collision during the animation
class CollisionCalculator {
    
    /// Collisions start positions
    private var collisionDegrees: [Double] = []
    
    /// Current collision index
    private var currentCollisionIndex: Int = 0
    
    /// 360 degrees of rotation count
    private var rotationCount: Int = 0
    
    /// Total rotation degree
    private var totalRotationDegree: Double = 0
    
    /// Last rotation degree
    private var lastRotationDegree: Double?
    
    /// Rotation direction offset
    private var rotationDirectionOffset: CGFloat {
        return 1
    }
    
    func calculateCollisionDegrees(sliceDegree: CGFloat, rotationDegreeOffset: CGFloat, rotationDegree: CGFloat, animationDuration: CFTimeInterval) {
        
        let sectorsCount = (rotationDegree / sliceDegree)
        
        for index in 0..<Int(sectorsCount) {
            let degree = (rotationDegreeOffset + (CGFloat(index) * sliceDegree))
            collisionDegrees.append(Double(degree))
        }
    }
    
    func calculateCollisionsIfNeeded(layerRotationZ: Double?, onCollision: ((_ progress: Double?) -> Void)? = nil) {
        // Return if collisionDegrees is empty
        guard collisionDegrees.count > 0 else { return }
        
        // Return if layerRotationZ is nil
        guard let rotationZ = layerRotationZ else { return }
        
        // Return if all collisions are calculated
        guard currentCollisionIndex < collisionDegrees.count else { return }
        
        // The layer's rotated offset value converted to degree
        let rotationOffset = rotationZ * Double(rotationDirectionOffset) * 180.0 / .pi
        
        // Current rotation position of the layer
        let currentRotationDegree = rotationOffset >= 0 ? rotationOffset : 360 + rotationOffset
        
        // Total rotation degree of the layer
        totalRotationDegree = Double(rotationCount * 360) + currentRotationDegree
        
        // Current collision degree that should be used to collide
        let currentCollisionDegree = collisionDegrees[currentCollisionIndex]
        
        // If the layer rotation position is more then current collision degree
        if currentCollisionDegree < totalRotationDegree {
            // Next collision index
            var nextCollisionIndex = currentCollisionIndex + 1
            
            // If not finished
            guard currentCollisionIndex < collisionDegrees.count else {
                // Updates current collision index
                currentCollisionIndex = nextCollisionIndex
                
                // Update current collision progress
                let progress: Double = Double(currentCollisionIndex / collisionDegrees.count)
                
                // Callback collision if needed with progress
                onCollision?(progress)
                return
            }
            
            // Creates a new collision degrees array from the next collision index
            let nextCollisionDegrees = collisionDegrees[currentCollisionIndex+1..<collisionDegrees.count]
            
            // Moves collision index forward if total rotated degree is passed
            // Made to bypass sound delay if layers are rotating very fast and collisions count are too many
            for nextCollisionDegree in nextCollisionDegrees {
                if nextCollisionDegree < totalRotationDegree {
                    nextCollisionIndex += 1
                } else {
                    break
                }
            }
            // Updates current collision index
            currentCollisionIndex = nextCollisionIndex
            
            // Update current collision progress
            let progress: Double = Double(currentCollisionIndex) / Double(collisionDegrees.count)
            
            // Callback collision if needed with progress
            onCollision?(progress)
        }
        
        // If the previous rotation degree is more than current, then the layer is rotated more than 360 degree
        if lastRotationDegree ?? 0 > currentRotationDegree {
            rotationCount += 1
        }
        
        // Remembers last rotation degree, used to correctly calculate total rotation degree
        lastRotationDegree = currentRotationDegree
    }
    
    func reset() {
        collisionDegrees = []
        currentCollisionIndex = 0
        rotationCount = 0
        totalRotationDegree = 0
        lastRotationDegree = nil
    }
}

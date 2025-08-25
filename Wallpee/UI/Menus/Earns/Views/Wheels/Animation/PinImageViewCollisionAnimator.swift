//
//  PinImageViewCollisionAnimator.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import UIKit

class PinImageViewCollisionAnimator {
    
    /// Physics related animation
    var snapAnimator: UIDynamicAnimator?
    
    /// Snap behavior
    var snapBehavior: UISnapBehavior?
    
    /// Reference view that will serves as the coordinate system
    weak var referenceView: UIView?
    
    /// Pin Image view
    weak var pinImageView: UIView?
    
    func prepare(referenceView: UIView, pinImageView: UIView) {
        self.pinImageView = pinImageView
        snapAnimator = UIDynamicAnimator(referenceView: referenceView)
        snapBehavior = UISnapBehavior(item: pinImageView, snapTo: pinImageView.center)
        snapAnimator?.addBehavior(snapBehavior!)
    }
    
    func movePin(force: Double, angle: CGFloat, position: SFWConfiguration.Position) {
        guard let pinImageView = self.pinImageView else { return }
        guard let snapBehavior = self.snapBehavior else { return }
        guard let snapAnimator = self.snapAnimator else { return }
        snapAnimator.removeBehavior(snapBehavior)
        UIView.animate(withDuration: 1 / force) {
            let theta = (angle * -1).degreesToRadians()
            pinImageView.transform = CGAffineTransform(rotationAngle: CGFloat(theta))
            
        } completion: { (success) in
            snapAnimator.addBehavior(snapBehavior)
        }
    }
    
    func movePinIfNeeded(collisionEffect: CollisionEffect?, position: SFWConfiguration.Position?) {
        guard let position = position else { return }
        guard let force = collisionEffect?.force else { return }
        guard let angle = collisionEffect?.angle else { return }
        guard force > 0 else { return }
        movePin(force: force, angle: angle, position: position)
    }
}

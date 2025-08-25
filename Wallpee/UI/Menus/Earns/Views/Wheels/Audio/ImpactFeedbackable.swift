//
//  ImpactFeedbackable.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import UIKit

/// The protocol that adds support for the impact feedback
protocol ImpactFeedbackable {
    
    /// Use impact feedback to indicate that an impact has occurred
    var impactFeedbackgenerator: UIImpactFeedbackGenerator { get }
    
    /// Impact feedback on or off
    var impactFeedbackOn: Bool { get set }
}

extension ImpactFeedbackable {
    
    ///Prepare impact feedback if needed
    func prepareImpactFeedbackIfNeeded() {
        guard impactFeedbackOn == true else {
            return
        }
        
        impactFeedbackgenerator.prepare()
    }
    
    ///Generates impact feedback
    func impactFeedback() {
        if impactFeedbackOn {
            impactFeedbackgenerator.impactOccurred()
        }
    }
}

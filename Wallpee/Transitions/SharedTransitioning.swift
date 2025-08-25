//
//  SharedTransitioning.swift
//  Wallpee
//
//  Created by Thanh Hoang on 6/6/24.
//

import Foundation

protocol SharedTransitioning {
    var sharedFrame: CGRect { get }
    func prepare(for transition: SharedTransitionAnimator.Transition)
}

extension SharedTransitioning {
    func prepare(for transition: SharedTransitionAnimator.Transition) {}
}

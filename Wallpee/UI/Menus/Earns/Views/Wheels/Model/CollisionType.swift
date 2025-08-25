//
//  CollisionType.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import Foundation

enum CollisionType {
    case edge, center
    
    /// Identifier
    var identifier: String {
        switch self {
        case .edge: return "edgeCollision"
        case .center: return "centerCollision"
        }
    }
}

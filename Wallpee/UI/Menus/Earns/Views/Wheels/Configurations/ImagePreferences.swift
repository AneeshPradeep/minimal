//
//  ImagePreferences.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import UIKit

/// Image preferences
public struct ImagePreferences {
    
    /// Prefered image size, required
    public var preferredSize: CGSize
    
    /// Horizontal offset in slice from the center, default value is `0`
    public var horizontalOffset: CGFloat = 0
    
    /// Vertical offset in slice from the center
    public var verticalOffset: CGFloat
    
    /// Flip the text upside down, default value is `false`
    public var flipUpsideDown: Bool = false
    
    /// Background color, `optional`
    public var backgroundColor: UIColor? = nil
    
    /// Tint color, `optional`
    public var tintColor: UIColor? = nil
    
    /// Initiates a image preferences
    /// - Parameters:
    ///   - preferredSize: Prefered image size, required
    ///   - verticalOffset: Vertical offset in slice from the center, default value is `0`
    public init(preferredSize: CGSize, verticalOffset: CGFloat = 0) {
        self.preferredSize = preferredSize
        self.verticalOffset = verticalOffset
    }
}

public extension ImagePreferences {
    
    static var variousWheelPodiumImage: ImagePreferences {
        let imagePreferences = ImagePreferences(preferredSize: CGSize(width: 40, height: 40), verticalOffset: 20)
        return imagePreferences
    }
}

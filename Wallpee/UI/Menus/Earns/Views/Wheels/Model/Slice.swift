//
//  Slice.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import UIKit

public struct Slice {
    
    public var contents: [ContentType]
    
    public var backgroundColor: UIColor?
    
    public var backgroundImage: UIImage?
    
    public var type: String?
    
    public init(contents: [ContentType],
                backgroundColor: UIColor? = nil,
                backgroundImage: UIImage? = nil,
                type: String = "")
    {
        self.contents = contents
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
        self.type = type
    }
}

extension Slice {
    
    public enum ContentType {
        case assetImage(name: String, preferences: ImagePreferences)
        case image(image: UIImage, preferences: ImagePreferences)
        case text(text: String, preferences: TextPreferences)
        case line(preferences: LinePreferences)
    }
}

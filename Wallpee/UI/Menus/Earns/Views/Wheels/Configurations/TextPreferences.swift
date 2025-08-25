//
//  TextPreferences.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import UIKit

/// Text preferemces
public struct TextPreferences {
    
    /// Text font
    public var font: UIFont
    
    /// Text color type
    public var textColorType: SFWConfiguration.ColorType
    
    /// Horizontal offset in slice from the center, default value is `0`
    public var horizontalOffset: CGFloat = 0
    
    /// Vertical offset in slice from the center
    public var verticalOffset: CGFloat
    
    /// Flip the text upside down, default value is `true`
    public var flipUpsideDown: Bool = true
    
    /// Is text curved or not, works only with orientation equal to horizontal, default value is `true`
    public var isCurved: Bool = true
    
    /// Text orientation, default value is `.horizontal`
    public var orientation: Orientation = .horizontal
    
    /// The technique to use for wrapping and truncating the label’s text, default value is `.clip`
    public var lineBreakMode: LineBreakMode = .clip
    
    /// The maximum number of lines to use for rendering text., default valie is `1`
    public var numberOfLines: Int = 1
    
    /// Spacing between lines, default value is `3`
    public var spacing: CGFloat = 3
    
    /// The technique to use for aligning the text, default value is `.left`
    public var alignment: NSTextAlignment = .center
    
    /// Maximum width that will be available for text
    public var maxWidth: CGFloat = .greatestFiniteMagnitude
    
    /// Initiates a text preferences
    /// - Parameters:
    ///   - textColorType: Text color type
    ///   - font: Font
    ///   - verticalOffset: Vertical offset in slice from the center, default value is `0`
    public init(textColorType: SFWConfiguration.ColorType,
                font: UIFont,
                verticalOffset: CGFloat = 0) {
        self.textColorType = textColorType
        self.font = font
        self.verticalOffset = verticalOffset
    }
}

public extension TextPreferences {
    /// Text orientation, horizontal or vertical
    enum Orientation {
        case horizontal
        case vertical
    }
}

public extension TextPreferences {
    /// The technique to use for wrapping and truncating the label’s text
    enum LineBreakMode {
        case clip
        case truncateTail
        case wordWrap
        case characterWrap
        
        /// NSLineBreakMode
        var systemLineBreakMode: NSLineBreakMode {
            switch self {
            case .clip:
                return .byClipping
            case .truncateTail:
                return .byTruncatingTail
            case .wordWrap:
                return .byWordWrapping
            case .characterWrap:
                return  .byCharWrapping
            }
        }
    }
}

extension TextPreferences {
    
    /// Creates a color for text, relative to slice index position
    /// - Parameter index: Slice index
    /// - Returns: Color
    func color(for index: Int) -> UIColor {
        var color: UIColor = .clear
        
        switch self.textColorType {
        case .evenOddColors(let evenColor, let oddColor):
            color = index % 2 == 0 ? evenColor : oddColor
        case .customPatternColors(let colors, let defaultColor):
            color = colors?[index, default: defaultColor] ?? defaultColor
        }
        return color
    }
    
    /// Creates text attributes, relative to slice index position
    /// - Parameter index: Slice index
    /// - Returns: Text attributes
    func textAttributes(for index: Int) -> [NSAttributedString.Key:Any] {
        let textColor = self.color(for: index)
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = alignment
        textStyle.lineBreakMode = lineBreakMode.systemLineBreakMode
        textStyle.lineSpacing = spacing
        let deafultAttributes:[NSAttributedString.Key: Any] =
        [.font: self.font,
         .foregroundColor: textColor,
         .paragraphStyle: textStyle ]
        return deafultAttributes
    }
}

public extension TextPreferences {
    
    static func variousWheelPodiumText(textColor: UIColor) -> TextPreferences {
        let textColorType = SFWConfiguration.ColorType.customPatternColors(colors: nil, defaultColor: textColor)
        
        var font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        var horizontalOffset: CGFloat = 0
        
        if let customFont = UIFont(name: FontName.montBold, size: 12) {
            font = customFont
            horizontalOffset = -2
        }
    
        var textPreferences = TextPreferences(textColorType: textColorType,
                                                 font: font,
                                                 verticalOffset: 5)
        
        textPreferences.horizontalOffset = horizontalOffset
        textPreferences.orientation = .vertical
        textPreferences.alignment = .right
        
        return textPreferences
    }
}

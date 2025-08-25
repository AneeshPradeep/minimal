//
//  UIlabel+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 3/6/24.
//

import UIKit

internal extension UILabel {
    
    func addCharacterSpacing(kernValue: CGFloat) {
        if let text = text, !text.isEmpty {
            let attr = NSMutableAttributedString(string: text)
            attr.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attr.length-1))
            
            attributedText = attr
        }
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        if let text = text, !text.isEmpty {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = lineSpacing
            paragraph.lineHeightMultiple = lineHeightMultiple
            
            let attrString = NSMutableAttributedString(string: text)
            attrString.addAttribute(.paragraphStyle, value: paragraph, range: NSMakeRange(0, attrString.length))
            
            attributedText = attrString
        }
    }
    
    func addCharacterSpacingAndLineSpacing(kernValue: CGFloat, lineSpacing: CGFloat) {
        if let text = text, !text.isEmpty {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = lineSpacing
            paragraph.lineHeightMultiple = 0.0
            
            let attr = NSMutableAttributedString(string: text)
            attr.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attr.length-1))
            attr.addAttribute(.paragraphStyle, value: paragraph, range: NSMakeRange(0, attr.length))
            
            attributedText = attr
        }
    }
    
    func addStrikeThrough() {
        if let text = text, !text.isEmpty {
            let attr = NSMutableAttributedString(string: text)
            attr.addAttribute(.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attr.length))
            
            attributedText = attr
        }
    }
}

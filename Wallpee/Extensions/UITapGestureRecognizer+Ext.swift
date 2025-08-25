//
//  UITapGestureRecognizer+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 3/6/24.
//

import UIKit

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        
        let labelSize = label.bounds.size
        textContainer.size.width = labelSize.width //CGFloat.greatestFiniteMagnitude
        textContainer.size.height = labelSize.height //CGFloat.greatestFiniteMagnitude
        
        let locOfTouchInLbl = self.location(in: label)
        let textBox = layoutManager.usedRect(for: textContainer)
        let x: CGFloat = (labelSize.width - textBox.size.width)/2 - textBox.origin.x
        let y: CGFloat = (labelSize.height - textBox.size.height)/2 - textBox.origin.y
        let textContainerOffset = CGPoint(x: x, y: y)
        
        let locX: CGFloat = locOfTouchInLbl.x - textContainerOffset.x
        let locY: CGFloat = locOfTouchInLbl.y - textContainerOffset.y
        let locOfTouchInTxtCont = CGPoint(x: locX, y: locY)
        let indexOfCharacter = layoutManager.characterIndex(
            for: locOfTouchInTxtCont,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

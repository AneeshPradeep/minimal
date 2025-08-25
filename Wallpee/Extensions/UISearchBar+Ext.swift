//
//  UISearchBar+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 3/6/24.
//

import UIKit

extension UISearchBar {
    
    func customFontSearchBar(_ placeholderTxt: String) {
        let font = UIFont(name: FontName.montRegular, size: 16.0)
        let placeholderAtt: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: UIColor.placeholderText
        ]
        let placeholderAttr = NSMutableAttributedString(string: placeholderTxt, attributes: placeholderAtt)
        let frame = self[keyPath: \.searchTextField].frame
        
        self[keyPath: \.searchTextField].font = font
        self[keyPath: \.searchTextField].backgroundColor = .darkGray.withAlphaComponent(0.1)
        self[keyPath: \.searchTextField].attributedPlaceholder = placeholderAttr
        self[keyPath: \.searchTextField].roundCorners(with: [.allCorners], radius: frame.height/2)
        
        //self.searchTextField.font = font
        //self.searchTextField.attributedPlaceholder = placeholderAttr
        
        self.setValue("Cancel".localized(), forKey: "cancelButtonText")
        self.searchBarStyle = .minimal
        self.returnKeyType = .search
    }
}

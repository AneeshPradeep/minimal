//
//  UIColor+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 3/6/24.
//

import UIKit

internal extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let b = CGFloat(hex & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    func getHexStr() -> String {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getRed(&r, green: &g, blue: &b, alpha: &alpha)
        
        let rgb: Int = Int(r*255)<<16 | Int(g*255)<<8 | Int(b*255)<<0
        
        return "\(NSString(format: "%06x", rgb))".uppercased()
    }
    
    func isEqualToColor(color: UIColor, withTolerance tolerance: CGFloat = 0.0) -> Bool {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return abs(r1 - r2) <= tolerance &&
        abs(g1 - g2) <= tolerance &&
        abs(b1 - b2) <= tolerance &&
        abs(a1 - a2) <= tolerance
    }
    
    func rgb() -> (Int, Int, Int, Int)? {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            return (iRed, iGreen, iBlue, iAlpha)
            
        } else {
            return nil
        }
    }
}

internal extension UIColor {
    
    convenience init(hexStr: String, alpha: CGFloat = 1.0) {
        var hex = hexStr.trimmingCharacters(in: CharacterSet.alphanumerics.inverted).uppercased()
        
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        }
        
        assert(hex.count == 6, "Invalid hex code used.")
        
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let red: CGFloat = CGFloat((int & 0xFF0000) >> 16) / 255
        let green: CGFloat = CGFloat((int & 0xFF00) >> 8) / 255
        let blue: CGFloat = CGFloat(int & 0xFF) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

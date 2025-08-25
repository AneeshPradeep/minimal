//
//  CGSize+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import UIKit

extension CGSize {
    
    func aspectFit(sizeImage:CGSize) -> CGRect {
        let imageSize  = sizeImage
        
        let hfactor = imageSize.width/self.width
        let vfactor = imageSize.height/self.height
        
        let factor = max(hfactor, vfactor)
        
        let newWidth = imageSize.width / factor
        let newHeight = imageSize.height / factor
        
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        if newWidth > newHeight {
            y = (self.height - newHeight)/2
        }
        
        if newHeight > newWidth {
            x = (self.width - newWidth)/2
        }
        
        let newRect = CGRect(x: x, y: y, width: newWidth, height: newHeight)
        return newRect
    }
    
    static func aspectFill(aspectRatio :CGSize, minimumSize: CGSize) -> CGSize {
        var minimumSize = minimumSize
        
        let mW = minimumSize.width / aspectRatio.width;
        let mH = minimumSize.height / aspectRatio.height;
        
        if( mH > mW ) {
            minimumSize.width = minimumSize.height / aspectRatio.height * aspectRatio.width;
            
        } else if( mW > mH ) {
            minimumSize.height = minimumSize.width / aspectRatio.width * aspectRatio.height;
        }
        
        return minimumSize;
    }
}

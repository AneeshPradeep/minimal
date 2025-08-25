//
//  PhotoLayout.swift
//  Wallpee
//
//  Created by Thanh Hoang on 8/6/24.
//

import UIKit

class PhotoLayout: CustomLayout {
    
    static var itemW: CGFloat {
        return (screenWidth - 8) / 3
    }
    static var itemH: CGFloat {
        return itemW * (screenHeight/screenWidth)
    }
    
    private let numberOfColumn = 3
    
    override func calculateCellFrame() {
        guard cache.isEmpty,
              let collectionView = collectionView else {
            return
        }
        
        let width = collectionView.frame.width
        contentSize.width = width
        
        var xOffset: CGFloat = 0.0
        var yOffset: CGFloat = 0.0
        var y: CGFloat = 0.0 //Hàng tiếp theo
        
        let sections = collectionView.numberOfSections
        for section in 0..<sections {
            
            let items = collectionView.numberOfItems(inSection: section)
            for item in 0..<items {
                
                let indexPath = IndexPath(item: item, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let x = item % numberOfColumn
                
                xOffset = ((PhotoLayout.itemW + cellPadding) * CGFloat(x)) + contentPadding.horizontal
                yOffset = ((PhotoLayout.itemH + cellPadding) * y) + (contentPadding.vertical * (x == 1 ? 1:1))
                
                if x == 2 {
                    y += 1
                }
                
                attribute.frame = CGRect(
                    x: xOffset,
                    y: yOffset,
                    width: PhotoLayout.itemW,
                    height: PhotoLayout.itemH
                )
                
                cache.append(attribute)
            }
        }
        
        contentSize.height = yOffset + PhotoLayout.itemH + contentPadding.vertical
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

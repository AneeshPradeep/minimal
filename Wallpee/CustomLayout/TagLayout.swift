//
//  TagLayout.swift
//  Wallpee
//
//  Created by Thanh Hoang on 16/6/24.
//

import UIKit

public enum ContentAlign {
    case left
    case right
}

protocol TagLayoutDelegate: AnyObject {
    func cellSize(_ indexPath: IndexPath) -> CGSize
}

class TagLayout: CustomLayout {
    
    weak var delegate: TagLayoutDelegate?
    
    public var contentAlign: ContentAlign = .left
    
    static var tagH: CGFloat {
        return 45.0
    }
    
    override func calculateCellFrame() {
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        let cvWidth = collectionView.frame.size.width
        contentSize.width = cvWidth
        
        let leftPadding = contentPadding.horizontal
        let rightPadding = cvWidth - contentPadding.horizontal
        
        var leftMargin = contentAlign == .left ? leftPadding : rightPadding
        var topMargin = contentPadding.vertical
        
        let sectionsCount = collectionView.numberOfSections
        for section in 0..<sectionsCount {
            
            let itemsCount = collectionView.numberOfItems(inSection: section)
            for item in 0..<itemsCount {
                
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame.size = delegate!.cellSize(indexPath)
                
                let cellSize = attributes.frame.size
                let currentCellWidth = cellSize.width
                let currentCellHeight = cellSize.height
                
                if contentAlign == .left {
                    if leftMargin + currentCellWidth + cellPadding > cvWidth {
                        leftMargin = contentPadding.horizontal
                        topMargin += currentCellHeight + cellPadding
                    }
                    
                    attributes.frame.origin.x = leftMargin
                    attributes.frame.origin.y = topMargin
                    
                    leftMargin += currentCellWidth + cellPadding
                    
                } else if contentAlign == .right {
                    if leftMargin - currentCellWidth - cellPadding < 0.0 {
                        leftMargin = cvWidth - contentPadding.horizontal
                        topMargin += currentCellHeight + cellPadding
                    }
                    
                    attributes.frame.origin.x = leftMargin - currentCellWidth
                    attributes.frame.origin.y = topMargin
                    
                    leftMargin -= currentCellWidth + cellPadding
                }
                
                cache.append(attributes)
            }
        }
        
        contentSize.height = topMargin + TagLayout.tagH
        //TagLayout.tagH*2 + 10
    }
}

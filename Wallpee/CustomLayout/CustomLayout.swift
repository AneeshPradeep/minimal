//
//  CustomLayout.swift
//  Wallpee
//
//  Created by Thanh Hoang on 8/6/24.
//

import UIKit

struct ContentPadding {
    
    let horizontal: CGFloat
    let vertical: CGFloat
    
    init(horizontal: CGFloat = 0.0, vertical: CGFloat = 0.0) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    static var zero: ContentPadding {
        return ContentPadding()
    }
}

class CustomLayout: UICollectionViewFlowLayout {
    
    //MARK: - Properties
    var contentPadding: ContentPadding = .zero
    var cellPadding: CGFloat = 0.0
    var contentSize: CGSize = .zero
    
    var isScale = false
    
    lazy var cache: [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func prepare() {
        super.prepare()
        cache.removeAll()
        calculateCellFrame()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                attributes.append(attribute)
            }
        }
        
        if isScale {
            setScaleForAttribute(attributes: attributes)
        }
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    func calculateCellFrame() {}
    
    private func setScaleForAttribute(attributes: [UICollectionViewLayoutAttributes]) {
        if let cv = collectionView {
            func getRatio(cv: UICollectionView, attr: UICollectionViewLayoutAttributes) -> CGFloat {
                let centerX = cv.bounds.size.width/2
                let normalizedCenter = attr.center.x - cv.contentOffset.x
                let maxDistance = attr.frame.width + cellPadding
                let distanceFromCenter = min(abs(centerX - normalizedCenter), maxDistance)
                let ratio = (maxDistance - distanceFromCenter) / maxDistance
                
                return ratio
            }
            
            for attribute in attributes {
                let ratio = getRatio(cv: cv, attr: attribute)
                
                let i: CGFloat = 0.9
                let scale = ratio * (1 - i) + i
                
                attribute.transform = CGAffineTransform
                    .identity
                    .scaledBy(x: scale, y: scale)
            }
        }
    }
}

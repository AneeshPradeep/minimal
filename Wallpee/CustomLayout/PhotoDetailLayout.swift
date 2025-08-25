//
//  PhotoDetailLayout.swift
//  Wallpee
//
//  Created by Thanh Hoang on 16/6/24.
//

import UIKit

class PhotoDetailLayout: UICollectionViewFlowLayout {
    
    fileprivate var contentSize: CGSize = .zero
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        
        contentSize.width = collectionView.frame.size.width
        contentSize.height = collectionView.frame.size.height
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else {
            return nil
        }
        
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        for attributes in layoutAttributes {
            let collectionViewWidth = collectionView.frame.size.width
            let center = collectionViewWidth/2.0
            let xOffset = collectionView.contentOffset.x
            let normalizedCenter = attributes.center.x - xOffset
            
            let distanceFromCenter = min(center - normalizedCenter, collectionViewWidth)
            let ratio = (collectionViewWidth - abs(distanceFromCenter))/collectionViewWidth
            
            let alpha = ratio * (1 - 0.5) + 0.5
            let scale = ratio * (1 - 0.7) + 0.7
            attributes.alpha = alpha
            
            let angle = distanceFromCenter / collectionViewWidth
            let identity = CATransform3DIdentity
            var transform = CATransform3DScale(identity, scale, scale, 1.0)
            
            transform.m34 = 1/400
            transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0)
            
            attributes.transform3D = transform
        }
        
        return layoutAttributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView,
              let layoutAttributes = layoutAttributesForElements(in: collectionView.bounds)
        else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let center = collectionView.bounds.size.width/2.0
        let offset = proposedContentOffset.x + center
        
        let attributes = layoutAttributes
            .sorted(by: {
                abs($0.center.x - offset) < abs($1.center.x - offset)
            })
            .first ?? UICollectionViewLayoutAttributes()
        
        return CGPoint(x: attributes.center.x - center, y: 0.0)
    }
}

//
//  CustomizedTabBar.swift
//  Wallpee
//
//  Created by Thanh Hoang on 4/6/24.
//

import UIKit

class CustomizedTabBar: UITabBar {
    
    private var caLayer: CALayer?
    private let shapeLayer = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        addShape()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0.0 else {
            return nil
        }
        
        for sub in subviews.reversed() {
            let subPt = sub.convert(point, from: self)
            guard let result = sub.hitTest(subPt, with: event) else {
                continue
            }
            
            return result
        }
        
        return nil
    }
    
    private func addShape() {
        let maxW: CGFloat = 1000.0
        let maxH: CGFloat = 315.0
        
        let tabW: CGFloat = screenWidth
        let tabH: CGFloat = tabW * (maxH/maxW)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: tabW*(688.57/maxW), y: 0.0))
        bezierPath.addLine(to: CGPoint(x: tabW*(688.56/maxW), y: 0.0))
        bezierPath.addCurve(to: CGPoint(x: tabW*(602.09/maxW), y: tabH*(-53.06/maxH)),
                            controlPoint1: CGPoint(x: tabW*(652.05/maxW), y: 0.0),
                            controlPoint2: CGPoint(x: tabW*(618.97/maxW), y: tabH*(-20.68/maxH)))
        bezierPath.addCurve(to: CGPoint(x: tabW*(580.5/maxW), y: tabH*(-82.13/maxH)),
                            controlPoint1: CGPoint(x: tabW*(596.55/maxW), y: tabH*(-63.68/maxH)),
                            controlPoint2: CGPoint(x: tabW*(589.31/maxW), y: tabH*(-73.49/maxH)))
        bezierPath.addCurve(to: CGPoint(x: tabW*(501.13/maxW), y: tabH*(-115/maxH)),
                            controlPoint1: CGPoint(x: tabW*(559.33/maxW), y: tabH*(-102.88/maxH)),
                            controlPoint2: CGPoint(x: tabW*(530.77/maxW), y: tabH*(-114.71/maxH)))
        bezierPath.addCurve(to: CGPoint(x: tabW*(418.68/maxW), y: tabH*(-81.32/maxH)),
                            controlPoint1: CGPoint(x: tabW*(469.99/maxW), y: tabH*(-115.29/maxH)),
                            controlPoint2: CGPoint(x: tabW*(440.67/maxW), y: tabH*(-103.31/maxH)))
        bezierPath.addCurve(to: CGPoint(x: tabW*(397.52/maxW), y: tabH*(-52.3/maxH)),
                            controlPoint1: CGPoint(x: tabW*(410.03/maxW), y: tabH*(-72.67/maxH)),
                            controlPoint2: CGPoint(x: tabW*(402.93/maxW), y: tabH*(-62.88/maxH)))
        bezierPath.addCurve(to: CGPoint(x: tabW*(311.44/maxW), y: 0.0),
                            controlPoint1: CGPoint(x: tabW*(381.02/maxW), y: tabH*(-20.07/maxH)),
                            controlPoint2: CGPoint(x: tabW*(347.64/maxW), y: 0.0))
        bezierPath.addLine(to: CGPoint(x: 0.0, y: 0.0))
        bezierPath.addLine(to: CGPoint(x: 0.0, y: tabH*(200/maxH)))
        bezierPath.addLine(to: CGPoint(x: tabW*(1000/maxW), y: tabH*(200/maxH)))
        bezierPath.addLine(to: CGPoint(x: tabW*(1000/maxW), y: 0.0))
        bezierPath.addLine(to: CGPoint(x: tabW*(688.57/maxW), y: 0.0))
        bezierPath.close()
        
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.shadowOffset = .zero
        shapeLayer.shadowColor = UIColor.lightGray.cgColor
        shapeLayer.shadowOpacity = 0.4
        
        if let old = caLayer {
            layer.replaceSublayer(old, with: shapeLayer)
            
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }
        
        caLayer = shapeLayer
    }
}

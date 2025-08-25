//
//  WheelView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import UIKit

class WheelView: UIView {
    
    private(set) var wheelLayer: WheelLayer?
    
    var preferences: SFWConfiguration.WheelPreferences? {
        didSet {
            wheelLayer = nil
            addWheelLayer()
        }
    }
    
    var slices: [Slice] = [] {
        didSet {
            wheelLayer?.slices = slices
            self.setNeedsDisplay()
        }
    }
    
    init(frame: CGRect, slices: [Slice], preferences: SFWConfiguration.WheelPreferences?) {
        self.preferences = preferences
        self.slices = slices
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.needsDisplayOnBoundsChange = true
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        addWheelLayer()
    }
    
    private func addWheelLayer() {
        for layer in self.layer.sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
        
        let frame = self.bounds
        wheelLayer = WheelLayer(frame: frame, slices: self.slices, preferences: preferences)
        
        self.layer.addSublayer(wheelLayer!)
        wheelLayer!.setNeedsDisplay()
    }
}

extension WheelView {
    
    func setupAutoLayout() {
        guard let superView = self.superview else { return }
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superView.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: 0).isActive = true
    }
}

//
//  SpinButton.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import UIKit

class SpinButton: UIButton {
    
    private var heightLC: NSLayoutConstraint?
    private var widthLC: NSLayoutConstraint?
    private var centerXLC: NSLayoutConstraint?
    private var centerYLC: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension SpinButton {
    
    func setupAutoLayout(with preferences: SFWConfiguration.SpinButtonPreferences?) {
        guard let superView = self.superview else { return }
        guard let preferences = preferences else { return }
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        heightLC = self.heightAnchor.constraint(equalToConstant: preferences.size.height)
        heightLC?.isActive = true
        
        widthLC = self.widthAnchor.constraint(equalToConstant: preferences.size.width)
        widthLC?.isActive = true
        
        centerXLC = self.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: preferences.horizontalOffset)
        centerXLC?.isActive = true
        
        centerYLC = self.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: preferences.verticalOffset)
        centerYLC?.isActive = true
        
        self.layoutIfNeeded()
    }
    
    private func diactivateConstrains() {
        heightLC?.isActive = false
        widthLC?.isActive = false
        centerXLC?.isActive = false
        centerYLC?.isActive = false
    }
    
    /// Updates spin button image
    /// - Parameter name: Image name from assets catalog
    func image(name: String?) {
        guard let imageName = name, imageName != "" else {
            self.setImage(nil, for: .normal)
            return
        }
        
        let image = UIImage(named: imageName)
        self.setImage(image, for: .normal)
    }
    
    func backgroundImage(name: String?) {
        guard let imageName = name, imageName != "" else {
            self.setBackgroundImage(nil, for: .normal)
            return
        }
        
        let image = UIImage(named: imageName)
        self.setBackgroundImage(image, for: .normal)
    }
    
    func configure(with preferences: SFWConfiguration.SpinButtonPreferences?) {
        self.backgroundColor = preferences?.backgroundColor
        self.layer.cornerRadius = preferences?.cornerRadius ?? 0
        self.layer.borderWidth = preferences?.cornerWidth ?? 0
        self.layer.borderColor = preferences?.cornerColor.cgColor
        self.setTitleColor(preferences?.textColor, for: .normal)
        self.setTitleColor(preferences?.disabledTextColor, for: .disabled)
        self.titleLabel?.font = preferences?.font
    }
}

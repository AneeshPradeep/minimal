//
//  Sub_NaviView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 14/6/24.
//

import UIKit

class Sub_NaviView: UIView {
    
    //MARK: - UIView
    let leftBtn = ButtonAnimation()
    let rightBtn = ButtonAnimation()
    
    //MARK: - Properties
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension Sub_NaviView {
    
    func setupViews(vc: SubscriptionVC) {
        clipsToBounds = true
        backgroundColor = .clear
        vc.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let bgColor = UIColor(hex: 0x000000, alpha: 0.2)
        let btnH: CGFloat = 40.0
        
        //TODO: - LeftBtn
        leftBtn.clipsToBounds = true
        leftBtn.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftBtn.tintColor = .white
        leftBtn.layer.cornerRadius = btnH/2
        leftBtn.backgroundColor = bgColor
        addSubview(leftBtn)
        leftBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - RightBtn
        rightBtn.clipsToBounds = true
        rightBtn.setImage(UIImage(named: "icon-info")?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightBtn.tintColor = .white
        rightBtn.layer.cornerRadius = btnH/2
        rightBtn.backgroundColor = bgColor
        addSubview(rightBtn)
        rightBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 44.0),
            topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            
            leftBtn.widthAnchor.constraint(equalToConstant: btnH),
            leftBtn.heightAnchor.constraint(equalToConstant: btnH),
            leftBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            
            rightBtn.widthAnchor.constraint(equalToConstant: btnH),
            rightBtn.heightAnchor.constraint(equalToConstant: btnH),
            rightBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
        ])
    }
}

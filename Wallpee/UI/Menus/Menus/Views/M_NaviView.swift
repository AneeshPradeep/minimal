//
//  M_NaviView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 20/6/24.
//

import UIKit

class M_NaviView: UIView {
    
    //MARK: - UIView
    let leftBtn = ButtonAnimation()
    let titleLbl = UILabel()
    
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

extension M_NaviView {
    
    func setupViews(vc: UIViewController) {
        clipsToBounds = true
        backgroundColor = .clear
        tag = 111
        vc.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let bgColor = UIColor(hex: 0x000000, alpha: 0.5)
        let btnH: CGFloat = 40.0
        
        //TODO: - LeftBtn
        leftBtn.clipsToBounds = true
        leftBtn.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftBtn.tintColor = .white
        leftBtn.layer.cornerRadius = btnH/2
        leftBtn.backgroundColor = bgColor
        addSubview(leftBtn)
        leftBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.montExtraBold, size: screenWidth * 0.055)
        titleLbl.textAlignment = .center
        addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            titleLbl.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

//
//  Ex_NaviView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit

class Ex_NaviView: UIView {
    
    //MARK: - UIView
    let leftBtn = ButtonAnimation()
    
    let subscribeView = ViewAnimation()
    let subscribeImageView = UIImageView()
    let subscribeLbl = UILabel()
    
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

extension Ex_NaviView {
    
    func setupViews(vc: ExploreVC) {
        clipsToBounds = true
        backgroundColor = .white
        vc.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let subH: CGFloat = 44.0
        
        //TODO: - LeftBtn
        leftBtn.clipsToBounds = true
        addSubview(leftBtn)
        leftBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SubscribeView
        subscribeView.backgroundColor = yellowColor
        subscribeView.clipsToBounds = true
        subscribeView.layer.cornerRadius = subH/2
        addSubview(subscribeView)
        subscribeView.translatesAutoresizingMaskIntoConstraints = false
        
        let subscribeWidthConstraint = subscribeView.widthAnchor.constraint(equalToConstant: 0.0)
        subscribeWidthConstraint.priority = .defaultLow
        subscribeWidthConstraint.isActive = true
        
        //TODO: - SubscribeImageView
        subscribeImageView.clipsToBounds = true
        subscribeImageView.image = UIImage(named: "icon-subscribe")
        subscribeImageView.contentMode = .scaleAspectFit
        subscribeImageView.translatesAutoresizingMaskIntoConstraints = false
        subscribeImageView.widthAnchor.constraint(equalToConstant: subH).isActive = true
        subscribeImageView.heightAnchor.constraint(equalToConstant: subH).isActive = true
        
        //TODO: - LeftBtn
        subscribeLbl.font = UIFont(name: FontName.montMedium, size: 18.0)
        subscribeLbl.text = "PRO".localized().uppercased()
        subscribeLbl.textColor = .black
        
        //TODO: - UIStackView
        let subscribeSV = createStackView(spacing: 0.0, distribution: .fill, axis: .horizontal, alignment: .center)
        subscribeSV.addArrangedSubview(subscribeImageView)
        subscribeSV.addArrangedSubview(subscribeLbl)
        subscribeView.addSubview(subscribeSV)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 44.0),
            topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            
            leftBtn.widthAnchor.constraint(equalToConstant: subH),
            leftBtn.heightAnchor.constraint(equalToConstant: subH),
            leftBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            
            subscribeView.heightAnchor.constraint(equalToConstant: subH),
            subscribeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            subscribeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            
            subscribeSV.centerYAnchor.constraint(equalTo: subscribeView.centerYAnchor),
            subscribeSV.leadingAnchor.constraint(greaterThanOrEqualTo: subscribeView.leadingAnchor, constant: 10.0),
            subscribeSV.trailingAnchor.constraint(lessThanOrEqualTo: subscribeView.trailingAnchor, constant: -21.0),
        ])
    }
    
    func updateMenuIcon() {
        let image = UIImage(named: MenuModel.showNotif() ? "icon-menu-notif" : "icon-menu")
        leftBtn.setImage(image, for: .normal)
    }
}

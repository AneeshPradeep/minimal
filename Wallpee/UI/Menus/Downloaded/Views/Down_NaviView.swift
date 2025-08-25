//
//  Down_NaviView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 20/6/24.
//

import UIKit

class Down_NaviView: UIView {
    
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

extension Down_NaviView {
    
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
        
        //TODO: - SubscribeView
        subscribeView.backgroundColor = yellowColor
        subscribeView.clipsToBounds = true
        subscribeView.layer.cornerRadius = btnH/2
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
        subscribeImageView.widthAnchor.constraint(equalToConstant: btnH).isActive = true
        subscribeImageView.heightAnchor.constraint(equalToConstant: btnH).isActive = true
        
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
            
            leftBtn.widthAnchor.constraint(equalToConstant: btnH),
            leftBtn.heightAnchor.constraint(equalToConstant: btnH),
            leftBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            
            subscribeView.heightAnchor.constraint(equalToConstant: btnH),
            subscribeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            subscribeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            
            subscribeSV.centerYAnchor.constraint(equalTo: subscribeView.centerYAnchor),
            subscribeSV.leadingAnchor.constraint(greaterThanOrEqualTo: subscribeView.leadingAnchor, constant: 10.0),
            subscribeSV.trailingAnchor.constraint(lessThanOrEqualTo: subscribeView.trailingAnchor, constant: -21.0),
        ])
    }
}

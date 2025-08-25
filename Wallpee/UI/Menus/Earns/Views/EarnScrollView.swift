//
//  EarnScrollView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 21/6/24.
//

import UIKit

class EarnScrollView: UIScrollView {
    
    //MARK: - UIView
    let contentView = EarnContentView()
    
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

extension EarnScrollView {
    
    func setupViews(vc: EarnVC) {
        clipsToBounds = true
        backgroundColor = .clear
        contentInset.top = 22.0
        showsVerticalScrollIndicator = false
        vc.view.insertSubview(self, belowSubview: vc.naviView)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ContainerView
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0.0)
        contentHeightConstraint.priority = .defaultLow
        contentHeightConstraint.isActive = true
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: vc.naviView.topAnchor),
            leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.widthAnchor.constraint(equalToConstant: vc.view.frame.width),
        ])
    }
}

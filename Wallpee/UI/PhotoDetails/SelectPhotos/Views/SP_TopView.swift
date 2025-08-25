//
//  SP_TopView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 25/6/24.
//

import UIKit

class SP_TopView: UIView {
    
    //MARK: - UIView
    let darkView = UIView()
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension SP_TopView {
    
    func setupViews(vc: UIViewController) {
        clipsToBounds = true
        backgroundColor = .clear
        vc.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let height: CGFloat = 50.0
        
        //TODO: - DarkView
        darkView.clipsToBounds = true
        darkView.backgroundColor = .white
        darkView.layer.cornerRadius = 3.0
        addSubview(darkView)
        darkView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: vc.view.topAnchor),
            leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: height),
            
            darkView.widthAnchor.constraint(equalToConstant: screenWidth*0.15),
            darkView.heightAnchor.constraint(equalToConstant: 6.0),
            darkView.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
            darkView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}

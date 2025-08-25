//
//  GP_TopView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 13/6/24.
//

import UIKit

class GP_TopView: UIView {
    
    //MARK: - UIView
    let darkView = UIView()
    
    let titleLbl = UILabel()
    
    let separatorView = UIView()
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension GP_TopView {
    
    func setupViews(vc: GetPhotoVC) {
        clipsToBounds = true
        backgroundColor = .clear
        vc.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let sp: CGFloat = 12*3
        let height: CGFloat = sp + 6 + 44 + 1
        
        //TODO: - DarkView
        darkView.clipsToBounds = true
        darkView.backgroundColor = .white
        darkView.layer.cornerRadius = 3.0
        darkView.translatesAutoresizingMaskIntoConstraints = false
        darkView.widthAnchor.constraint(equalToConstant: screenWidth*0.15).isActive = true
        darkView.heightAnchor.constraint(equalToConstant: 6.0).isActive = true
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.montBold, size: 25.0)
        titleLbl.textColor = .white
        titleLbl.text = "Download".localized().uppercased()
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        titleLbl.widthAnchor.constraint(equalToConstant: screenWidth*0.9).isActive = true
        
        //TODO: - SeparatorView
        separatorView.clipsToBounds = true
        separatorView.backgroundColor = .lightGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.widthAnchor.constraint(equalToConstant: screenWidth*0.9).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 12.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(darkView)
        stackView.addArrangedSubview(titleLbl)
        stackView.addArrangedSubview(separatorView)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: vc.view.topAnchor),
            leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: height),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

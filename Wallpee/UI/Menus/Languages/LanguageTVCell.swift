//
//  LanguageTVCell.swift
//  Wallpee
//
//  Created by Thanh Hoang on 20/6/24.
//

import UIKit

class LanguageTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "LanguageTVCell"
    
    let nameLbl = UILabel()
    
    let outerView = UIView()
    let innerView = UIView()
    
    private let outerW: CGFloat = 30.0
    private var innerW: CGFloat {
        return outerW*0.8
    }
    
    var isSelect: Bool = false {
        didSet {
            let outerGr = createGradient(bounds: CGRect(x: 0.0, y: 0.0, width: outerW, height: outerW))
            let innerGr = createGradient(bounds: CGRect(x: 0.0, y: 0.0, width: innerW, height: innerW))
            
            let outerColor = convertGradientToColor(gradient: outerGr)
            let innerColor = convertGradientToColor(gradient: innerGr)
            
            if isSelect {
                outerView.backgroundColor = .white
                outerView.layer.borderColor = outerColor.cgColor
                
                innerView.backgroundColor = innerColor
                innerView.layer.borderColor = UIColor.white.cgColor
                
            } else {
                outerView.backgroundColor = .clear
                outerView.layer.borderColor = UIColor.lightGray.cgColor
                
                innerView.backgroundColor = .clear
                innerView.layer.borderColor = UIColor.clear.cgColor
            }
            
            nameLbl.font = UIFont(name: isSelect ? FontName.montBold : FontName.montRegular, size: screenWidth * 0.05)
        }
    }
    
    //MARK: - Initializes
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Configure

extension LanguageTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.montRegular, size: screenWidth * 0.05)
        nameLbl.textColor = .black
        contentView.addSubview(nameLbl)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - OuterView
        outerView.clipsToBounds = true
        outerView.layer.cornerRadius = outerW/2
        outerView.layer.borderWidth = 2.0
        contentView.addSubview(outerView)
        outerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - InnerView
        innerView.clipsToBounds = true
        innerView.layer.cornerRadius = innerW/2
        innerView.layer.borderWidth = 2.0
        outerView.addSubview(innerView)
        innerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            nameLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            
            outerView.widthAnchor.constraint(equalToConstant: outerW),
            outerView.heightAnchor.constraint(equalToConstant: outerW),
            outerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            outerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            
            innerView.centerXAnchor.constraint(equalTo: outerView.centerXAnchor),
            innerView.centerYAnchor.constraint(equalTo: outerView.centerYAnchor),
            innerView.widthAnchor.constraint(equalToConstant: innerW),
            innerView.heightAnchor.constraint(equalToConstant: innerW),
        ])
    }
}

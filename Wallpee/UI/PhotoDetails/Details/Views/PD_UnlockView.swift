//
//  PD_UnlockView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 15/6/24.
//

import UIKit

class PD_UnlockView: UIView {
    
    //MARK: - UIView
    let unlockView = ViewAnimation()
    
    let unlockLbl = UILabel()
    let iconImageView = UIImageView()
    let priceLbl = UILabel()
    
    let desLbl = UILabel()
    
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

extension PD_UnlockView {
    
    func setupViews(parentView: UIView) {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .black.withAlphaComponent(0.4)
        parentView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let btnW: CGFloat = screenWidth * 0.5
        let btnH: CGFloat = 50.0
        let iconH: CGFloat = btnH/2
        
        //TODO: - UnlockView
        unlockView.clipsToBounds = true
        unlockView.layer.cornerRadius = btnH/2
        unlockView.backgroundColor = yellowColor
        addSubview(unlockView)
        unlockView.translatesAutoresizingMaskIntoConstraints = false
        
        let unlockWidthConstraint = unlockView.widthAnchor.constraint(equalToConstant: btnW)
        unlockWidthConstraint.priority = .defaultLow
        unlockWidthConstraint.isActive = true
        
        //TODO: - UnlockLbl
        unlockLbl.font = UIFont(name: FontName.montMedium, size: 20.0)
        unlockLbl.textColor = .black
        unlockLbl.textAlignment = .center
        unlockLbl.text = "Unlock for".localized()
        
        //TODO: - UnlockImageView
        iconImageView.image = UIImage(named: "icon-coin")
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: iconH).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: iconH).isActive = true
        
        //TODO: - PriceLbl
        priceLbl.font = UIFont(name: FontName.montMedium, size: 20.0)
        priceLbl.textColor = .black
        
        //TODO: - UIStackView
        let unlockSV = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        unlockSV.addArrangedSubview(unlockLbl)
        unlockSV.addArrangedSubview(iconImageView)
        unlockSV.addArrangedSubview(priceLbl)
        unlockView.addSubview(unlockSV)
        
        //TODO: - DesLbl
        desLbl.font = UIFont(name: FontName.montSemiBold, size: 18.0)
        desLbl.textColor = .white
        desLbl.text = "✓ No Ads".localized() + "\n" + "✓ Download any time".localized()
        desLbl.textAlignment = .center
        desLbl.numberOfLines = 2
        addSubview(desLbl)
        desLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentView.topAnchor),
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            
            unlockView.heightAnchor.constraint(equalToConstant: btnH),
            unlockView.centerXAnchor.constraint(equalTo: centerXAnchor),
            unlockView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            unlockSV.centerXAnchor.constraint(equalTo: unlockView.centerXAnchor),
            unlockSV.centerYAnchor.constraint(equalTo: unlockView.centerYAnchor),
            unlockSV.leadingAnchor.constraint(greaterThanOrEqualTo: unlockView.leadingAnchor, constant: 20.0),
            unlockSV.trailingAnchor.constraint(lessThanOrEqualTo: unlockView.trailingAnchor, constant: -20.0),
            
            desLbl.centerXAnchor.constraint(equalTo: centerXAnchor),
            desLbl.bottomAnchor.constraint(equalTo: unlockView.topAnchor, constant: -20.0),
        ])
    }
}

//MARK: - Update UI

extension PD_UnlockView {
    
    func updateUI(photo: PhotoModel?) {
        if !appDL.isPremium {
            if let photo = photo {
                let coin = photo.src.coin ?? 0
                
                isHidden = coin == 0
                priceLbl.text = "\(coin)"
            }
        }
    }
}

//
//  PD_NaviView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit

class PD_NaviView: UIView {
    
    //MARK: - UIView
    let leftBtn = ButtonAnimation()
    
    let coinView = ViewAnimation()
    let coinBlurView = UIVisualEffectView()
    let coinImageView = UIImageView()
    let coinLbl = UILabel()
    
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

extension PD_NaviView {
    
    func setupViews(vc: PhotoDetailVC) {
        clipsToBounds = true
        backgroundColor = .clear
        tag = 111
        vc.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let bgColor = UIColor(hex: 0x000000, alpha: 0.5)
        let btnH: CGFloat = 40.0
        let coinH: CGFloat = btnH/2
        
        //TODO: - LeftBtn
        leftBtn.clipsToBounds = true
        leftBtn.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftBtn.tintColor = .white
        leftBtn.layer.cornerRadius = btnH/2
        leftBtn.backgroundColor = bgColor
        addSubview(leftBtn)
        leftBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - RightView
        coinView.clipsToBounds = true
        coinView.layer.cornerRadius = btnH/2
        coinView.backgroundColor = bgColor
        addSubview(coinView)
        coinView.translatesAutoresizingMaskIntoConstraints = false
        
        let coinWidthConstraint = coinView.widthAnchor.constraint(equalToConstant: btnH*2)
        coinWidthConstraint.priority = .defaultLow
        coinWidthConstraint.isActive = true
        
        //TODO: - CoinBlurView
        coinBlurView.clipsToBounds = true
        coinBlurView.layer.cornerRadius = btnH/2
        coinBlurView.layer.borderWidth = 1.5
        coinBlurView.layer.borderColor = UIColor.white.cgColor
        coinBlurView.effect = UIBlurEffect(style: .regular)
        coinView.addSubview(coinBlurView)
        coinBlurView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - coinImageView
        coinImageView.image = UIImage(named: "icon-coin")
        coinImageView.clipsToBounds = true
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinImageView.widthAnchor.constraint(equalToConstant: coinH).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: coinH).isActive = true
        
        //TODO: - CoinLbl
        coinLbl.font = UIFont(name: FontName.montSemiBold, size: 18.0)
        coinLbl.textColor = .white
        coinLbl.textAlignment = .center
        
        //TODO: - UIStackView
        let coinSV = createStackView(spacing: 8.0, distribution: .fill, axis: .horizontal, alignment: .center)
        coinSV.addArrangedSubview(coinImageView)
        coinSV.addArrangedSubview(coinLbl)
        coinView.addSubview(coinSV)
        
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
            
            coinView.heightAnchor.constraint(equalToConstant: btnH),
            coinView.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            
            coinBlurView.topAnchor.constraint(equalTo: coinView.topAnchor),
            coinBlurView.leadingAnchor.constraint(equalTo: coinView.leadingAnchor),
            coinBlurView.trailingAnchor.constraint(equalTo: coinView.trailingAnchor),
            coinBlurView.bottomAnchor.constraint(equalTo: coinView.bottomAnchor),
            
            coinSV.leadingAnchor.constraint(greaterThanOrEqualTo: coinView.leadingAnchor, constant: 20.0),
            coinSV.trailingAnchor.constraint(lessThanOrEqualTo: coinView.trailingAnchor, constant: -20.0),
            coinSV.centerXAnchor.constraint(equalTo: coinView.centerXAnchor),
            coinSV.centerYAnchor.constraint(equalTo: coinView.centerYAnchor),
        ])
    }
}

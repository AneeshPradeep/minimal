//
//  Sub_ContentView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 14/6/24.
//

import UIKit

class Sub_ContentView: UIView {
    
    //MARK: - UIView
    let logoImageView = UIImageView()
    
    let proLbl = UILabel()
    
    let monthlyView = SubscriptionView()
    let annualView = SubscriptionView()
    let unlimitedView = SubscriptionView()
    
    let buyBtn = ButtonAnimation()
    let restoreBtn = ButtonAnimation()
    let privacyBtn = ButtonAnimation()
    let termBtn = ButtonAnimation()
    
    let sepView_1 = UIView()
    let sepView_2 = UIView()
    
    let autoRenewLbl = UILabel()
    
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

extension Sub_ContentView {
    
    func setupViews(vc: SubscriptionVC) {
        clipsToBounds = true
        backgroundColor = .clear
        vc.view.insertSubview(self, belowSubview: vc.naviView)
        translatesAutoresizingMaskIntoConstraints = false
        
        let logoW: CGFloat = screenWidth * 0.5
        let logoH: CGFloat = logoW * (200/320)
        
        let buyW: CGFloat = screenWidth * 0.9
        let buyH: CGFloat = 50.0
        
        //TODO: - LogoImageView
        logoImageView.clipsToBounds = true
        logoImageView.image = UIImage(named: "logo-")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: logoW).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: logoH).isActive = true
        
        //TODO: - ProLbl
        let subsAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.montBold, size: 18.0)!,
            .foregroundColor: UIColor.black
        ]
        let subsAtt = NSAttributedString(string: "Subscribe to".localized() + " ", attributes: subsAttr)
        
        let proAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.montBold, size: 18.0)!,
            .foregroundColor: UIColor(hex: 0xF49000)
        ]
        let proAtt = NSAttributedString(string: "PRO".localized() + "\n", attributes: proAttr)
        
        let checkAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.montSemiBold, size: 13.0)!,
            .foregroundColor: UIColor(hex: 0xF49000)
        ]
        let checkAtt = NSAttributedString(string: "\n✓ ", attributes: checkAttr)
        
        let adAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.montSemiBold, size: 13.0)!,
            .foregroundColor: UIColor.black
        ]
        let adAtt_1 = NSAttributedString(string: "No Ads".localized(), attributes: adAttr)
        let adAtt_2 = NSAttributedString(string: "Unlock all photos".localized(), attributes: adAttr)
        let adAtt_3 = NSAttributedString(string: "Download all wallpapers".localized(), attributes: adAttr)
        
        let attr = NSMutableAttributedString()
        attr.append(subsAtt)
        attr.append(proAtt)
        attr.append(checkAtt)
        attr.append(adAtt_1)
        attr.append(checkAtt)
        attr.append(adAtt_2)
        attr.append(checkAtt)
        attr.append(adAtt_3)
        
        proLbl.font = UIFont(name: FontName.montSemiBold, size: 18.0)
        proLbl.textColor = .black
        proLbl.attributedText = attr
        proLbl.textAlignment = .center
        proLbl.numberOfLines = 0
        
        //TODO: - AutoRenewLbl
        autoRenewLbl.font = UIFont(name: FontName.montRegular, size: 12.0)
        autoRenewLbl.textColor = .darkGray
        autoRenewLbl.text = "The subscription will be renewed automatically.".localized() + "\n" + "You can cancel anytime.".localized()
        autoRenewLbl.textAlignment = .center
        autoRenewLbl.numberOfLines = 2
        autoRenewLbl.translatesAutoresizingMaskIntoConstraints = false
        autoRenewLbl.widthAnchor.constraint(equalToConstant: screenWidth*0.9).isActive = true
        
        //TODO: - BuyBtn
        buyBtn.clipsToBounds = true
        buyBtn.layer.cornerRadius = buyH/2
        buyBtn.titleLabel?.font = UIFont(name: FontName.montBold, size: 16.0)
        buyBtn.setTitle("Buy Subscription".localized().uppercased(), for: .normal)
        buyBtn.setTitleColor(.white, for: .normal)
        buyBtn.translatesAutoresizingMaskIntoConstraints = false
        buyBtn.widthAnchor.constraint(equalToConstant: buyW).isActive = true
        buyBtn.heightAnchor.constraint(equalToConstant: buyH).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 15.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(proLbl)
        stackView.setCustomSpacing(20.0, after: proLbl)
        stackView.addArrangedSubview(monthlyView)
        stackView.addArrangedSubview(annualView)
        stackView.addArrangedSubview(unlimitedView)
        stackView.setCustomSpacing(20.0, after: unlimitedView)
        stackView.addArrangedSubview(buyBtn)
        stackView.setCustomSpacing(5.0, after: buyBtn)
        stackView.addArrangedSubview(autoRenewLbl)
        addSubview(stackView)
        
        let buyGr = createGradient(bounds: CGRect(x: 0.0, y: 0.0, width: buyW, height: buyH))
        let buyColor = convertGradientToColor(gradient: buyGr)
        buyBtn.backgroundColor = buyColor
        
        //TODO: - RestoreBtn
        let resAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.montSemiBold, size: 12.0)!,
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let restoreAtt = NSMutableAttributedString(string: "Restore Subscription".localized(), attributes: resAttr)
        let privacyAtt = NSMutableAttributedString(string: "Privacy Policy".localized(), attributes: resAttr)
        let termAtt = NSMutableAttributedString(string: "Term Of Use".localized(), attributes: resAttr)
        
        restoreBtn.setAttributedTitle(restoreAtt, for: .normal)
        
        //TODO: - PrivacyBtn
        privacyBtn.setAttributedTitle(privacyAtt, for: .normal)
        
        //TODO: - TermBtn
        termBtn.setAttributedTitle(termAtt, for: .normal)
        
        //TODO: - SepView_1
        sepView_1.clipsToBounds = true
        sepView_1.backgroundColor = .black
        sepView_1.translatesAutoresizingMaskIntoConstraints = false
        sepView_1.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
        sepView_1.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        
        //TODO: - SepView_2
        sepView_2.clipsToBounds = true
        sepView_2.backgroundColor = .black
        sepView_2.translatesAutoresizingMaskIntoConstraints = false
        sepView_2.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
        sepView_2.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        
        //TODO: - UIStackView
        let resSV = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .center)
        resSV.addArrangedSubview(restoreBtn)
        resSV.addArrangedSubview(sepView_1)
        resSV.addArrangedSubview(privacyBtn)
        resSV.addArrangedSubview(sepView_2)
        resSV.addArrangedSubview(termBtn)
        addSubview(resSV)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: vc.naviView.topAnchor),
            leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            resSV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(bottomPadding + (appDL.isIPhoneX ? 0:10))),
            resSV.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

//MARK: - Update UI

extension Sub_ContentView {
    
    func selectedView(index: Int, items: [SubscribeModel]) {
        monthlyView.selectedView(isSelect: index == 0)
        annualView.selectedView(isSelect: index == 1)
        unlimitedView.selectedView(isSelect: index == 2)
        
        unlimitedView.bestValueLbl.isHidden = index != 2
        
        enableBuyButton(enable: !appDL.isPremium)
    }
    
    func enableBuyButton(enable: Bool) {
        buyBtn.isEnabled = enable
        buyBtn.alpha = buyBtn.isEnabled ? 1.0 : 0.4
    }
}

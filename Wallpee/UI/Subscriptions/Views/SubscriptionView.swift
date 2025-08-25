//
//  SubscriptionView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 14/6/24.
//

import UIKit

class SubscriptionView: ViewAnimation {
    
    //MARK: - UIView
    let titleLbl = UILabel()
    let priceLbl = UILabel()
    
    let subtitleLbl = UILabel()
    
    let bestValueLbl = UILabel()
    
    var priceWidthConstraint: NSLayoutConstraint!
    var priceHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    private var width: CGFloat {
        return screenWidth * 0.9
    }
    private var height: CGFloat {
        return width * (200/1013)
    }
    private var cornerRadius: CGFloat {
        return height*0.2
    }
    private var borderWidth: CGFloat {
        return 3.0
    }
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension SubscriptionView {
    
    func setupViews() {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        translatesAutoresizingMaskIntoConstraints = false
        
        let priceFont = UIFont(name: FontName.montBold, size: 15.0)!
        let priceRect = "$9.99".estimatedTextRect(fontN: priceFont.fontName, fontS: priceFont.pointSize)
        let priceW = priceRect.width + 30
        let priceH = priceRect.height + 10
        
        //TODO: - TitleLbl
        titleLbl.font = priceFont
        titleLbl.textColor = .black
        addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - PriceLbl
        priceLbl.font = priceFont
        priceLbl.clipsToBounds = true
        priceLbl.layer.cornerRadius = priceH/2
        priceLbl.textAlignment = .center
        addSubview(priceLbl)
        priceLbl.translatesAutoresizingMaskIntoConstraints = false
        
        priceWidthConstraint = priceLbl.widthAnchor.constraint(equalToConstant: priceW)
        priceWidthConstraint.isActive = true
        
        priceHeightConstraint = priceLbl.heightAnchor.constraint(equalToConstant: priceH)
        priceHeightConstraint.isActive = true
        
        //TODO: - SubtitleLbl
        subtitleLbl.isHidden = true
        subtitleLbl.font = UIFont(name: FontName.montMediumItalic, size: 12.0)
        subtitleLbl.textColor = .gray
        addSubview(subtitleLbl)
        subtitleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - BestValueLbl
        let bestFont = UIFont(name: FontName.montMedium, size: 8.0)!
        let bestTxt = "Best Value".localized()
        let bestR = bestTxt.estimatedTextRect(fontN: bestFont.fontName, fontS: bestFont.pointSize)
        let bestW = bestR.width + 20
        let bestH = bestR.height + 10
        
        bestValueLbl.font = bestFont
        bestValueLbl.text = "Best Value".localized()
        bestValueLbl.textAlignment = .center
        bestValueLbl.textColor = .white
        bestValueLbl.backgroundColor = UIColor(hex: 0xF49000)
        bestValueLbl.clipsToBounds = true
        bestValueLbl.layer.cornerRadius = cornerRadius-borderWidth
        bestValueLbl.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        bestValueLbl.isHidden = true
        addSubview(bestValueLbl)
        bestValueLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height),
            
            titleLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
            
            priceLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.0),
            
            subtitleLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            subtitleLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 2.0),
            
            bestValueLbl.widthAnchor.constraint(equalToConstant: bestW),
            bestValueLbl.heightAnchor.constraint(equalToConstant: bestH),
            bestValueLbl.topAnchor.constraint(equalTo: topAnchor, constant: borderWidth),
            bestValueLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -borderWidth),
        ])
    }
}

//MARK: - Update UI

extension SubscriptionView {
    
    func updateUI(txt: String, priceTxt: String) {
        backgroundColor = UIColor(hex: 0xF2F2F2)
        layer.borderColor = UIColor(hex: 0xDEDEDE).cgColor
        
        titleLbl.text = txt.localized()
        
        var p = priceTxt
        
        if priceTxt == "0" {
            p = "FREE".localized().uppercased()
        }
        
        priceLbl.text = p
        priceLbl.textColor = .black
        priceLbl.backgroundColor = .clear
        
        let priceFont = UIFont(name: FontName.montBold, size: 15.0)!
        let priceRect = p.estimatedTextRect(fontN: priceFont.fontName, fontS: priceFont.pointSize)
        let priceW = priceRect.width + 30
        let priceH = priceRect.height + 10
        
        priceWidthConstraint.constant = priceW
        priceHeightConstraint.constant = priceH
        
        priceLbl.layer.cornerRadius = priceH/2
    }
    
    func selectedView(isSelect: Bool) {
        let rect = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        let borderPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        
        let maskShape = CAShapeLayer()
        maskShape.path = borderPath
        maskShape.fillColor = UIColor.clear.cgColor
        maskShape.strokeColor = UIColor.white.cgColor
        maskShape.lineWidth = borderWidth*2
        
        let gr = createGradient(bounds: rect, firstColor: UIColor(hex: 0xF49000), lastColor: UIColor(hex: 0xFFCF00))
        gr.mask = maskShape
        
        backgroundColor = isSelect ? yellowColor : UIColor(hex: 0xF2F2F2)
        layer.borderColor = (isSelect ? UIColor.clear : UIColor(hex: 0xDEDEDE)).cgColor
        
        layer.sublayers?
            .filter({ $0 is CAGradientLayer })
            .forEach({ $0.removeFromSuperlayer() })
        
        if isSelect {
            layer.addSublayer(gr)
        }
        
        priceLbl.textColor = isSelect ? UIColor(hex: 0xF49000) : .black
        priceLbl.backgroundColor = isSelect ? .white : .clear
    }
}

//
//  EarnContentCVCell.swift
//  Wallpee
//
//  Created by Thanh Hoang on 20/6/24.
//

import UIKit

class EarnContentCVCell: UICollectionViewCell {
    
    //MARK: - UIView
    let containerView = UIView()
    let bgImageView = UIImageView()
    
    let coinLbl = UILabel()
    let titleLbl = UILabel()
    
    //MARK: - Properties
    static let id = "EarnContentCVCell"
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        configreCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var isTouch = false {
        didSet {
            updateAnimation(self, isEvent: isTouch, alpha: 0.8)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !isTouch { isTouch = true }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isTouch { isTouch = false }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isTouch = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        if let parent = superview {
            isTouch = frame.contains(touch.location(in: parent))
        }
    }
}

//MARK: - Configure

extension EarnContentCVCell {
    
    private func configreCell() {
        clipsToBounds = true
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - BGImageView
        bgImageView.clipsToBounds = true
        bgImageView.contentMode = .scaleAspectFit
        containerView.addSubview(bgImageView)
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CoinLbl
        coinLbl.font = UIFont(name: FontName.montBold, size: 15.0)
        coinLbl.textColor = .white
        coinLbl.textAlignment = .center
        coinLbl.adjustsFontSizeToFitWidth = true
        containerView.addSubview(coinLbl)
        coinLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.montBold, size: 14.0)
        titleLbl.textColor = .white
        titleLbl.textAlignment = .center
        titleLbl.adjustsFontSizeToFitWidth = true
        containerView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        let sp = (EarnVC.itemW - (EarnVC.itemW * (170/200))) / 4
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            bgImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            coinLbl.widthAnchor.constraint(equalToConstant: EarnVC.itemW * (140/200)),
            coinLbl.heightAnchor.constraint(equalTo: coinLbl.widthAnchor, multiplier: 50/140),
            coinLbl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            coinLbl.centerYAnchor.constraint(equalTo: containerView.topAnchor, constant: EarnVC.itemW-sp),
            
            titleLbl.widthAnchor.constraint(equalToConstant: EarnVC.itemW * 0.9),
            titleLbl.heightAnchor.constraint(equalToConstant: EarnVC.itemH * (80/298)),
            titleLbl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLbl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}

//MARK: - Update UI

extension EarnContentCVCell {
    
    func updateUI(item: W_DailyRewards) {
        coinLbl.text = "+\(item.coin.intValue)"
        bgImageView.image = UIImage(named: "reward-notYet")
        
        let hour = Calendar.current.component(.hour, from: Date())
        
        let f = createDateFormatter()
        f.dateFormat = "yyyyMMdd"
        
        let time = f.string(from: Date())
        let isTime = item.createdTime == time
        
        let currentTime = (isTime && (hour >= 7)) || (isTime && KeyManager.shared.getDailyRewards() == false)
        
        titleLbl.text = item.createdTime == time ? "Today".localized().capitalized : item.title.localized()
        coinLbl.isHidden = item.earn
        
        if item.earn {
            bgImageView.image = UIImage(named: "reward-earned")
        }
        
        if currentTime && !item.earn {
            bgImageView.image = UIImage(named: "reward-earn")
        }
        
        isUserInteractionEnabled = (currentTime && (item.earn == false))
    }
}

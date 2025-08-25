//
//  Fav_ContentCVCell.swift
//  Wallpee
//
//  Created by Thanh Hoang on 16/6/24.
//

import UIKit

class Fav_ContentCVCell: UICollectionViewCell {
    
    //MARK: - UIView
    let containerView = UIView()
    let coverImageView = UIImageView()
    
    let coinView = UIView()
    let coinEffectView = UIVisualEffectView()
    let coinImageView = UIImageView()
    let coinLbl = UILabel()
    
    //MARK: - Properties
    static let id = "Fav_ContentCVCell"
    
    var indexPath: IndexPath?
    var image: UIImage?
    
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

extension Fav_ContentCVCell {
    
    private func configreCell() {
        clipsToBounds = true
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        let bgH: CGFloat = PhotoLayout.itemW * 0.25
        let bgW: CGFloat = bgH * 2
        
        let coinH: CGFloat = bgH * 0.47
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let gr = createGradient(
            bounds: CGRect(x: 0.0, y: 0.0, width: PhotoLayout.itemW, height: PhotoLayout.itemH),
            firstColor: UIColor(hex: 0xF2F2F2),
            lastColor: UIColor(hex: 0xAAAAAA),
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint: CGPoint(x: 0.5, y: 1.0))
        
        containerView.layer.addSublayer(gr)
        
        //TODO: - CoverImageView
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        containerView.addSubview(coverImageView)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - FavouriteView
        coinView.isHidden = true
        coinView.clipsToBounds = true
        coinView.backgroundColor = .clear
        coinView.layer.cornerRadius = bgH/2
        coinView.layer.borderWidth = 1.0
        coinView.layer.borderColor = UIColor.white.cgColor
        contentView.addSubview(coinView)
        coinView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - FavouriteEffectView
        coinEffectView.clipsToBounds = true
        coinEffectView.effect = UIBlurEffect(style: .regular)
        coinEffectView.layer.cornerRadius = bgH/2
        coinView.addSubview(coinEffectView)
        coinEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CoinImageView
        coinImageView.clipsToBounds = true
        coinImageView.image = UIImage(named: "icon-coin")
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinImageView.widthAnchor.constraint(equalToConstant: coinH).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: coinH).isActive = true
        
        //TODO: - CoinLbl
        coinLbl.font = UIFont(name: FontName.montBold, size: 15.0)
        coinLbl.textColor = .white
        coinLbl.textAlignment = .center
        
        //TODO: - UIStackView
        let coinSV = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .center)
        coinSV.addArrangedSubview(coinImageView)
        coinSV.addArrangedSubview(coinLbl)
        coinView.addSubview(coinSV)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            coinView.widthAnchor.constraint(equalToConstant: bgW),
            coinView.heightAnchor.constraint(equalToConstant: bgH),
            coinView.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor),
            coinView.centerYAnchor.constraint(equalTo: coverImageView.centerYAnchor),
            
            coinEffectView.widthAnchor.constraint(equalToConstant: bgW),
            coinEffectView.heightAnchor.constraint(equalToConstant: bgH),
            coinEffectView.centerXAnchor.constraint(equalTo: coinView.centerXAnchor),
            coinEffectView.centerYAnchor.constraint(equalTo: coinView.centerYAnchor),
            
            coinSV.centerXAnchor.constraint(equalTo: coinView.centerXAnchor),
            coinSV.centerYAnchor.constraint(equalTo: coinView.centerYAnchor),
        ])
    }
}

//MARK: - Update UI

extension Fav_ContentCVCell {
    
    func updateUI(photo: PhotoModel, indexPath: IndexPath) {
        coverImageView.image = nil
        
        DownloadImage.shared.downloadImage(link: photo.src.medium) { image in
            DispatchQueue.main.async {
                if self.indexPath == indexPath {
                    self.coverImageView.image = image
                    self.image = image
                }
            }
        }
        
        coinLbl.text = "\(photo.src.coin ?? 0)"
        
        coinView.isHidden = true
        
        if !appDL.isPremium {
            coinView.isHidden = (photo.src.coin ?? 0) == 0
        }
    }
}

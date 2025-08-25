//
//  PD_BottomView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit

class PD_BottomView: UIView {
    
    //MARK: - UIView
    let blurView = UIVisualEffectView()
    let barView = UIView()
    
    let favView = UIView()
    let favBtn = ButtonAnimation()
    
    let downloadView = ViewAnimation()
    let coinImageView = UIImageView()
    let coinLbl = UILabel()
    
    let shareView = UIView()
    let shareBtn = ButtonAnimation()
    
    let moreView = UIView()
    let moreBtn = ButtonAnimation()
    
    //MARK: - Properties
    private var bottomHeight: CGFloat {
        return appDL.isIPhoneX ? 70.0 : 60.0
    }
    private var btnH: CGFloat {
        return bottomHeight - 20
    }
    
    private var downloadW: CGFloat {
        return 150.0
    }
    private var edge: CGFloat {
        return (bottomHeight - btnH) / 2
    }
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension PD_BottomView {
    
    func setupViews(vc: PhotoDetailVC) {
        clipsToBounds = true
        backgroundColor = .clear
        tag = 222
        vc.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - EffectView
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = 0.9
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = bottomHeight/2
        blurView.layer.borderWidth = 1.5
        blurView.layer.borderColor = UIColor.lightGray.cgColor
        addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - BarView
        barView.clipsToBounds = true
        barView.backgroundColor = .clear
        barView.layer.cornerRadius = bottomHeight/2
        addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - FavView
        setupSubview(subview: favView, btn: favBtn, image: UIImage(named: "icon-detailFav"))
        setupShadow(subview: favView)
        
        //TODO: - ShareView
        setupSubview(subview: shareView, btn: shareBtn, image: UIImage(named: "icon-detailShare"))
        setupShadow(subview: shareView)
        
        //TODO: - DownloadView
        downloadView.clipsToBounds = true
        downloadView.backgroundColor = yellowColor
        downloadView.layer.cornerRadius = btnH/2
        downloadView.translatesAutoresizingMaskIntoConstraints = false
        downloadView.widthAnchor.constraint(equalToConstant: downloadW).isActive = true
        downloadView.heightAnchor.constraint(equalToConstant: btnH).isActive = true
        
        setupShadow(subview: downloadView)
        
        //TODO: - MoreView
        setupSubview(subview: moreView, btn: moreBtn, image: UIImage(named: "icon-detailMore"))
        setupShadow(subview: moreView)
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: edge, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(favView)
        stackView.addArrangedSubview(shareView)
        stackView.addArrangedSubview(downloadView)
        stackView.addArrangedSubview(moreView)
        barView.addSubview(stackView)
        
        //TODO: - CoinImageView
        coinImageView.isHidden = true
        coinImageView.clipsToBounds = true
        coinImageView.image = UIImage(named: "icon-coin")
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinImageView.widthAnchor.constraint(equalToConstant: btnH*0.45).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: btnH*0.45).isActive = true
        
        //TODO: - CoinLbl
        coinLbl.font = UIFont(name: FontName.montBold, size: 19.0)
        coinLbl.text = "GET".localized().uppercased()
        coinLbl.textColor = .black
        coinLbl.addCharacterSpacing(kernValue: 2.5)
        
        //TODO: - UIStackView
        let getSV = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .center)
        getSV.addArrangedSubview(coinImageView)
        getSV.addArrangedSubview(coinLbl)
        downloadView.addSubview(getSV)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: bottomHeight),
            bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor),
            leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            
            blurView.widthAnchor.constraint(equalToConstant: edge*5 + btnH*3 + downloadW),
            blurView.heightAnchor.constraint(equalToConstant: bottomHeight),
            blurView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            barView.topAnchor.constraint(equalTo: blurView.topAnchor),
            barView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
            barView.trailingAnchor.constraint(equalTo: blurView.trailingAnchor),
            barView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: barView.topAnchor, constant: edge),
            stackView.leadingAnchor.constraint(equalTo: barView.leadingAnchor, constant: edge),
            
            getSV.centerXAnchor.constraint(equalTo: downloadView.centerXAnchor),
            getSV.centerYAnchor.constraint(equalTo: downloadView.centerYAnchor),
        ])
    }
    
    private func setupSubview(subview: UIView, btn: ButtonAnimation, image: UIImage?) {
        subview.clipsToBounds = true
        subview.backgroundColor = .white
        subview.layer.cornerRadius = btnH/2
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.widthAnchor.constraint(equalToConstant: btnH).isActive = true
        subview.heightAnchor.constraint(equalToConstant: btnH).isActive = true
        
        btn.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .black
        btn.clipsToBounds = true
        btn.layer.cornerRadius = btnH/2
        subview.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.topAnchor.constraint(equalTo: subview.topAnchor).isActive = true
        btn.leadingAnchor.constraint(equalTo: subview.leadingAnchor).isActive = true
        btn.trailingAnchor.constraint(equalTo: subview.trailingAnchor).isActive = true
        btn.bottomAnchor.constraint(equalTo: subview.bottomAnchor).isActive = true
    }
    
    private func setupShadow(subview: UIView) {
        subview.layer.masksToBounds = false
        subview.layer.shadowColor = UIColor.black.cgColor
        subview.layer.shadowRadius = 3.0
        subview.layer.shadowOpacity = 0.3
        subview.layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
        subview.layer.shouldRasterize = true
        subview.layer.rasterizationScale = UIScreen.current.scale
    }
}

//MARK: - Update UI

extension PD_BottomView {
    
    func updateUI(vc: PhotoDetailVC) {
        let isFav = vc.photo?.liked ?? false
        
        favBtn.setImage(UIImage(named: isFav ? "icon-fav" : "icon-detailFav")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favBtn.tintColor = isFav ? favouriteColor : .black
    }
    
    func favDidTap(vc: PhotoDetailVC) {
        let liked = vc.photo?.liked ?? false
        vc.photo?.liked = !liked
        
        guard let photo = vc.photo else {
            return
        }
        
        updateUI(vc: vc)
        
        CoreDataStack.savePhoto(model: photo)
    }
    
    func updateGETButton(photo: PhotoModel?) {
        if !appDL.isPremium {
            let coin = photo?.src.coin ?? 0
            let hidden = coin > 0
            
            coinImageView.isHidden = !hidden
            coinLbl.text = hidden ? "-\(coin)" : "GET".localized().uppercased()
        }
    }
}

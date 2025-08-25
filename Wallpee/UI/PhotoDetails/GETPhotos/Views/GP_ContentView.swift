//
//  GP_ContentView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 13/6/24.
//

import UIKit

class GP_ContentView: UIView {
    
    //MARK: - UIView
    let portraitView = ViewAnimation()
    let landscapeView = ViewAnimation()
    let originView = ViewAnimation()
    
    let portraitLbl = UILabel()
    let landscapeLbl = UILabel()
    let originLbl = UILabel()
    
    let portraitIconImageView = UIImageView()
    let landscapeIconImageView = UIImageView()
    let originIconImageView = UIImageView()
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension GP_ContentView {
    
    func setupViews(vc: GetPhotoVC) {
        clipsToBounds = true
        backgroundColor = .clear
        vc.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let btnH: CGFloat = 50 * 3
        let sep: CGFloat = 2
        
        let height: CGFloat = btnH + sep
        
        //TODO: - PortraitView
        setupView(with: portraitView, 
                  tag: 0,
                  lbl: portraitLbl,
                  txt: "Portrait Adapter".localized(),
                  imgView: portraitIconImageView)
        
        //TODO: - LandscapeView
        setupView(with: landscapeView, 
                  tag: 1, 
                  lbl: landscapeLbl,
                  txt: "Landscape Adapter".localized(),
                  imgView: landscapeIconImageView)
        
        //TODO: - OriginView
        setupView(with: originView, 
                  tag: 2, 
                  lbl: originLbl,
                  txt: "Origin Size".localized(), 
                  imgView: originIconImageView)
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 1.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(portraitView)
        stackView.addArrangedSubview(landscapeView)
        stackView.addArrangedSubview(originView)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: vc.topView.bottomAnchor, constant: 24.0),
            leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: height),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupView(with view: ViewAnimation,
                           tag: Int,
                           lbl: UILabel,
                           txt: String,
                           imgView: UIImageView
    ) {
        //TODO: - ViewAnimation
        view.clipsToBounds = true
        view.backgroundColor = .black.withAlphaComponent(0.1)
        view.tag = tag
        view.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - UILabel
        lbl.font = UIFont(name: FontName.montMedium, size: 15.0)
        lbl.textColor = .white
        lbl.text = txt
        view.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - UIImageView
        
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "icon-ad")?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = .white
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: screenWidth*0.9),
            view.heightAnchor.constraint(equalToConstant: 50.0),
            
            lbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            lbl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imgView.widthAnchor.constraint(equalToConstant: 50.0),
            imgView.heightAnchor.constraint(equalToConstant: 50.0),
            imgView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9.5),
        ])
    }
}

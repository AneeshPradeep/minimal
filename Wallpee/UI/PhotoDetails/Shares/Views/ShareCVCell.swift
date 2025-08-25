//
//  ShareCVCell.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit

class ShareCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "ShareCVCell"
    
    let containerView = UIView()
    let iconImageView = UIImageView()
    let titleLbl = UILabel()
    
    var indexPath: IndexPath?
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
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

extension ShareCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - IconImageView
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        containerView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.montRegular, size: 15.0)
        titleLbl.textAlignment = .center
        titleLbl.textColor = .lightGray
        containerView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            iconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor, multiplier: 1.0),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            titleLbl.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10.0),
            titleLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5.0),
            titleLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5.0),
            titleLbl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])
    }
}

//MARK: - Update UI

extension ShareCVCell {
    
    func updateUI(item: ShareModel) {
        iconImageView.image = item.image
        titleLbl.text = item.title
    }
}

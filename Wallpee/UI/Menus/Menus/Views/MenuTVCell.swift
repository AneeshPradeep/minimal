//
//  MenuTVCell.swift
//  Wallpee
//
//  Created by Thanh Hoang on 9/6/24.
//

import UIKit

class MenuTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "MenuTVCell"
    
    let containerView = UIView()
    let iconView = UIView()
    let iconImageView = UIImageView()
    let titleLbl = UILabel()
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var isTouch = false {
        didSet {
            updateAnimation(self, isEvent: isTouch)
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
        if isTouch { isTouch = false }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        
        if let parent = superview {
            isTouch = frame.contains(touch.location(in: parent))
        }
    }
}

//MARK: - Configures

extension MenuTVCell {
    
    func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - IconView
        let iconW: CGFloat = 60.0
        
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = iconW/2
        iconView.backgroundColor = .clear
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: iconW).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: iconW).isActive = true
        
        let gr = createGradient(bounds: CGRect(x: 0.0, y: 0.0, width: iconW, height: iconW))
        gr.cornerRadius = iconW/2
        iconView.layer.addSublayer(gr)
        
        //TODO: - IconImageView
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = iconW/2
        iconView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.montMedium, size: 18.0)
        titleLbl.textColor = .white
        titleLbl.numberOfLines = 2
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 15.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(titleLbl)
        containerView.addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -10.0),
            
            iconImageView.widthAnchor.constraint(equalToConstant: iconW),
            iconImageView.heightAnchor.constraint(equalToConstant: iconW),
            iconImageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
        ])
    }
}

//MARK: - Update UI

extension MenuTVCell {
    
    func updateUI(item: MenuModel) {
        titleLbl.text = item.name
        titleLbl.addCharacterSpacing(kernValue: 1.5)
        
        iconImageView.image = item.type == .earn ? item.icon : item.icon?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .white
    }
}

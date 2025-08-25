//
//  Ex_ContentCVCell.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit

protocol ExContentCVCellDelegate: AnyObject {
    func favouriteDidTap(cell: Ex_ContentCVCell)
}

class Ex_ContentCVCell: UICollectionViewCell {
    
    //MARK: - UIView
    let containerView = UIView()
    let coverImageView = UIImageView()
    
    let favView = UIView()
    let favEffectView = UIVisualEffectView()
    let favBtn = ButtonAnimation()
    
    //MARK: - Properties
    static let id = "Ex_ContentCVCell"
    
    weak var delegate: ExContentCVCellDelegate?
    
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

extension Ex_ContentCVCell {
    
    private func configreCell() {
        clipsToBounds = true
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        let favW: CGFloat = PhotoLayout.itemW * 0.3
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let gr = createGradient(
            bounds: CGRect(x: 0.0, y: 0.0, width: ExploreVC.itemW, height: ExploreVC.itemH),
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
        favView.isHidden = true
        favView.clipsToBounds = true
        favView.backgroundColor = .clear
        favView.layer.cornerRadius = favW/2
        favView.layer.borderWidth = 1.0
        favView.layer.borderColor = UIColor.white.cgColor
        contentView.addSubview(favView)
        favView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - FavouriteEffectView
        favEffectView.clipsToBounds = true
        favEffectView.effect = UIBlurEffect(style: .regular)
        favEffectView.layer.cornerRadius = favW/2
        favView.addSubview(favEffectView)
        favEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - FavBtn
        favBtn.clipsToBounds = true
        favBtn.layer.cornerRadius = favW/2
        favBtn.setImage(UIImage(named: "icon-fav"), for: .normal)
        favBtn.delegate = self
        favView.addSubview(favBtn)
        favBtn.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            favView.widthAnchor.constraint(equalToConstant: favW),
            favView.heightAnchor.constraint(equalToConstant: favW),
            favView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor, constant: 10.0),
            favView.topAnchor.constraint(equalTo: coverImageView.topAnchor, constant: 10.0),
            
            favEffectView.widthAnchor.constraint(equalToConstant: favW),
            favEffectView.heightAnchor.constraint(equalToConstant: favW),
            favEffectView.centerXAnchor.constraint(equalTo: favView.centerXAnchor),
            favEffectView.centerYAnchor.constraint(equalTo: favView.centerYAnchor),
            
            favBtn.widthAnchor.constraint(equalToConstant: favW),
            favBtn.heightAnchor.constraint(equalToConstant: favW),
            favBtn.centerXAnchor.constraint(equalTo: favView.centerXAnchor),
            favBtn.centerYAnchor.constraint(equalTo: favView.centerYAnchor),
        ])
    }
}

//MARK: - Update UI

extension Ex_ContentCVCell {
    
    func updateFavourite(isFav: Bool) {
        favBtn.backgroundColor = isFav ? favouriteColor : .clear
    }
    
    func updateUI(photo: PhotoModel, indexPath: IndexPath) {
        coverImageView.image = nil
        
        DownloadImage.shared.downloadImage(link: photo.src.medium) { image in
            DispatchQueue.main.async {
                if self.indexPath == indexPath {
                    self.coverImageView.image = image
                    self.image = image
                    self.favView.isHidden = false
                }
            }
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension Ex_ContentCVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        delegate?.favouriteDidTap(cell: self)
    }
}

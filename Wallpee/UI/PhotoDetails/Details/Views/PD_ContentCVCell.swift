//
//  PD_ContentCVCell.swift
//  Wallpee
//
//  Created by Thanh Hoang on 16/6/24.
//

import UIKit

protocol PD_ContentCVCellDelegate: AnyObject {
    func favDidTap(cell: PD_ContentCVCell)
}

class PD_ContentCVCell: UICollectionViewCell {
    
    //MARK: - UIView
    let containerView = UIView()
    let coverImageView = UIImageView()
    let favoriteImageView = UIImageView()
    
    //MARK: - Properties
    static let id = "PD_ContentCVCell"
    
    weak var delegate: PD_ContentCVCellDelegate?
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
    }
}

//MARK: - Configure

extension PD_ContentCVCell {
    
    private func configreCell() {
        clipsToBounds = true
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CoverImageView
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        containerView.addSubview(coverImageView)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - FavoriteImageView
        favoriteImageView.isHidden = true
        favoriteImageView.image = UIImage(named: "icon-doubleTap")?.withRenderingMode(.alwaysTemplate)
        favoriteImageView.tintColor = favouriteColor
        favoriteImageView.clipsToBounds = true
        favoriteImageView.contentMode = .scaleAspectFit
        containerView.addSubview(favoriteImageView)
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            favoriteImageView.widthAnchor.constraint(equalToConstant: screenWidth*0.5),
            favoriteImageView.heightAnchor.constraint(equalToConstant: screenWidth*0.5),
            favoriteImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            favoriteImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandle))
        doubleTap.numberOfTapsRequired = 2
        
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addGestureRecognizer(doubleTap)
    }
    
    private func animateFavorite() {
        favoriteImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        favoriteImageView.isHidden = false
        
        let rotateTransform = CGAffineTransform(rotationAngle: CGFloat(Int.random(min: -10, max: 10)).degreesToRadians())
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.334) {
                self.favoriteImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3).concatenating(rotateTransform)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.334, relativeDuration: 0.333) {
                self.favoriteImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).concatenating(rotateTransform)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.666, relativeDuration: 0.333) {
                self.favoriteImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(rotateTransform)
            }
            
        } completion: { _ in
            UIView.animate(withDuration: 0.33) {
                self.favoriteImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).concatenating(rotateTransform)
                
            } completion: { _ in
                self.favoriteImageView.isHidden = true
            }
        }
    }
    
    @objc private func doubleTapHandle(_ sender: UITapGestureRecognizer) {
        let pt = sender.location(in: self)
        
        favoriteImageView.center = CGPoint(x: pt.x, y: pt.y)
        favoriteImageView.transform = CGAffineTransform(rotationAngle: tan(pt.x/(frame.width*2)))
        
        favoriteImageView.layer.shouldRasterize = true
        favoriteImageView.layer.rasterizationScale = UIScreen.current.scale
        
        animateFavorite()
        
        delegate?.favDidTap(cell: self)
    }
}

//MARK: - Update UI

extension PD_ContentCVCell {
    
    func updateUI(photo: PhotoModel, indexPath: IndexPath) {
        coverImageView.image = image
        
        DownloadImage.shared.downloadImage(link: photo.src.medium) { image in
            DispatchQueue.main.async {
                if self.indexPath == indexPath {
                    self.coverImageView.image = image
                    self.image = image
                    
                    DownloadImage.shared.downloadImage(link: photo.src.portrait) { image in
                        DispatchQueue.main.async {
                            if self.indexPath == indexPath {
                                self.coverImageView.image = image
                                self.image = image
                            }
                        }
                    }
                }
            }
        }
    }
}

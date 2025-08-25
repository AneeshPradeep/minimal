//
//  OnboardingContentCVCell.swift
//  Wallpee
//
//  Created by Thanh Hoang on 24/6/24.
//

import UIKit

class OnboardingContentCVCell: UICollectionViewCell {
    
    //MARK: - UIView
    let containerView = UIView()
    
    let titleLbl_1 = UILabel()
    let titleLbl_2 = UILabel()
    let titleLbl_3 = UILabel()
    let titleLbl_4 = UILabel()
    
    let sepView = UIView()
    
    let coverImageView_1 = UIImageView()
    let coverImageView_2 = UIImageView()
    let coverImageView_3 = UIImageView()
    let coverImageView_4 = UIImageView()
    let coverImageView_5 = UIImageView()
    let coverImageView_6 = UIImageView()
    
    private var edge: CGFloat {
        return (screenWidth - (screenWidth*0.9)) / 2
    }
    private var itemW: CGFloat {
        return (screenWidth - (edge*4)) / 3
    }
    private var itemH: CGFloat {
        return itemW * (screenHeight / screenWidth)
    }
    
    //MARK: - Properties
    static let id = "OnboardingContentCVCell"
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        configreCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Configure

extension OnboardingContentCVCell {
    
    private func configreCell() {
        clipsToBounds = true
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl_1
        setupLabel(
            lbl: titleLbl_1,
            font: UIFont(name: FontName.montExtraBold, size: 35.0),
            txt: "Explore 4K\nWallpapers",
            txtColor: .black)
        
        //TODO: - TitleLbl_2
        setupLabel(
            lbl: titleLbl_2,
            font: UIFont(name: FontName.montSemiBold, size: 18.0),
            txt: "You Device",
            txtColor: .black)
        
        //TODO: - TitleLbl_3
        setupLabel(
            lbl: titleLbl_3,
            font: UIFont(name: FontName.montExtraBold, size: 20.0),
            txt: UIDevice.current.modelName.deviceName(),
            txtColor: UIColor(hex: 0xF49000))
        
        //TODO: - TitleLbl_4
        setupLabel(
            lbl: titleLbl_4,
            font: UIFont(name: FontName.montSemiBold, size: 15.0),
            txt: "All Wallpapers\nare adapted to your screen",
            txtColor: .darkGray)
        
        //TODO: - SepView
        let sepW = UIDevice.current.modelName.deviceName().estimatedTextRect(fontN: FontName.montExtraBold, fontS: 20.0).width
        sepView.clipsToBounds = true
        sepView.backgroundColor = UIColor(hex: 0xF49000)
        sepView.translatesAutoresizingMaskIntoConstraints = false
        sepView.widthAnchor.constraint(equalToConstant: sepW*0.8).isActive = true
        sepView.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        
        //TODO: - UIStackView
        let lblSV = createStackView(spacing: 20.0, distribution: .fill, axis: .vertical, alignment: .center)
        lblSV.addArrangedSubview(titleLbl_1)
        lblSV.addArrangedSubview(titleLbl_2)
        lblSV.addArrangedSubview(titleLbl_3)
        lblSV.setCustomSpacing(0.0, after: titleLbl_3)
        lblSV.addArrangedSubview(sepView)
        lblSV.addArrangedSubview(titleLbl_4)
        containerView.addSubview(lblSV)
        
        //TODO: - CoverImageView
        setupCoverImageView(imageView: coverImageView_1)
        setupCoverImageView(imageView: coverImageView_2)
        setupCoverImageView(imageView: coverImageView_3)
        setupCoverImageView(imageView: coverImageView_4)
        setupCoverImageView(imageView: coverImageView_5)
        setupCoverImageView(imageView: coverImageView_6)
        
        //TODO: - UIStackView
        let coverSV_1 = createStackView(spacing: edge, distribution: .fillEqually, axis: .vertical, alignment: .center)
        coverSV_1.addArrangedSubview(coverImageView_1)
        coverSV_1.addArrangedSubview(coverImageView_2)
        containerView.addSubview(coverSV_1)
        
        //TODO: - UIStackView
        let coverSV_2 = createStackView(spacing: edge, distribution: .fillEqually, axis: .vertical, alignment: .center)
        coverSV_2.addArrangedSubview(coverImageView_3)
        coverSV_2.addArrangedSubview(coverImageView_4)
        containerView.addSubview(coverSV_2)
        
        //TODO: - UIStackView
        let coverSV_3 = createStackView(spacing: edge, distribution: .fillEqually, axis: .vertical, alignment: .center)
        coverSV_3.addArrangedSubview(coverImageView_5)
        coverSV_3.addArrangedSubview(coverImageView_6)
        containerView.addSubview(coverSV_3)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            lblSV.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20.0),
            lblSV.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            coverSV_1.bottomAnchor.constraint(equalTo: lblSV.topAnchor, constant: -(edge*4)),
            coverSV_1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: edge),
            
            coverSV_2.bottomAnchor.constraint(equalTo: lblSV.topAnchor, constant: -((edge*4)+(itemH/2))),
            coverSV_2.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            coverSV_3.bottomAnchor.constraint(equalTo: lblSV.topAnchor, constant: -(edge*4)),
            coverSV_3.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -edge),
            
        ])
    }
    
    private func setupLabel(lbl: UILabel, font: UIFont?, txt: String, txtColor: UIColor) {
        lbl.font = font
        lbl.textColor = txtColor
        lbl.text = txt.localized()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.widthAnchor.constraint(equalToConstant: screenWidth*0.8).isActive = true
    }
    
    private func setupCoverImageView(imageView: UIImageView) {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = itemW/2
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: itemW).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: itemH).isActive = true
    }
}

//MARK: - Update UI

extension OnboardingContentCVCell {
    
    func updateUI(indexPath: IndexPath, photos: [PhotoModel]) {
        titleLbl_1.isHidden = indexPath.item != 0
        titleLbl_2.isHidden = indexPath.item == 0
        titleLbl_3.isHidden = indexPath.item == 0
        titleLbl_4.isHidden = indexPath.item == 0
        sepView.isHidden = indexPath.item == 0
        
        coverImageView_1.image = nil
        coverImageView_2.image = nil
        coverImageView_3.image = nil
        coverImageView_4.image = nil
        coverImageView_5.image = nil
        coverImageView_6.image = nil
        
        if let photo = photos.randomElement() {
            DownloadImage.shared.downloadImage(link: photo.src.medium) { image in
                DispatchQueue.main.async {
                    self.coverImageView_1.image = image
                }
            }
        }
        if let photo = photos.randomElement() {
            DownloadImage.shared.downloadImage(link: photo.src.medium) { image in
                DispatchQueue.main.async {
                    self.coverImageView_2.image = image
                }
            }
        }
        if let photo = photos.randomElement() {
            DownloadImage.shared.downloadImage(link: photo.src.medium) { image in
                DispatchQueue.main.async {
                    self.coverImageView_3.image = image
                }
            }
        }
        if let photo = photos.randomElement() {
            DownloadImage.shared.downloadImage(link: photo.src.medium) { image in
                DispatchQueue.main.async {
                    self.coverImageView_4.image = image
                }
            }
        }
        if let photo = photos.randomElement() {
            DownloadImage.shared.downloadImage(link: photo.src.medium) { image in
                DispatchQueue.main.async {
                    self.coverImageView_5.image = image
                }
            }
        }
        if let photo = photos.randomElement() {
            DownloadImage.shared.downloadImage(link: photo.src.medium) { image in
                DispatchQueue.main.async {
                    self.coverImageView_6.image = image
                }
            }
        }
    }
}

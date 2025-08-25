//
//  ShareTopView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 13/6/24.
//

import UIKit

class ShareTopView: UIView {
    
    //MARK: - UIView
    let darkView = UIView()
    
    let coverImageView = UIImageView()
    let titleLbl = UILabel()
    let subtitleLbl = UILabel()
    
    let separatorView = UIView()
    
    let headerView = UIView()
    let headerTitleLbl = UILabel()
    
    //Tải trước để chia sẻ nhanh hơn
    var coverImage: UIImage?
    var coverData: Data?
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension ShareTopView {
    
    func setupViews(vc: ShareVC) {
        clipsToBounds = true
        backgroundColor = .clear
        vc.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let height: CGFloat = 100 + 70
        
        let edge = (screenWidth - (screenWidth*0.9)) / 2
        
        let coverH: CGFloat = 60.0
        let fontS: CGFloat = 15.0
        
        //TODO: - DarkView
        darkView.clipsToBounds = true
        darkView.backgroundColor = .white
        darkView.layer.cornerRadius = 3.0
        addSubview(darkView)
        darkView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CoverView
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.cornerRadius = 5.0
        coverImageView.layer.borderWidth = 1.0
        coverImageView.layer.borderColor = UIColor.lightGray.cgColor
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.widthAnchor.constraint(equalToConstant: coverH).isActive = true
        coverImageView.heightAnchor.constraint(equalToConstant: coverH).isActive = true
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.montMedium, size: fontS)
        titleLbl.textColor = .white
        
        //TODO: - ArtistLbl
        subtitleLbl.font = UIFont(name: FontName.montMedium, size: fontS-2)
        subtitleLbl.textColor = .lightGray
        
        //TODO: - UIStackView
        let titleSV = createStackView(spacing: 5.0, distribution: .fill, axis: .vertical, alignment: .leading)
        titleSV.addArrangedSubview(titleLbl)
        titleSV.addArrangedSubview(subtitleLbl)
        
        //TODO: - UIStackView
        let coverSV = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        coverSV.addArrangedSubview(coverImageView)
        coverSV.addArrangedSubview(titleSV)
        addSubview(coverSV)
        
        //TODO: - SeparatorView
        separatorView.clipsToBounds = true
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - HeaderView
        headerView.clipsToBounds = true
        headerView.backgroundColor = .clear
        addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - HeaderTitleLbl
        headerTitleLbl.font = UIFont(name: FontName.montExtraBold, size: 20.0)
        headerTitleLbl.textColor = .white
        headerView.addSubview(headerTitleLbl)
        headerTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: vc.view.topAnchor),
            leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: height),
            
            darkView.widthAnchor.constraint(equalToConstant: screenWidth*0.15),
            darkView.heightAnchor.constraint(equalToConstant: 6.0),
            darkView.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
            darkView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            coverSV.topAnchor.constraint(equalTo: topAnchor, constant: 12*2+6),
            coverSV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: edge),
            coverSV.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -edge),
            
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorView.topAnchor.constraint(equalTo: coverSV.bottomAnchor, constant: 12.0),
            separatorView.widthAnchor.constraint(equalToConstant: screenWidth*0.9),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            
            headerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            headerView.widthAnchor.constraint(equalToConstant: screenWidth),
            headerView.heightAnchor.constraint(equalToConstant: 70.0),
            
            headerTitleLbl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerTitleLbl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: edge),
            headerTitleLbl.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -edge),
        ])
    }
}

//MARK: - Update UI

extension ShareTopView {
    
    func updateUI(photo: PhotoModel?) {
        guard let photo = photo else {
            return
        }
        
        let str = NSString(string: photo.url)
        let title = str.lastPathComponent.components(separatedBy: .letters.inverted).joined(separator: " ")
        
        titleLbl.text = title.capitalized
        subtitleLbl.text = appURL
        
        DownloadImage.shared.downloadImage(link: photo.src.medium, contextSize: coverImageView.frame.size) { image in
            self.coverImageView.image = image
            
            let newImage = image?.addWatermark()
            self.coverImage = newImage
            
            DispatchQueue.main.async {
                self.coverData = newImage?.pngData()
            }
        }
        
        headerTitleLbl.text = "Share".localized()
    }
}

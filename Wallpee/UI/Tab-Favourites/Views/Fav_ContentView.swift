//
//  Fav_ContentView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 16/6/24.
//

import UIKit

class Fav_ContentView: UIView {
    
    //MARK: - UIView
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let layout = PhotoLayout()
    
    let shadowView = UIView()
    
    private let gradient = CAGradientLayer()
    private let maskLayer = CALayer()
    
    let noItemLbl = UILabel()
    
    //MARK: - Properties
    var favouriteVC: FavouriteVC?
    var viewModel: FavouriteViewModel?
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension Fav_ContentView {
    
    func setupViews(vc: FavouriteVC) {
        clipsToBounds = true
        backgroundColor = .clear
        vc.view.insertSubview(self, belowSubview: vc.naviView)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CollectionView
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset.top = 20.0
        collectionView.register(Fav_ContentCVCell.self, forCellWithReuseIdentifier: Fav_ContentCVCell.id)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .vertical
        layout.cellPadding = 2.0
        layout.contentPadding = ContentPadding(horizontal: 2.0, vertical: 2.0)
        
        //TODO: - ShadowView
        shadowView.clipsToBounds = true
        shadowView.backgroundColor = .white
        addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        let bounds = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 20.0)
        maskLayer.frame = bounds
        
        gradient.frame = bounds
        gradient.colors = [
            UIColor(hex: 0xFFFFFF, alpha: 1.00).cgColor,
            UIColor(hex: 0xFFFFFF, alpha: 0.75).cgColor,
            UIColor(hex: 0xFFFFFF, alpha: 0.50).cgColor,
            UIColor(hex: 0xFFFFFF, alpha: 0.25).cgColor,
            UIColor(hex: 0xFFFFFF, alpha: 0.00).cgColor
        ]
        gradient.locations = [
            0.0,
            0.25,
            0.50,
            0.75,
            1.0
        ]
        
        maskLayer.addSublayer(gradient)
        
        shadowView.layer.mask = maskLayer
        
        //TODO: - NoItemLbl
        noItemLbl.font = UIFont(name: FontName.montBold, size: 18.0)
        noItemLbl.text = "Add wallpaper to your favorites list.".localized()
        noItemLbl.textColor = .black
        noItemLbl.textAlignment = .center
        noItemLbl.numberOfLines = 0
        addSubview(noItemLbl)
        noItemLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: vc.naviView.bottomAnchor),
            leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            shadowView.heightAnchor.constraint(equalToConstant: 20.0),
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            noItemLbl.widthAnchor.constraint(equalToConstant: screenWidth*0.7),
            noItemLbl.centerXAnchor.constraint(equalTo: centerXAnchor),
            noItemLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setupDataSourceAndDelegate(dl: UICollectionViewDataSource & UICollectionViewDelegate) {
        collectionView.dataSource = dl
        collectionView.delegate = dl
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension Fav_ContentView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Fav_ContentCVCell.id, for: indexPath) as! Fav_ContentCVCell
        viewModel?.contentCVCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension Fav_ContentView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Fav_ContentCVCell else {
            return
        }
        
        viewModel?.contentCoverImage(cell: cell, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectPhoto(indexPath: indexPath)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension Fav_ContentView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: PhotoLayout.itemW, height: PhotoLayout.itemH)
    }
}

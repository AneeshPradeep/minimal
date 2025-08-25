//
//  Down_ContentView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 20/6/24.
//

import UIKit

class Down_ContentView: UIView {
    
    //MARK: - UIView
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let layout = PhotoLayout()
    
    let noItemLbl = UILabel()
    
    //MARK: - Properties
    var downloadedVC: DownloadedVC?
    var viewModel: DownloadedViewModel?
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension Down_ContentView {
    
    func setupViews(vc: DownloadedVC) {
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
        collectionView.register(Down_ContentCVCell.self, forCellWithReuseIdentifier: Down_ContentCVCell.id)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .vertical
        layout.cellPadding = 2.0
        layout.contentPadding = ContentPadding(horizontal: 2.0, vertical: 2.0)
        
        //TODO: - NoItemLbl
        noItemLbl.font = UIFont(name: FontName.montBold, size: 18.0)
        noItemLbl.text = "You haven't downloaded any wallpapers yet.".localized()
        noItemLbl.textColor = .black
        noItemLbl.textAlignment = .center
        noItemLbl.numberOfLines = 0
        addSubview(noItemLbl)
        noItemLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: vc.view.topAnchor),
            leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
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

extension Down_ContentView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Down_ContentCVCell.id, for: indexPath) as! Down_ContentCVCell
        viewModel?.contentCVCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension Down_ContentView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Down_ContentCVCell else {
            return
        }
        
        viewModel?.contentCoverImage(cell: cell, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectPhoto(indexPath: indexPath)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension Down_ContentView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: PhotoLayout.itemW, height: PhotoLayout.itemH)
    }
}

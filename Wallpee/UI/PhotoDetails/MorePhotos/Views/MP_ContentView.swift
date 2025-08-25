//
//  MP_ContentView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 7/6/24.
//

import UIKit

class MP_ContentView: UIView {
    
    //MARK: - UIView
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let layout = PhotoLayout()
    
    private let gradient = CAGradientLayer()
    private let maskLayer = CALayer()
    
    //MARK: - Properties
    var morePhotoVC: MorePhotoVC?
    var viewModel: MorePhotoViewModel?
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension MP_ContentView {
    
    func setupViews(vc: MorePhotoVC) {
        clipsToBounds = true
        backgroundColor = .clear
        vc.view.insertSubview(self, belowSubview: vc.topView)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CollectionView
        collectionView.isScrollEnabled = false
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MP_ContentCVCell.self, forCellWithReuseIdentifier: MP_ContentCVCell.id)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .vertical
        layout.cellPadding = 2.0
        layout.contentPadding = ContentPadding(horizontal: 2.0, vertical: 2.0)
        
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

extension MP_ContentView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel?.photos.count ?? 0
        return count <= 0 ? 6 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MP_ContentCVCell.id, for: indexPath) as! MP_ContentCVCell
        viewModel?.contentCVCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension MP_ContentView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MP_ContentCVCell else {
            return
        }
        
        viewModel?.contentCoverImage(cell: cell, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectPhoto(indexPath: indexPath)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MP_ContentView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: PhotoLayout.itemW, height: PhotoLayout.itemH)
    }
}

//MARK: - UIScrollViewDelegate

extension MP_ContentView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentSize.height - scrollView.bounds.height
        
        if offsetY > 0 && 
            scrollView.contentOffset.y > offsetY &&
            viewModel?.isLoadMore == true
        {
            print("Tải thêm Photos")
            viewModel?.isLoadMore = false
            viewModel?.loadMorePhotos()
        }
    }
}

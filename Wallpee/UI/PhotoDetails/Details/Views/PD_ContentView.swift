//
//  PD_ContentView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit

class PD_ContentView: UIView {
    
    //MARK: - UIView
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let layout = PhotoDetailLayout()
    
    let circleView = UIView()
    
    //MARK: - Properties
    var photoDetailVC: PhotoDetailVC?
    var viewModel: PhotoDetailViewModel?
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension PD_ContentView {
    
    func setupViews(vc: PhotoDetailVC) {
        clipsToBounds = true
        tag = 333
        backgroundColor = .clear
        vc.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CollectionView
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PD_ContentCVCell.self, forCellWithReuseIdentifier: PD_ContentCVCell.id)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.collectionViewLayout = layout
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = .horizontal
        
        //TODO: - CircleView
        let circleW: CGFloat = 35.0
        
        circleView.isHidden = true
        circleView.clipsToBounds = true
        circleView.backgroundColor = .white
        circleView.layer.cornerRadius = circleW/2
        circleView.layer.masksToBounds = false
        circleView.layer.shadowColor = UIColor.black.cgColor
        circleView.layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
        circleView.layer.shadowRadius = 5.0
        circleView.layer.shadowOpacity = 1.0
        circleView.layer.shouldRasterize = true
        circleView.layer.rasterizationScale = UIScreen.current.scale
        addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            circleView.widthAnchor.constraint(equalToConstant: circleW),
            circleView.heightAnchor.constraint(equalToConstant: circleW),
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 50.0),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
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
    
    func scrollTo(index: Int) {
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    func moveTo() {
        circleView.isHidden = false
        
        UIView.animate(withDuration: 0.75) {
            self.circleView.alpha = 0.5
            self.circleView.transform = CGAffineTransform(translationX: -screenWidth, y: 0.0)
            
        } completion: { _ in
            self.circleView.isHidden = true
            self.circleView.alpha = 1.0
            self.circleView.transform = .identity
        }
    }
}

//MARK: - UICollectionViewDataSource

extension PD_ContentView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PD_ContentCVCell.id, for: indexPath) as! PD_ContentCVCell
        viewModel?.contentCVCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension PD_ContentView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

//MARK: - UICollectionViewDelegateFlowLayout

extension PD_ContentView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenHeight)
    }
}

//MARK: - UIScrollViewDelegate

extension PD_ContentView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var count = (viewModel?.photos.count ?? 0) - 1
        count = count <= 0 ? 0 : count
        
        let maxX = CGFloat(count) * screenWidth
        
        if scrollView.contentOffset.x <= 0 {
            //scrollView.contentOffset.x = 0
            
        } else if scrollView.contentOffset.x >= maxX {
            scrollView.contentOffset.x = maxX
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / screenWidth)
        let indexPath = IndexPath(item: index, section: 0)
        
        guard let photos = viewModel?.photos else {
            return
        }
        guard photos.count > 0 && indexPath.item < photos.count else {
            return
        }
        
        let photo = photos[indexPath.item]
        viewModel?.updateNewPhoto(photo: photo)
        
        NotificationCenter.default.post(name: .changePhotoKey, object: photo)
    }
}

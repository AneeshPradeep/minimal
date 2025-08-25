//
//  DownloadedViewModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 20/6/24.
//

import UIKit

class DownloadedViewModel: NSObject {
    
    //MARK: - Properties
    private let parentVC: DownloadedVC
    
    var transitionAnimator: SharedTransitionAnimator?
    
    lazy var photos: [PhotoModel] = []
    
    //MARK: - Initializes
    init(parentVC: DownloadedVC) {
        self.parentVC = parentVC
    }
}

//MARK: - Load Data

extension DownloadedViewModel {
    
    func loadPhotos() {
        photos = CoreDataStack.fetchDownloadedPhotos()
        
        parentVC.contentView.collectionView.isHidden = photos.count == 0
        parentVC.contentView.noItemLbl.isHidden = photos.count > 0
        
        if photos.count > 0 {
            let hud = HUD.hud(parentVC.view)
            
            delay(duration: 0.5) {
                self.parentVC.contentView.reloadData()
                hud.removeHUD {}
            }
            
            let coverUrls = photos.compactMap({
                URL(string: $0.src.medium)
            })
            DownloadImage.shared.batchDownloadImages(coverUrls)
        }
    }
}

//MARK: - Setup Cell

extension DownloadedViewModel {
    
    func contentCVCell(cell: Down_ContentCVCell, indexPath: IndexPath) {
        cell.indexPath = indexPath
        cell.delegate = self
    }
    
    func contentCoverImage(cell: Down_ContentCVCell, indexPath: IndexPath) {
        if photos.count > 0 && indexPath.item < photos.count {
            let photo = photos[indexPath.item]
            cell.updateUI(photo: photo, indexPath: indexPath)
        }
    }
}

//MARK: - Did Select

extension DownloadedViewModel {
    
    func didSelectPhoto(indexPath: IndexPath) {
        if photos.count > 0 && indexPath.item < photos.count {
            let cell = parentVC.contentView.collectionView.cellForItem(at: indexPath) as? Down_ContentCVCell
            
            parentVC.selectedCell = cell
            parentVC.selectedIndexPath = indexPath
            
            let photo = photos[indexPath.item]
            
            transitionAnimator = nil
            transitionAnimator = SharedTransitionAnimator()
            
            parentVC.goToPhotoDetailVC(photo: photo, placeholderImage: cell?.image, transitionAnimator: transitionAnimator)
        }
    }
}

//MARK: - Down_ContentCVCellDelegate

extension DownloadedViewModel: Down_ContentCVCellDelegate {
    
    func favouriteDidTap(cell: Down_ContentCVCell) {
        guard let indexPath = parentVC.contentView.collectionView.indexPath(for: cell) else {
            return
        }
        let photo = photos[indexPath.item]
        let liked = photo.liked ?? false
        
        photos[indexPath.item].liked = !liked
        
        let newPhoto = photos[indexPath.item]
        
        cell.updateFavourite(isFav: newPhoto.liked ?? false)
        
        CoreDataStack.savePhoto(model: newPhoto)
    }
}

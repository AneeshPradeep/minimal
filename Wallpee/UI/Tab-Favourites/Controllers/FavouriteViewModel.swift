//
//  FavouriteViewModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 16/6/24.
//

import UIKit
import MessageUI

class FavouriteViewModel: NSObject {
    
    //MARK: - Properties
    private let parentVC: FavouriteVC
    
    lazy var photos: [PhotoModel] = []
    
    var transitionAnimator: SharedTransitionAnimator?
    
    var menuContainerVC: MenuContainerVC?
    
    //MARK: - Initializes
    init(parentVC: FavouriteVC) {
        self.parentVC = parentVC
    }
}

//MARK: - Load Data

extension FavouriteViewModel {
    
    func loadPhotos() {
        photos = CoreDataStack.fetchFavouritePhotos()
        
        let coverUrls = photos.compactMap({
            URL(string: $0.src.medium)
        })
        DownloadImage.shared.batchDownloadImages(coverUrls)
        
        parentVC.contentView.reloadData()
        
        parentVC.contentView.collectionView.isHidden = photos.count == 0
        parentVC.contentView.noItemLbl.isHidden = photos.count > 0
    }
}

//MARK: - Setup Cell

extension FavouriteViewModel {
    
    func contentCVCell(cell: Fav_ContentCVCell, indexPath: IndexPath) {
        cell.indexPath = indexPath
    }
    
    func contentCoverImage(cell: Fav_ContentCVCell, indexPath: IndexPath) {
        if photos.count > 0 && indexPath.item < photos.count {
            let photo = photos[indexPath.item]
            cell.updateUI(photo: photo, indexPath: indexPath)
        }
    }
}

//MARK: - Did Select

extension FavouriteViewModel {
    
    func didSelectPhoto(indexPath: IndexPath) {
        if photos.count > 0 && indexPath.item < photos.count {
            let cell = parentVC.contentView.collectionView.cellForItem(at: indexPath) as? Fav_ContentCVCell
            
            parentVC.selectedCell = cell
            parentVC.selectedIndexPath = indexPath
            
            let photo = photos[indexPath.item]
            
            transitionAnimator = nil
            transitionAnimator = SharedTransitionAnimator()
            
            parentVC.goToPhotoDetailVC(photo: photo, placeholderImage: cell?.image, transitionAnimator: transitionAnimator)
        }
    }
}

//MARK: - Actions

extension FavouriteViewModel {
    
    func menuDidTap() {
        removeMenuContainerVC(with: menuContainerVC)
        menuContainerVC = createMenuContainerVC(parentVC.navigationController, menuDL: self, sideDL: self)
    }
}

//MARK: - MenuContainerVCDelegate

extension FavouriteViewModel: MenuContainerVCDelegate {
    
    func completionAnim(_ isComplete: Bool) {
        if !isComplete {
            removeMenuContainerVC(with: menuContainerVC)
            removeEffectFromMenuContainerVC()
            
        } else {
            createEffectForMenuContainerVC(target: self, action: #selector(removeEffectDidTap))
        }
    }
    
    @objc private func removeEffectDidTap() {
        menuContainerVC?.toggleSideMenu()
        removeEffectFromMenuContainerVC()
    }
}

//MARK: - MenuTVCDelegate

extension FavouriteViewModel: MenuTVCDelegate {
    
    func sideMenuDidTap(item: MenuModel) {
        switch item.type {
        case .downloaded:
            parentVC.goToDownloadedVC()
            break
        
        case .language:
            parentVC.languageDidTap()
            break
            
        case .earn:
            parentVC.earnDidTap()
            break
            
        case .termsAndConditions:
            parentVC.termAndConditionDidTap()
            break
            
        case .support:
            parentVC.supportDidTap(dl: self)
            break
            
        case .rateUs:
            parentVC.rateUsDidTap()
            break
            
        case .shareApp:
            parentVC.shareDidTap()
            break
        }
    }
}

//MARK: - MFMailComposeViewControllerDelegate

extension FavouriteViewModel: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        switch result {
        case .cancelled: print("Cancelled")
        case .saved: print("Saved")
        case .sent: print("Sent")
        case .failed: print("Failed")
        default: break
        }
        
        controller.dismiss(animated: true)
    }
}

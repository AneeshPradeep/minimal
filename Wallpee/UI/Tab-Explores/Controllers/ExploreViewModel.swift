//
//  ExploreViewModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit
import MessageUI

class ExploreViewModel: NSObject {
    
    //MARK: - Properties
    private let parentVC: ExploreVC
    
    lazy var photos: [PhotoModel] = []
    
    var nextPage = "" //Liên kết tải thêm trang mới
    var isLoadMore = false //Tải thêm Photos
    
    var transitionAnimator: SharedTransitionAnimator?
    
    var menuContainerVC: MenuContainerVC?
    
    //MARK: - Initializes
    init(parentVC: ExploreVC) {
        self.parentVC = parentVC
    }
}

//MARK: - Load Data

extension ExploreViewModel {
    
    func loadPhotos() {
        let hud = HUD.hud(parentVC.view)
        
        //Nếu tệp tồn tại
        if let dict = WebService.shared.getJSONFile(createFileName()) as? NSDictionary {
            print("Nếu tệp tồn tại")
            
            delay(duration: 0.5) {
                //Cho UI
                if let data = try? JSONSerialization.data(withJSONObject: dict),
                   let result = try? JSONDecoder().decode(PhotoResult.self, from: data)
                {
                    self.updatePhotos(result: result, hud: hud)
                    
                } else {
                    DispatchQueue.main.async {
                        hud.removeHUD {}
                    }
                }
            }
            
            return
        }
        
        Task(priority: .userInitiated) {
            let result = try await WebService.shared.fetchCuraterPhotos(type: PhotoResult.self)
            updatePhotos(result: result, hud: hud)
            
            /*
             - Nếu trong ngày truy cập App nhiều lần
             - Ko tải lại các Curater
             - Lấy dữ liệu đã lưu hiển thị cho UI
             */
            savePhotoToJSON(result: result)
        }
    }
    
    private func updatePhotos(result: PhotoResult, hud: HUD) {
        nextPage = result.next_page ?? ""
        isLoadMore = result.next_page != ""
        
        photos = result.photos
            .compactMap({
                var p = $0
                
                if let photo = CoreDataStack.fetchPhoto(by: $0.id) {
                    p.liked = photo.liked
                    p.src.coin = photo.coin.intValue
                    p.src.unlock = photo.unlock
                }
                
                return p
                
            })
            .shuffled()
        
        let coverUrls = photos.compactMap({
            URL(string: $0.src.medium)
        })
        DownloadImage.shared.batchDownloadImages(coverUrls)
        
        parentVC.contentView.reloadData()
        
        DispatchQueue.main.async {
            hud.removeHUD {}
        }
    }
    
    private func savePhotoToJSON(result: PhotoResult) {
        //Nếu tệp ko tồn tại
        if let data = try? JSONEncoder().encode(result),
           let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
        {
            print("Nếu tệp ko tồn tại")
            
            let dict = NSMutableDictionary(dictionary: json)
            WebService.shared.saveJSONFile(createFileName(), dataAny: dict)
        }
    }
    
    private func createFileName() -> String {
        let f = createDateFormatter()
        f.dateFormat = "yyyyMMdd"
        
        let fileName = f.string(from: Date())
        return fileName
    }
}

//MARK: - Load More Data

extension ExploreViewModel {
    
    func loadMorePhotos() {
        guard nextPage != "" else {
            return
        }
        
        let hud = HUD.hud(parentVC.view)
        
        Task(priority: .userInitiated) {
            let result = try await WebService.shared.loadMorePhotos(link: nextPage, type: PhotoResult.self)
            
            if result.photos.count > 0 {
                let deleteIndexPaths = getIndexPaths()
                
                let newPhotos = result.photos.shuffled()
                self.photos.append(contentsOf: newPhotos)
                self.nextPage = result.next_page ?? ""
                
                let insertIndexPaths = getIndexPaths()
                reloadData(deleteIndexPaths: deleteIndexPaths, insertIndexPaths: insertIndexPaths)
                
                //Lấy dữ liệu đã lưu
                if let dict = WebService.shared.getJSONFile(self.createFileName()) as? NSDictionary {
                    if let data = try? JSONSerialization.data(withJSONObject: dict),
                       var oldResult = try? JSONDecoder().decode(PhotoResult.self, from: data)
                    {
                        //Cập nhật thông tin mới cho JSON
                        oldResult.next_page = result.next_page
                        oldResult.photos.append(contentsOf: newPhotos)
                        
                        //Ghi đè dữ liệu
                        self.savePhotoToJSON(result: oldResult)
                    }
                }
                
                let coverUrls = result.photos.compactMap({
                    URL(string: $0.src.medium)
                })
                DownloadImage.shared.batchDownloadImages(coverUrls)
                
                DispatchQueue.main.async {
                    hud.removeHUD {}
                    self.isLoadMore = result.next_page != ""
                }
            }
        }
    }
    
    private func reloadData(deleteIndexPaths: [IndexPath], insertIndexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.parentVC.contentView.collectionView.performBatchUpdates {
                if deleteIndexPaths.count > 0 {
                    self.parentVC.contentView.collectionView.deleteItems(at: deleteIndexPaths)
                }
                
                if insertIndexPaths.count > 0 {
                    self.parentVC.contentView.collectionView.insertItems(at: insertIndexPaths)
                }
            }
        }
    }
    
    private func getIndexPaths() -> [IndexPath] {
        var deleteIndexPaths: [IndexPath] = []
        for i in 0..<photos.count {
            deleteIndexPaths.append(IndexPath(item: i, section: 0))
        }
        
        return deleteIndexPaths
    }
}

//MARK: - Setup Cell

extension ExploreViewModel {
    
    func contentCVCell(cell: Ex_ContentCVCell, indexPath: IndexPath) {
        cell.indexPath = indexPath
        cell.delegate = self
    }
    
    func contentCoverImage(cell: Ex_ContentCVCell, indexPath: IndexPath) {
        if photos.count > 0 && indexPath.item < photos.count {
            let photo = photos[indexPath.item]
            cell.updateUI(photo: photo, indexPath: indexPath)
            cell.updateFavourite(isFav: photo.liked ?? false)
        }
    }
}

//MARK: - Did Select

extension ExploreViewModel {
    
    func didSelectPhoto(indexPath: IndexPath) {
        if photos.count > 0 && indexPath.item < photos.count {
            let cell = parentVC.contentView.collectionView.cellForItem(at: indexPath) as? Ex_ContentCVCell
            
            parentVC.selectedCell = cell
            parentVC.selectedIndexPath = indexPath
            
            let photo = photos[indexPath.item]
            
            transitionAnimator = nil
            transitionAnimator = SharedTransitionAnimator()
            
            parentVC.goToPhotoDetailVC(photo: photo, placeholderImage: cell?.image, transitionAnimator: transitionAnimator)
        }
    }
}

//MARK: - ExContentCVCellDelegate

extension ExploreViewModel: ExContentCVCellDelegate {
    
    func favouriteDidTap(cell: Ex_ContentCVCell) {
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

//MARK: - Actions

extension ExploreViewModel {
    
    func menuDidTap() {
        removeMenuContainerVC(with: menuContainerVC)
        menuContainerVC = createMenuContainerVC(parentVC.navigationController, menuDL: self, sideDL: self)
    }
}

//MARK: - MenuContainerVCDelegate

extension ExploreViewModel: MenuContainerVCDelegate {
    
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

extension ExploreViewModel: MenuTVCDelegate {
    
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

extension ExploreViewModel: MFMailComposeViewControllerDelegate {
    
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

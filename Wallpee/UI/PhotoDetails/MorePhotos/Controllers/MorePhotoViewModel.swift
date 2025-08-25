//
//  MorePhotoViewModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 7/6/24.
//

import UIKit

class MorePhotoViewModel: NSObject {
    
    //MARK: - Properties
    private let parentVC: MorePhotoVC
    
    lazy var photos: [PhotoModel] = []
    
    var nextPage = "" //Liên kết tải thêm trang mới
    var isLoadMore = false //Tải thêm Photos
    
    var transitionAnimator: SharedTransitionAnimator?
    
    //MARK: - Initializes
    init(parentVC: MorePhotoVC) {
        self.parentVC = parentVC
    }
}

//MARK: - Load Data

extension MorePhotoViewModel {
    
    func loadPhotos() {
        if let result = parentVC.photoResult {
            let hud = HUD.hud(parentVC.view)
            
            delay(duration: 0.5) {
                self.updateData(result: result, hud: hud)
            }
            
            return
        }
    }
    
    func updateData(result: PhotoResult, hud: HUD?) {
        nextPage = result.next_page ?? ""
        isLoadMore = result.next_page != ""
        
        photos = result.photos
            .compactMap({
                var p = $0
                
                if let photo = CoreDataStack.fetchPhoto(by: $0.id) {
                    p.liked = photo.liked
                    p.src.coin = photo.coin.intValue
                    p.src.unlock = photo.unlock
                    
                } else {
                    p.src.coin = Int.random(min: 4, max: 11)
                    p.src.unlock = false
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
            hud?.removeHUD {}
        }
    }
    
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
                photos.append(contentsOf: newPhotos)
                nextPage = result.next_page ?? ""
                
                photos = photos
                    .compactMap({
                        var p = $0
                        
                        if let photo = CoreDataStack.fetchPhoto(by: $0.id) {
                            p.liked = photo.liked
                            p.src.coin = photo.coin.intValue
                            p.src.unlock = photo.unlock
                            
                        } else {
                            p.src.coin = Int.random(min: 4, max: 11)
                            p.src.unlock = false
                        }
                        
                        return p
                    })
                
                let coverUrls = result.photos.compactMap({
                    URL(string: $0.src.medium)
                })
                DownloadImage.shared.batchDownloadImages(coverUrls)
                
                let insertIndexPaths = getIndexPaths()
                reloadData(deleteIndexPaths: deleteIndexPaths, insertIndexPaths: insertIndexPaths)
                
                DispatchQueue.main.async {
                    hud.removeHUD {}
                    self.isLoadMore = result.next_page != ""
                    
                    if var oldResult = self.parentVC.photoResult {
                        oldResult.photos.append(contentsOf: result.photos)
                        
                        NotificationCenter.default.post(name: .newPhotoResultKey, object: oldResult)
                    }
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

extension MorePhotoViewModel {
    
    func contentCVCell(cell: MP_ContentCVCell, indexPath: IndexPath) {
        cell.indexPath = indexPath
    }
    
    func contentCoverImage(cell: MP_ContentCVCell, indexPath: IndexPath) {
        if photos.count > 0 && indexPath.item < photos.count {
            let photo = photos[indexPath.item]
            cell.updateUI(photo: photo, indexPath: indexPath)
        }
    }
}

//MARK: - Did Select

extension MorePhotoViewModel {
    
    func didSelectPhoto(indexPath: IndexPath) {
        if photos.count > 0 && indexPath.item < photos.count {
            let photo = photos[indexPath.item]
            
            NotificationCenter.default.post(name: .changePhotoKey, object: photo)
            
            parentVC.delegate?.selectPhoto(vc: parentVC, photo: photo)
        }
    }
}

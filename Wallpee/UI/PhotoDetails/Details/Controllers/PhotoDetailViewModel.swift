//
//  PhotoDetailViewModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit

class PhotoDetailViewModel: NSObject {
    
    //MARK: - Properties
    private let parentVC: PhotoDetailVC
    
    //Sử dụng cho chọn loại để tải
    var isPortrait = false
    var isLandscape = false
    var isOrigin = false
    
    var hud: HUD?
    
    //Mảng cho UI
    lazy var photos: [PhotoModel] = []
    
    //Cho MoreVC. Nếu vẫn ở tại trang và truy cập vào MoreVC thêm lần nữa
    var photoResult: PhotoResult?
    
    //MARK: - Initializes
    init(parentVC: PhotoDetailVC) {
        self.parentVC = parentVC
    }
}

//MARK: - Load Data

extension PhotoDetailViewModel {
    
    func loadPhotos() {
        guard let photo = parentVC.photo else {
            return
        }
        
        if let result = appDL.photoResultDict["\(photo.id)"] {
            photoResult = result
            
            let newPhotos = result.photos
                .filter({ $0.id != photo.id })
                .shuffled()
            photos.append(contentsOf: newPhotos)
            
            parentVC.contentView.reloadData()
            
            return
        }
        
        Task(priority: .userInitiated) {
            var title = photo.alt.capitalized
            
            if photo.alt == "" {
                title = NSString(string: photo.url).lastPathComponent.capitalized
            }
            
            title = title.components(separatedBy: .letters.inverted).joined(separator: " ")
            
            let result = try await WebService.shared.searchPhotos(with: title, type: PhotoResult.self)
            
            if result.photos.count > 0 {
                photoResult = result
                
                let newPhotos = result.photos.shuffled()
                photos.append(contentsOf: newPhotos)
                
                photos = photos
                    .compactMap({
                        var p = $0
                        
                        if $0.id != photo.id {
                            if let photo = CoreDataStack.fetchPhoto(by: $0.id) {
                                p.liked = photo.liked
                                p.src.coin = photo.coin.intValue
                                p.src.unlock = photo.unlock
                                
                            } else {
                                p.src.coin = Int.random(min: 4, max: 11)
                                p.src.unlock = false
                            }
                        }
                        
                        return p
                    })
                
                await parentVC.contentView.reloadData()
                
                DispatchQueue.main.async {
                    var newResult = result
                    newResult.photos = self.photos
                    
                    appDL.photoResultDict["\(photo.id)"] = newResult
                    
                    let dict: [String: PhotoResult] = ["result": newResult]
                    NotificationCenter.default.post(name: .newPhotoResultKey, object: dict)
                    
                    if appDL.adCount <= 1 && !self.parentVC.firstLaunch {
                        delay(duration: 1.0) {
                            self.parentVC.contentView.moveTo()
                        }
                        
                        self.parentVC.firstLaunch = true
                    }
                }
            }
        }
    }
}

//MARK: - Update Data

extension PhotoDetailViewModel {
    
    func updateNewPhoto(photo: PhotoModel?) {
        parentVC.photo = photo
        
        parentVC.bottomView.updateUI(vc: parentVC)
        parentVC.bottomView.updateGETButton(photo: parentVC.photo)
    }
    
    func updatePhoto() {
        if let photo = parentVC.photo {
            //Nếu Photo ko tồn tại trong mảng thì thêm vào
            if !photos.contains(where: {
                $0.id == photo.id
                
            }) {
                photos.append(photo)
                
                parentVC.contentView.reloadData()
            }
            
            //Nếu Photo tồn tại trong mảng, thì cuộn đến vị trí của nó
            if let index = photos.firstIndex(where: {
                $0.id == photo.id
            }) {
                parentVC.contentView.scrollTo(index: index)
            }
        }
    }
}

//MARK: - Actions

extension PhotoDetailViewModel {
    
    func goToMoreVC() {
        let height = 100 + bottomPadding + PhotoLayout.itemH
        
        let nextVC = MorePhotoVC()
        nextVC.photo = parentVC.photo
        nextVC.photoResult = photoResult
        nextVC.delegate = self
        nextVC.modalPresentationStyle = .custom
        nextVC.transitioningDelegate = parentVC
        nextVC.preferredContentSize = CGSize(width: screenWidth, height: height)
        
        parentVC.present(nextVC, animated: true)
    }
    
    func getDidTap() {
        if appDL.isPremium {
            downloadDidTap()
            return
        }
        
        let coin = parentVC.photo?.src.coin ?? 0
        
        //Nếu coin > 0. Thì phải mở khóa
        if coin > 0 {
            unlockDidTap()
            return
        }
        
        downloadDidTap()
    }
    
    private func downloadDidTap() {
        let src = parentVC.photo?.src
        
        let btnH: CGFloat = 50 * 3
        let sep: CGFloat = 2
        
        let height: CGFloat = (12*5) + (51+sep) + btnH
        
        let nextVC = GetPhotoVC()
        nextVC.delegate = self
        
        if appDL.isPremium {
            nextVC.isUnlock = true
            
        } else {
            nextVC.isUnlock = src?.unlock ?? false
        }
        
        nextVC.photo = parentVC.photo
        nextVC.modalPresentationStyle = .custom
        nextVC.transitioningDelegate = parentVC
        nextVC.preferredContentSize = CGSize(width: screenWidth, height: height+bottomPadding)
        
        parentVC.present(nextVC, animated: true)
    }
    
    private func unlockDidTap() {
        let coin = parentVC.photo?.src.coin ?? 0
        
        //Nếu ko đủ Coin
        if parentVC.currentCoin < coin {
            CustomizeAlert.shared.customizeAlert(
                type: .alert,
                mesTxt: "Your current amount of coins is not enough. Please earn more.".localized(),
                okStr: "Watch Ad") { act in
                    if act == "Watch Ad" {
                        self.loadRewarded()
                    }
                }
            
        } else {
            CustomizeAlert.shared.customizeAlert(
                type: .other,
                iconImage: UIImage(named: "alert-coin"),
                titleTxt: "Unlock".localized() + " -\(coin)",
                mesTxt: "✓ No Ads".localized() + "\n" + "✓ Download any time".localized(),
                okStr: "Unlock") { act in
                    if act == "Unlock" {
                        DispatchQueue.main.async {
                            self.parentVC.currentCoin = self.parentVC.currentCoin - coin
                            self.parentVC.naviView.coinLbl.text = "\(self.parentVC.currentCoin)"
                            
                            KeyManager.shared.setCoin(coin: self.parentVC.currentCoin)
                            
                            self.parentVC.photo?.src.coin = 0
                            self.parentVC.photo?.src.unlock = true
                            
                            self.parentVC.bottomView.updateGETButton(photo: self.parentVC.photo)
                            
                            guard let photo = self.parentVC.photo else {
                                return
                            }
                            
                            if let index = self.photos.firstIndex(where: {
                                    $0.id == photo.id
                                })
                            {
                                self.photos[index] = photo
                            }
                            
                            CoreDataStack.savePhoto(model: photo)
                            
                            self.downloadDidTap()
                        }
                    }
                }
        }
    }
    
    //Xem quảng cáo +2 coin
    func earnCoin() {
        CustomizeAlert.shared.customizeAlert(
            type: .ads,
            mesTxt: "Are you sure you want to watch video ad to get +2?".localized(),
            okStr: "Watch Ad") { act in
                if act == "Watch Ad" {
                    self.loadRewarded()
                }
            }
    }
    
    private func loadRewarded() {
        loadRewarded {
            self.parentVC.currentCoin += 2
            self.parentVC.naviView.coinLbl.text = "\(self.parentVC.currentCoin)"
            
            KeyManager.shared.setCoin(coin: self.parentVC.currentCoin)
            
            let hud = HUD.hud(
                self.parentVC.view,
                text: "+2",
                image: UIImage(named: "icon-coin"),
                earnCoin: true
            )
            hud.tag = 4455
            hud.isUserInteractionEnabled = true
        }
        
        parentVC.showRewardedAd = RewardViewModel.shared.isAdAvailable()
    }
    
    private func loadRewarded(completion: @escaping () -> Void) {
        RewardViewModel.shared.showAd {
            self.parentVC.rewardDidDismiss()
            
        } receivedReward: { coin in
            completion()
        }
        
        parentVC.showRewardedAd = RewardViewModel.shared.isAdAvailable()
    }
}

//MARK: - GetPhotoVCDelegate

extension PhotoDetailViewModel: GetPhotoVCDelegate {
    
    func downloadDidTap(vc: GetPhotoVC, isPortrait: Bool, isLandscape: Bool, isOrigin: Bool) {
        self.isPortrait = isPortrait
        self.isLandscape = isLandscape
        self.isOrigin = isOrigin
        
        vc.dismiss(animated: true) {
            var isUnlock = appDL.isPremium
            
            if !isUnlock {
                isUnlock = self.parentVC.photo?.src.unlock ?? false
            }
            
            //Nếu chưa mở khóa hoặc chưa đăng ký Premium
            if !isUnlock {
                //Hiện quảng cáo
                CustomizeAlert.shared.customizeAlert(
                    type: .ads,
                    mesTxt: "To get this wallpaper you need to watch a video ad.".localized(),
                    okStr: "Watch Ad") { act in
                        if act == "Watch Ad" {
                            self.loadRewarded {
                                self.parentVC.downloadedRewardedAd = true
                            }
                        }
                    }
                
            } else {
                self.downloadWallpaper()
            }
        }
    }
    
    func downloadWallpaper() {
        var link = parentVC.photo?.src.original ?? ""
        
        /*
         - Nếu chọn Portrait || Landscape thì cắt hình theo tỉ lệ của iPhone
         - Nếu chọn Origin thì cứ tải xuống và lưu
         */
        var targetSize: CGSize?
        
        if isPortrait {
            if link == "" {
                link = parentVC.photo?.src.portrait ?? ""
            }
            
            targetSize = CGSize(width: screenWidth, height: screenHeight)
            
        } else if isLandscape {
            if link == "" {
                link = parentVC.photo?.src.landscape ?? ""
            }
            
            targetSize = CGSize(width: screenHeight, height: screenWidth)
        }
        
        hud = HUD.hud(kWindow, text: "Downloading".localized(), image: UIImage(named: "icon-download"))
        hud?.isUserInteractionEnabled = true
        
        DownloadImage.shared.downloadImage(link: link) { image in
            DispatchQueue.main.async {
                guard let image = image else {
                    return
                }
                
                func saveImage(image: UIImage) {
//                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveImage), nil)
                    print(link)
                    
                    if let data = image.pngData() {
                        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first {
                            let desURL = url.appendingPathComponent("Wallpee")
                            
                            self.hud?.removeHUD(effect: false, completion: {})
                            
                            do {
                                try FileManager.default.createDirectory(at: desURL, withIntermediateDirectories: true)
                                
                                let toURL = desURL.appendingPathComponent("\(UUID().uuidString).png")
                                try data.write(to: toURL)
                                print("toURL", toURL)
                                
                                self.hud = HUD.hud(kWindow, text: "Downloaded".localized(), image: UIImage(named: "icon-downloaded"), effect: false)
                                self.hud?.isUserInteractionEnabled = true
                                
                                delay(duration: 0.5) {
                                    self.hud?.removeHUD {}
                                    self.parentVC.appStoreReview()
                                }
                                
                            } catch {
                                CustomizeAlert.shared.customizeAlert(
                                    type: .error,
                                    mesTxt: error.localizedDescription) { _ in }
                            }
                        }
                    }
                    
                    self.parentVC.photo?.src.downloaded = true
                    
                    if let photo = self.parentVC.photo {
                        CoreDataStack.savePhoto(model: photo)
                    }
                }
                
                //Portrait || Landscape
                if let targetSize = targetSize {
                    let centerImage = CropImage.shared.cropImage(with: image, by: targetSize, type: .center)
                    
                    if let image = centerImage {
                        saveImage(image: image)
                    }
                    
                    /*
                    var images: [UIImage] = []
                    
                    let group = DispatchGroup()
                    
                    group.enter()
                    if let leftImage = CropImage.shared.cropImage(with: image, by: targetSize, type: .left) {
                        images.append(leftImage)
                        group.leave()
                    }
                    
                    group.enter()
                    if let centerImage = CropImage.shared.cropImage(with: image, by: targetSize, type: .center) {
                        images.append(centerImage)
                        group.leave()
                    }
                    
                    group.enter()
                    if let rightImage = CropImage.shared.cropImage(with: image, by: targetSize, type: .right) {
                        images.append(rightImage)
                        group.leave()
                    }
                    
                    group.notify(queue: .main) {
                        self.hud?.removeHUD(effect: false, completion: {})
                        
                        let height: CGFloat = 20.0 + PhotoLayout.itemH
                        
                        let nextVC = SelectPhotoVC()
                        nextVC.images = images
                        nextVC.modalPresentationStyle = .custom
                        nextVC.transitioningDelegate = self.parentVC
                        nextVC.preferredContentSize = CGSize(width: screenWidth, height: height)
                        
                        self.parentVC.present(nextVC, animated: true)
                    }
                    */
                }
                //Origin
                else {
                    saveImage(image: image)
                }
            }
        }
    }
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        hud?.removeHUD(effect: false, completion: {})
        
        if let error = error {
            CustomizeAlert.shared.customizeAlert(
                type: .error,
                mesTxt: error.localizedDescription) { _ in }
            
        } else {
            hud = HUD.hud(kWindow, text: "Downloaded".localized(), image: UIImage(named: "icon-downloaded"), effect: false)
            hud?.isUserInteractionEnabled = true
            
            delay(duration: 0.5) {
                self.hud?.removeHUD {}
                self.parentVC.appStoreReview()
            }
        }
    }
}

//MARK: - Setup Cell

extension PhotoDetailViewModel {
    
    func contentCVCell(cell: PD_ContentCVCell, indexPath: IndexPath) {
        cell.indexPath = indexPath
        cell.delegate = self
        
        if photos.count > 0 && indexPath.item < photos.count {
            let photo = photos[indexPath.item]
            cell.updateUI(photo: photo, indexPath: indexPath)
        }
    }
}

//MARK: - PD_ContentCVCellDelegate

extension PhotoDetailViewModel: PD_ContentCVCellDelegate {
    
    func favDidTap(cell: PD_ContentCVCell) {
        guard let photo = parentVC.photo else {
            return
        }
        
        if (photo.liked ?? false) == false {
            parentVC.bottomView.favDidTap(vc: parentVC)
        }
    }
}

//MARK: - MorePhotoVCDelegate

extension PhotoDetailViewModel: MorePhotoVCDelegate {
    
    func selectPhoto(vc: MorePhotoVC, photo: PhotoModel) {
        updateNewPhoto(photo: photo)
        updatePhoto()
        
        vc.dismiss(animated: true) {
            if !appDL.isPremium {
                DispatchQueue.main.async {
                    InterstitialViewModel.shared.showAd {
                        self.parentVC.interstitialDidDismiss()
                    }
                    
                    self.parentVC.showInterstitialAd = InterstitialViewModel.shared.isAdAvailable()
                }
            }
        }
    }
}

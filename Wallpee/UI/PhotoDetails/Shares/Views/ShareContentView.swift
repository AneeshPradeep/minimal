//
//  ShareContentView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 13/6/24.
//

import UIKit
import MessageUI
import FacebookShare

class ShareContentView: UIView {
    
    //MARK: - UIView
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var items: [ShareModel] = {
        return ShareModel.shared()
    }()
    
    var shareVC: ShareVC?
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension ShareContentView {
    
    func setupViews(vc: ShareVC) {
        clipsToBounds = true
        backgroundColor = .clear
        vc.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let height: CGFloat = 100.0
        
        //TODO: - CollectionView
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(ShareCVCell.self, forCellWithReuseIdentifier: ShareCVCell.id)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = .horizontal
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: vc.topView.bottomAnchor),
            leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: height),
            
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

extension ShareContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareCVCell.id, for: indexPath) as! ShareCVCell
        let item = items[indexPath.item]
        
        cell.updateUI(item: item)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ShareContentView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        
        switch item.type {
        case .facebook: //Facebook
            shareFacebook()
            break
            
        case .imessage: //iMessage
            shareIMessage()
            break
            
        case .instagram: //Instagram
            shareInstagram()
            break
            
        default: //More
            shareMore()
            break
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ShareContentView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemW = screenWidth / 4
        return CGSize(width: itemW, height: 100.0)
    }
}

//MARK: - Share Facebook

extension ShareContentView {
    
    private func shareFacebook() {
        shareVC?.dismiss(animated: true) {
            if self.checkIfFacebookAppInstalled() {
                func sharePhoto(image: UIImage) {
                    let hud = HUD.hud(kWindow)
                    
                    let photo = SharePhoto(image: image, isUserGenerated: true)
                    let content = SharePhotoContent()
                    content.photos = [photo]
                    //content.contentURL = URL(string: appURL)
                    
                    let dialog = ShareDialog(viewController: sceneDL.window?.rootViewController, content: content, delegate: self)
                    
                    do {
                        try dialog.validate()
                        
                    } catch let error as NSError {
                        print("shareOnMessenger.error: \(error.localizedDescription)")
                    }
                    
                    hud.removeHUD {}
                    
                    dialog.show()
                }
                
                if let image = self.shareVC?.topView.coverImage {
                    sharePhoto(image: image)
                    
                } else {
                    DownloadImage.shared.downloadImage(link: self.shareVC?.photo?.src.medium ?? "") { image in
                        if let image = image?.addWatermark() {
                            sharePhoto(image: image)
                        }
                    }
                }
            }
        }
    }
    
    private func checkIfFacebookAppInstalled() -> Bool {
        var isInstalled = false
        
        guard let url = URL(string: "fb://") else {
            return isInstalled
        }
        
        isInstalled = UIApplication.shared.canOpenURL(url)
        
        if !isInstalled {
            if let url = URL(string: WebService.shared.getFromAPIKeyFile(key: "Facebook")) {
                UIApplication.shared.open(url)
            }
        }
        
        return isInstalled
    }
}

//MARK: - Share iMessage

extension ShareContentView {
    
    private func shareIMessage() {
        let hud = HUD.hud(kWindow)
        hud.isUserInteractionEnabled = false
        
        shareVC?.dismiss(animated: true) {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.body = appURL
            
            func sendText(data: Data) {
                let type = "public.data"
                let fileName = "image.png"
                
                messageVC.addAttachmentData(data, typeIdentifier: type, filename: fileName)
                
                if MFMessageComposeViewController.canSendText() {
                    DispatchQueue.main.async {
                        kWindow.rootViewController?.present(messageVC, animated: true)
                        hud.removeHUD {}
                    }
                    
                } else {
                    CustomizeAlert.shared.customizeAlert(type: .error, mesTxt: "Can't send messages.".localized(), cancelStr: "") { act in }
                    
                    hud.removeHUD {}
                }
            }
            
            let imageData = self.shareVC?.topView.coverData ?? self.shareVC?.topView.coverImage?.pngData()
            
            if let data = imageData {
                sendText(data: data)
                
            } else {
                DownloadImage.shared.downloadImage(link: self.shareVC?.photo?.src.medium ?? "") { image in
                    if let data = image?.addWatermark()?.pngData() {
                        sendText(data: data)
                    }
                }
            }
        }
    }
}

//MARK: - Share Instagram

extension ShareContentView {
    
    private func shareInstagram() {
        let imageData = shareVC?.topView.coverData ?? shareVC?.topView.coverImage?.pngData()
        
        shareVC?.dismiss(animated: true) {
            if imageData == nil {
                DownloadImage.shared.downloadImage(link: self.shareVC?.photo?.src.medium ?? "") { image in
                    if let imageData = image?.addWatermark()?.pngData() {
                        ShareInstagram.shared.shareInstagramStories(imageData: imageData)
                    }
                }
                
            } else {
                ShareInstagram.shared.shareInstagramStories(imageData: imageData)
            }
        }
    }
}

//MARK: - Share More

extension ShareContentView {
    
    private func shareMore() {
        guard let shareVC = shareVC else {
            return
        }
        guard let photo = shareVC.photo else {
            return
        }
        
        var title = photo.alt.capitalized
        
        if title == "" {
            title = NSString(string: photo.url)
                .lastPathComponent
                .components(separatedBy: .letters.inverted)
                .joined(separator: " ")
                .capitalized
        }
        
        let hud = HUD.hud(kWindow)
        hud.isUserInteractionEnabled = false
        
        func shareItem(image: UIImage?) {
            let items = [MyActivityItemSource(title: title, text: appURL, image: image)]
            
            DispatchQueue.main.async {
                let activity = shareVC.createActivityViewController(parentVC: kWindow.rootViewController!, items: items, activities: nil)
                kWindow.rootViewController?.present(activity, animated: true)
                
                hud.removeHUD {}
            }
        }
        
        shareVC.dismiss(animated: true) {
            if let image = shareVC.topView.coverImage {
                shareItem(image: image)
                
            } else {
                DownloadImage.shared.downloadImage(link: photo.src.medium) { image in
                    if let image = image?.addWatermark() {
                        shareItem(image: image)
                    }
                }
            }
        }
    }
}

//MARK: - MFMessageComposeViewControllerDelegate

extension ShareContentView: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
}

//MARK: - SharingDelegate

extension ShareContentView: SharingDelegate {
    
    func sharer(_ sharer: any FBSDKShareKit.Sharing, didCompleteWithResults results: [String : Any]) {}
    
    func sharer(_ sharer: any FBSDKShareKit.Sharing, didFailWithError error: any Error) {}
    
    func sharerDidCancel(_ sharer: any FBSDKShareKit.Sharing) {}
}

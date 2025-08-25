//
//  ShareInstagram.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit

enum OptionsKey: String {
    case stickerImage = "com.instagram.sharedSticker.stickerImage"
    case bgImage = "com.instagram.sharedSticker.backgroundImage"
    case bgVideo = "com.instagram.sharedSticker.backgroundVideo"
    case bgTopColor = "com.instagram.sharedSticker.backgroundTopColor"
    case bgBottomColor = "com.instagram.sharedSticker.backgroundBottomColor"
    case contentUrl = "com.instagram.sharedSticker.contentURL"
}

class ShareInstagram: NSObject {
    
    //MARK: - Properties
    static let shared = ShareInstagram()
    
    private let instagramStories = "instagram-stories://share"
    private let instagramURL = "instagram://"
}

//MARK: - Stories

extension ShareInstagram {
    
    func shareInstagramStories(imageData: Data?) {
        let fbID = WebService.shared.getFromAPIKeyFile(key: "FacebookID")
        let link = "instagram-stories://share?source_application=\(fbID)"
        
        //NOTE: Add it to your Info.plist!, instagram-stories
        guard let url = URL(string: link) else {
            return
        }
        
        let topColor: [String: Any] = [
            OptionsKey.bgTopColor.rawValue: UIColor(hex: 0x636e72)
        ]
        let bottomColor: [String: Any] = [
            OptionsKey.bgBottomColor.rawValue: UIColor(hex: 0xb2bec3)
        ]
        
        if UIApplication.shared.canOpenURL(url) {
            var pasterboardItems: [[String: Any]] = []
            
            if let imageData = imageData {
                pasterboardItems = [
                    [OptionsKey.bgImage.rawValue: imageData],
                    topColor,
                    bottomColor
                ]
            }
            
            UIPasteboard.general.addItems(pasterboardItems)
            UIApplication.shared.open(url)
            
        } else {
            showError()
        }
    }
    
    private func showError() {
        //        CustomizeAlert.shared.customizeAlert(type: .error, mesTxt: "Please install the Instagram application.".localized(), cancelStr: "") { act in }
    }
}

//MARK: - Feed

extension ShareInstagram {
    
    func shareInstagramFeed(image: UIImage?, videoURL: NSURL?, view: UIView, dl: UIDocumentInteractionControllerDelegate) {
        let _ = "https://www.instagram.com/create/story"
        
        guard let url = URL(string: instagramURL) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            let doc = UIDocumentInteractionController()
            
            var path = ""
            
            if let videoURL = videoURL {
                doc.url = videoURL.filePathURL
                
            } else if let image = image {
                path = NSString(string: NSTemporaryDirectory()).appendingPathComponent("instagram.igo")
                
                do {
                    if let data = image.pngData() ?? image.jpegData(compressionQuality: 1.0) {
                        try data.write(to: URL(fileURLWithPath: path), options: .atomic)
                        
                        doc.url = NSURL.fileURL(withPath: path)
                        print("doc.url: \(doc.url?.absoluteString ?? "")")
                    }
                    
                } catch let error as NSError {
                    print("shareInstagramFeed error: \(error.localizedDescription)")
                }
            }
            
            doc.delegate = dl
            doc.uti = "com.instagram.exclusivegram"
            
            doc.presentOptionsMenu(from: .zero, in: view, animated: true)
            
        } else {
            showError()
        }
    }
}

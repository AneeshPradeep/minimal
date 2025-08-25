//
//  UIViewController+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit
import MessageUI

internal extension UIViewController {
    
    func goToShareVC(
        photo: PhotoModel?,
        dl: UIViewControllerTransitioningDelegate)
    {
        let nextVC = ShareVC()
        nextVC.photo = photo
        nextVC.modalPresentationStyle = .custom
        nextVC.transitioningDelegate = dl
        nextVC.preferredContentSize = CGSize(width: screenWidth, height: 271+bottomPadding)
        
        present(nextVC, animated: true)
    }
    
    func createActivityViewController(parentVC: UIViewController, items: [Any], activities: [UIActivity]?) -> UIActivityViewController {
        let activity = UIActivityViewController(activityItems: items, applicationActivities: activities)
        activity.popoverPresentationController?.sourceView = parentVC.view
        activity.popoverPresentationController?.sourceRect = parentVC.view.frame
        activity.completionWithItemsHandler = { (type, finished, items, error) in
            print("activity.type: \(type?.rawValue ?? "NULL")")
            
            if type?.rawValue == "com.apple.UIKit.activity.CopyToPasteboard" {
                //UIPasteboard.general.string = (items?.first as? MyActivityItemSource)?.text
                
                let hud = HUD.hud(parentVC.view, text: "Copied".localized(), image: UIImage(named: "icon-copied"))
                delay(duration: 0.83) {
                    hud.removeHUD {}
                }
            }
        }
        
        activity.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
            UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),
            UIActivity.ActivityType(rawValue: "com.apple.DocumentManagerUICore.SaveToFiles"),
        ]
        
        return activity
    }
    
    func goToSubscriptionVC() {
        let nextVC = SubscriptionVC()
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func goToPhotoDetailVC(
        photo: PhotoModel, 
        placeholderImage: UIImage?,
        transitionAnimator: SharedTransitionAnimator?
    ) {
        let nextVC = PhotoDetailVC()
        nextVC.photo = photo
        nextVC.placeholderImage = placeholderImage
        nextVC.transitionAnimator = transitionAnimator
        nextVC.hidesBottomBarWhenPushed = true
        
        navigationController?.delegate = transitionAnimator
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func goToDownloadedVC() {
        let nextVC = DownloadedVC()
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK: - Menu

internal extension UIViewController {
    
    func languageDidTap() {
        DispatchQueue.main.async {
            let nextVC = LanguageVC()
            nextVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func earnDidTap() {
        DispatchQueue.main.async {
            let nextVC = EarnVC()
            nextVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func termAndConditionDidTap() {
        DispatchQueue.main.async {
            let nextVC = TermAndConditionVC()
            nextVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func supportDidTap(dl: MFMailComposeViewControllerDelegate) {
        DispatchQueue.main.async {
            if MFMailComposeViewController.canSendMail() {
                let mailVC = MFMailComposeViewController()
                mailVC.mailComposeDelegate = dl
                mailVC.setSubject("Support".localized())
                mailVC.setToRecipients([WebService.shared.getFromAPIKeyFile(key: "Email")])
                
                self.present(mailVC, animated: true)
            }
        }
    }
    
    func rateUsDidTap() {
        DispatchQueue.main.async {
            ratingAndReview()
        }
    }
    
    func shareDidTap() {
        DispatchQueue.main.async {
            func shared(image: UIImage?) {
                let title = "Wallpee - Wallpaper HD 4K".localized()
                
                let items: [Any] = [
                    MyActivityItemSource(title: title, text: appURL, image: image)
                ]
                let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
                activity.popoverPresentationController?.sourceView = self.view
                activity.popoverPresentationController?.sourceRect = self.view.frame
                
                self.view.window?.rootViewController?.present(activity, animated: true)
            }
            
            if let shareImage = appDL.shareImage {
                shared(image: shareImage)
                
            } else {
                if let imageURL = Bundle.main.url(forResource: "shareLogo.png", withExtension: nil),
                   let data = try? Data(contentsOf: imageURL)
                {
                    if let shareImage = UIImage(data: data) {
                        shared(image: shareImage)
                    }
                }
            }
        }
    }
    
    func appStoreReview() {
        //Hiển thị Popup Review
        DispatchQueue.main.async {
            AppStoreReviewManager.requestReview()
        }
    }
}

//
//  RewardViewModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 29/11/24.
//

import UIKit
import GoogleMobileAds

class RewardViewModel: NSObject {
    
    //MARK: - Properties
    private var rewardedAd: GADRewardedAd?
    
    private var adDidDismiss: (() -> Void)?
    
    static let shared = RewardViewModel()
}

//MARK: - Load Ad

extension RewardViewModel {
    
    func loadAd() async {
#if DEBUG
        let adUnitID = "ca-app-pub-3940256099942544/1712485313"
#else
        let adUnitID = WebService.shared.getFromAPIKeyFile(key: "RewardedID")
#endif
        
        do {
            rewardedAd = try await GADRewardedAd.load(withAdUnitID: adUnitID, request: GADRequest())
            rewardedAd?.fullScreenContentDelegate = self
            
        } catch {
            print("Rewarded ad failed to load with error: \(error.localizedDescription)")
        }
    }
    
    func isAdAvailable() -> Bool {
        rewardedAd != nil
    }
}

//MARK: - Show Ad

extension RewardViewModel {
    
    func showAd(adDidDismiss: @escaping () -> Void, receivedReward: @escaping (Int) -> Void) {
        guard let rewardedAd = rewardedAd else {
            delay(duration: 1.0) {
                CustomizeAlert.shared.customizeAlert(
                    type: .alert,
                    mesTxt: "There was a problem loading the ad. Please try again later.".localized(),
                    cancelStr: "") { act in }
            }
            
            return
        }
        
        rewardedAd.present(fromRootViewController: nil) {
            let reward = rewardedAd.adReward.amount.intValue
            print("rewardedAd: \(reward)")
            
            receivedReward(reward)
        }
        
        self.adDidDismiss = adDidDismiss
    }
}

//MARK: - GADFullScreenContentDelegate

extension RewardViewModel: GADFullScreenContentDelegate {
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("\(#function) called")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
        adDidDismiss?()
    }
}

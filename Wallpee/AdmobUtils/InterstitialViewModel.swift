//
//  InterstitialViewModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 29/11/24.
//

import UIKit
import GoogleMobileAds

class InterstitialViewModel: NSObject {
    
    //MARK: - Properties
    private var interstitialAd: GADInterstitialAd?
    
    private var adDidDismiss: (() -> Void)?
    
    static let shared = InterstitialViewModel()
}

//MARK: - Load Ad

extension InterstitialViewModel {
    
    func loadAd() async {
#if DEBUG
        let adUnitID = "ca-app-pub-3940256099942544/4411468910"
#else
        let adUnitID = WebService.shared.getFromAPIKeyFile(key: "InterstitialID")
#endif
        
        do {
            interstitialAd = try await GADInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest())
            interstitialAd?.fullScreenContentDelegate = self
            
        } catch {
            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
        }
    }
    
    func isAdAvailable() -> Bool {
        interstitialAd != nil
    }
}

//MARK: - Show Ad

extension InterstitialViewModel {
    
    func showAd(adDidDismiss: @escaping () -> Void) {
        guard let interstitialAd = interstitialAd else {
            return print("Ad wasn't ready.")
        }
        
        //interstitialAd.canPresent(fromRootViewController: nil)
        interstitialAd.present(fromRootViewController: nil)
        
        self.adDidDismiss = adDidDismiss
    }
}

//MARK: - GADFullScreenContentDelegate

extension InterstitialViewModel: GADFullScreenContentDelegate {
    
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

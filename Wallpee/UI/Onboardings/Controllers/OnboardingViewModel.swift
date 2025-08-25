//
//  OnboardingViewModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 24/6/24.
//

import UIKit

class OnboardingViewModel: NSObject {
    
    //MARK: - Properties
    private let parentVC: OnboardingVC
    
    lazy var photos: [PhotoModel] = []
    
    //MARK: - Initializes
    init(parentVC: OnboardingVC) {
        self.parentVC = parentVC
    }
}

//MARK: - Load Data

extension OnboardingViewModel {
    
    func loadPhotos() {
        Task(priority: .userInitiated) {
            let result = try await WebService.shared.loadResult(type: PhotoResult.self, filename: "Onboarding")
            photos = result.photos
            
            let coverUrls = photos.compactMap({
                URL(string: $0.src.medium)
            })
            DownloadImage.shared.batchDownloadImages(coverUrls)
            
            await parentVC.contentView.reloadData()
        }
    }
}

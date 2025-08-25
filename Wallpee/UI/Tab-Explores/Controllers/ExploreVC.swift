//
//  ExploreVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 4/6/24.
//

import UIKit

class ExploreVC: MainVC {
    
    //MARK: - UIView
    let naviView = Ex_NaviView()
    let contentView = Ex_ContentView()
    
    //MARK: - Properties
    private var viewModel: ExploreViewModel!
    
    static var itemW: CGFloat {
        return (screenWidth - 60) / 2
    }
    static var itemH: CGFloat {
        return itemW * 1.4
    }
    
    //Khi chạm 2 lần vào TabBar. Sẽ cuộn về Top
    private var doubleTapObs: Any?
    
    //Khi sử dụng SharedTransitonAnimator
    private var popToObs: Any?
    
    //Khi chọn một Photo từ More. Thay đổi Photo của Cell hiện tại
    private var changePhotoObs: Any?
    
    //Cập nhật Icon Menu
    private var updateMenuIconObs: Any?
    
    private var networkObs: Any?
    
    //Khi didSelect vào Cell
    var selectedCell: Ex_ContentCVCell?
    var selectedIndexPath: IndexPath?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        
        viewModel.loadPhotos()
        
        AppVersion.shared.getCurrentAppVersion()
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

//MARK: - Setup Views

extension ExploreVC {
    
    private func setupViews() {
        viewModel = ExploreViewModel(parentVC: self)
        
        //TODO: - NaviView
        naviView.setupViews(vc: self)
        
        naviView.leftBtn.delegate = self
        naviView.leftBtn.tag = 0
        
        naviView.subscribeView.delegate = self
        naviView.subscribeView.tag = 0
        
        naviView.updateMenuIcon()
        
        //TODO: - ContentView
        contentView.setupViews(vc: self)
        
        contentView.exploreVC = self
        contentView.viewModel = viewModel
        
        contentView.setupDataSourceAndDelegate(dl: contentView)
    }
}

//MARK: - Add Observers

extension ExploreVC {
    
    private func addObservers() {
        removeMyObserver(any: doubleTapObs)
        removeMyObserver(any: popToObs)
        removeMyObserver(any: changePhotoObs)
        
        //Chạm 2 lần TabBar, cuộn về Top
        doubleTapObs = NotificationCenter.default.addObserver(
            forName: .doubleTapKey,
            object: nil,
            queue: .main, using: { notif in
                if let index = notif.object as? Int, index == 0 {
                    if self.viewModel.photos.count > 0 {
                        let indexPath = IndexPath(item: 0, section: 0)
                        self.contentView.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                    }
                }
            })
        
        //Pop từ SharedTransitionAnimator
        popToObs = NotificationCenter.default.addObserver(
            forName: .popToKey,
            object: nil,
            queue: .main, using: { notif in
                self.viewModel.transitionAnimator = nil
                self.navigationController?.delegate = nil
                
                self.selectedCell = nil
                self.selectedIndexPath = nil
            })
        
        //Khi chọn 1 Photo từ MorePhotoVC
        changePhotoObs = NotificationCenter.default.addObserver(
            forName: .changePhotoKey,
            object: nil,
            queue: .main, using: { notif in
                guard let newPhoto = notif.object as? PhotoModel else {
                    return
                }
                guard let indexPath = self.selectedIndexPath else {
                    return
                }
                
                self.viewModel.photos[indexPath.item] = newPhoto
                self.contentView.collectionView.reloadItems(at: [indexPath])
            })
        
        updateMenuIconObs = NotificationCenter.default.addObserver(
            forName: .updateMenuIconKey,
            object: nil,
            queue: .main, using: { notif in
                self.naviView.updateMenuIcon()
            })
        
        networkObs = NotificationCenter.default.addObserver(
            forName: .networkKey,
            object: nil,
            queue: .main, using: { notif in
                self.updateUI()
            })
    }
    
    private func updateUI() {
        let isConnected = NetworkMonitor.shared.isConnected
        
        contentView.isHidden = !isConnected
        naviView.subscribeView.isEnabled = isConnected
        naviView.subscribeView.alpha = isConnected ? 1.0 : 0.5
    }
}

//MARK: - ButtonAnimationDelegate

extension ExploreVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Menu
            viewModel.menuDidTap()
        }
    }
}

//MARK: - ViewAnimationDelegate

extension ExploreVC: ViewAnimationDelegate {
    
    func viewAnimationDidTap(_ sender: ViewAnimation) {
        if sender.tag == 0 { //Pro
            goToSubscriptionVC()
        }
    }
}

//MARK: - SharedTransitioning

extension ExploreVC: SharedTransitioning {
    
    var sharedFrame: CGRect {
        guard let selectedCell = selectedCell,
              let frame = selectedCell.frameInWindow else {
            return .zero
        }
        
        return frame
    }
    
    func prepare(for transition: SharedTransitionAnimator.Transition) {}
}

//
//  PhotoDetailVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit

class PhotoDetailVC: MainVC {
    
    //MARK: - UIView
    let naviView = PD_NaviView()
    let contentView = PD_ContentView()
    let bottomView = PD_BottomView()
    
    private var viewModel: PhotoDetailViewModel!
    
    //MARK: - Properties
    var photo: PhotoModel?
    var placeholderImage: UIImage? //Image từ Medium
    
    var transitionAnimator: SharedTransitionAnimator?
    
    private var newPhotoResultObs: Any?
    
    //Số Coin hiện đang có
    var currentCoin = 0
    
    var showInterstitialAd = false //Hiển thị QC Interstitial
    var showRewardedAd = false //Hiển thị QC RewardedAd
    var downloadedRewardedAd = false //Cho phép Tải xuống hình nền, RewardedAd
    
    //Lần đầu khởi chạy màn hình này
    var firstLaunch = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        addGestureRecognizer()
        
        viewModel.updatePhoto()
        viewModel.loadPhotos()
        
        loadAds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            removeMyObserver(any: newPhotoResultObs)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//MARK: - Setup Views

extension PhotoDetailVC {
    
    private func setupViews() {
        viewModel = PhotoDetailViewModel(parentVC: self)
        
        currentCoin = KeyManager.shared.getCoin() ?? 0
        
        appDL.adCount += 1
        
        //TODO: - ContentView
        contentView.setupViews(vc: self)
        
        contentView.photoDetailVC = self
        contentView.viewModel = viewModel
        
        contentView.setupDataSourceAndDelegate(dl: contentView)
        
        //TODO: - BottomView
        bottomView.setupViews(vc: self)
        
        bottomView.favBtn.delegate = self
        bottomView.favBtn.tag = 2
        
        bottomView.shareBtn.delegate = self
        bottomView.shareBtn.tag = 3
        
        bottomView.moreBtn.delegate = self
        bottomView.moreBtn.tag = 4
        
        bottomView.downloadView.delegate = self
        bottomView.downloadView.tag = 1
        
        bottomView.updateUI(vc: self)
        
        bottomView.updateGETButton(photo: photo)
        
        //TODO: - NaviView
        naviView.setupViews(vc: self)
        
        naviView.leftBtn.delegate = self
        naviView.leftBtn.tag = 0
        
        naviView.coinView.delegate = self
        naviView.coinView.tag = 0
        
        naviView.coinLbl.text = "\(currentCoin)"
    }
}

//MARK: - Add Observers

extension PhotoDetailVC {
    
    private func addObservers() {
        removeMyObserver(any: newPhotoResultObs)
        
        /*
         - Khi truy cập MorePhotoVC
         - Nếu tải thêm PhotoResult thì lưu vào Dictionary
         */
        newPhotoResultObs = NotificationCenter.default.addObserver(
            forName: .newPhotoResultKey,
            object: nil,
            queue: .main, using: { notif in
                if let result = notif.object as? PhotoResult {
                    self.viewModel.photoResult = result
                    
                    if let photo = self.photo {
                        appDL.photoResultDict["\(photo.id)"] = result
                    }
                }
            })
    }
}

//MARK: - Pan

extension PhotoDetailVC {
    
    func addGestureRecognizer() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(recognizer)
    }
    
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        //let translation = recognizer.translation(in: kWindow)
        let velocity = recognizer.velocity(in: kWindow)
        let location = recognizer.location(in: kWindow)
        
        switch recognizer.state {
        case .began:
            //print("translation", translation.x, translation.y)
            //print("velocity", velocity.x, velocity.y)
            //print("location", location.x, location.y)
            
            let isEnable = location.x > 0 && velocity.x > 0 && velocity.y > 0
            
            guard isEnable else {
                return
            }
            
            transitionAnimator?.interactionController = UIPercentDrivenInteractiveTransition()
            transitionAnimator?.start()
            
        case .changed:
            guard transitionAnimator?.interactionController != nil else {
                return
            }
            
            transitionAnimator?.update(recognizer)
            
        case .ended:
            guard transitionAnimator?.interactionController != nil else {
                return
            }
            
            if transitionAnimator?.finished == true {
                transitionAnimator?.finish() {
                    self.navigationController?.popViewController(animated: false)
                }
                
            } else {
                transitionAnimator?.cancel()
            }
            
            transitionAnimator?.interactionController?.cancel()
            transitionAnimator?.interactionController = nil
            
        default:
            transitionAnimator?.interactionController?.cancel()
            transitionAnimator?.interactionController = nil
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension PhotoDetailVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Back
            removeMyObserver(any: newPhotoResultObs)
            
            navigationController?.popViewController(animated: true)
            
        } else if sender.tag == 1 { //Right
            print("Right")
            
        } else if sender.tag == 2 { //Fav
            bottomView.favDidTap(vc: self)
            
        } else if sender.tag == 3 { //Share
            goToShareVC(photo: photo, dl: self)
            
        } else if sender.tag == 4 { //Download
            viewModel.goToMoreVC()
        }
    }
}

//MARK: - ViewAnimationDelegate

extension PhotoDetailVC: ViewAnimationDelegate {
    
    func viewAnimationDidTap(_ sender: ViewAnimation) {
        if sender.tag == 0 { //Coin
            viewModel.earnCoin()
            
        } else if sender.tag == 1 { //GET
            viewModel.getDidTap()
        }
    }
}

//MARK: - UIViewControllerTransitioningDelegate

extension PhotoDetailVC: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

//MARK: - SharedTransitioning

extension PhotoDetailVC: SharedTransitioning {
    
    var sharedFrame: CGRect {
        contentView.frameInWindow ?? .zero
    }
}

//MARK: - Admob

extension PhotoDetailVC {
    
    private func loadAds() {
        if !appDL.isPremium {
            loadInterstitialAd(true)
        }
        
        loadRewardedAd()
    }
    
    private func loadInterstitialAd(_ isShow: Bool) {
        Task(priority: .background) {
            await InterstitialViewModel.shared.loadAd()
            
            if (appDL.adCount > 1) && isShow {
                DispatchQueue.main.async {
                    InterstitialViewModel.shared.showAd {
                        self.interstitialDidDismiss()
                    }
                    
                    self.showInterstitialAd = InterstitialViewModel.shared.isAdAvailable()
                }
            }
        }
    }
    
    private func loadRewardedAd() {
        Task(priority: .background) {
            await RewardViewModel.shared.loadAd()
        }
    }
    
    func interstitialDidDismiss() {
        if showInterstitialAd {
            loadInterstitialAd(false)
        }
        
        if appDL.adCount > 1 && !firstLaunch {
            //Hoạt ảnh di chuyển điểm tròn hướng dẫn
            delay(duration: 1.0) {
                self.contentView.moveTo()
            }
            
            firstLaunch = true
        }
    }
    
    func rewardDidDismiss() {
        if showRewardedAd {
            showRewardedAd = false
            
            loadRewardedAd()
            
            if downloadedRewardedAd {
                downloadedRewardedAd = false
                
                viewModel.downloadWallpaper()
            }
            
            delay(duration: 0.5) {
                (self.view.viewWithTag(4455) as? HUD)?.removeHUD {}
            }
        }
    }
}

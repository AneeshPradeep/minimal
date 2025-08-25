//
//  DownloadedVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 20/6/24.
//

import UIKit

class DownloadedVC: MainVC {
    
    //MARK: - UIView
    let naviView = Down_NaviView()
    let contentView = Down_ContentView()
    
    //MARK: - Properties
    private var viewModel: DownloadedViewModel!
    
    //Khi sử dụng SharedTransitonAnimator
    private var popToObs: Any?
    
    //Khi didSelect vào Cell
    var selectedCell: Down_ContentCVCell?
    var selectedIndexPath: IndexPath?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        
        viewModel.loadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            removeMyObserver(any: popToObs)
        }
    }
}

//MARK: - Setup Views

extension DownloadedVC {
    
    private func setupViews() {
        viewModel = DownloadedViewModel(parentVC: self)
        
        //TODO: - NaviView
        naviView.setupViews(vc: self)
        
        naviView.leftBtn.delegate = self
        naviView.leftBtn.tag = 0
        
        naviView.subscribeView.delegate = self
        naviView.subscribeView.tag = 0
        
        //TODO: - ContentView
        contentView.setupViews(vc: self)
        
        contentView.downloadedVC = self
        contentView.viewModel = viewModel
        
        contentView.setupDataSourceAndDelegate(dl: contentView)
    }
}

//MARK: - Add Observers

extension DownloadedVC {
    
    private func addObservers() {
        removeMyObserver(any: popToObs)
        
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
    }
}

//MARK: - ButtonAnimationDelegate

extension DownloadedVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Back
            navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - ViewAnimationDelegate

extension DownloadedVC: ViewAnimationDelegate {
    
    func viewAnimationDidTap(_ sender: ViewAnimation) {
        if sender.tag == 0 { //Pro
            goToSubscriptionVC()
        }
    }
}

//MARK: - SharedTransitioning

extension DownloadedVC: SharedTransitioning {
    
    var sharedFrame: CGRect {
        guard let selectedCell = selectedCell,
              let frame = selectedCell.frameInWindow else {
            return .zero
        }
        
        return frame
    }
    
    func prepare(for transition: SharedTransitionAnimator.Transition) {}
}

//
//  SubscriptionVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 14/6/24.
//

import UIKit

class SubscriptionVC: MainVC {
    
    //MARK: - UIView
    let naviView = Sub_NaviView()
    let contentView = Sub_ContentView()
    
    var monthlyView: SubscriptionView { return contentView.monthlyView }
    var annualView: SubscriptionView { return contentView.annualView }
    var unlimitedView: SubscriptionView { return contentView.unlimitedView }
    
    private var viewModel: SubscriptionViewModel!
    
    //MARK: - Properties
    private var iapHelperObs: Any?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        
        viewModel.loadProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            removeMyObserver(any: iapHelperObs)
        }
    }
}

//MARK: - Setup Views

extension SubscriptionVC {
    
    private func setupViews() {
        viewModel = SubscriptionViewModel(parentVC: self)
        
        //TODO: - NaviView
        naviView.setupViews(vc: self)
        
        naviView.leftBtn.delegate = self
        naviView.leftBtn.tag = 0
        
        naviView.rightBtn.delegate = self
        naviView.rightBtn.tag = 1
        
        //TODO: - ContentView
        contentView.setupViews(vc: self)
        
        contentView.buyBtn.delegate = self
        contentView.buyBtn.tag = 2
        
        contentView.restoreBtn.delegate = self
        contentView.restoreBtn.tag = 3
        
        contentView.privacyBtn.delegate = self
        contentView.privacyBtn.tag = 4
        
        contentView.termBtn.delegate = self
        contentView.termBtn.tag = 5
        
        monthlyView.delegate = self
        monthlyView.tag = 0
        
        annualView.delegate = self
        annualView.tag = 1
        
        unlimitedView.delegate = self
        unlimitedView.tag = 2
        
        contentView.enableBuyButton(enable: false)
    }
}

//MARK: - Add Observers

extension SubscriptionVC {
    
    private func addObservers() {
        iapHelperObs = NotificationCenter.default.addObserver(
            forName: .IAPHelperNotification,
            object: nil,
            queue: .main,
            using: { notif in
                if let productID = notif.object as? String {
                    if let index = self.viewModel.items.firstIndex(where: {
                        $0.productID == productID
                    }) {
                        self.viewModel.items[index].purchased = true
                        
                        self.viewModel.updateUI()
                    }
                }
            })
    }
}

//MARK: - ButtonAnimationDelegate

extension SubscriptionVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Back
            navigationController?.popViewController(animated: true)
            
        } else if sender.tag == 1 { //Right
            viewModel.infoDidTap()
            
        } else if sender.tag == 2 { //Buy Subscription
            viewModel.buySubscriptionDidTap()
            
        } else if sender.tag == 3 { //Restore Subscription
            ProductID.store.restorePurchase()
            
        } else if sender.tag == 4 { //Privacy Policy
            viewModel.openPrivacyPolicy()
            
        } else if sender.tag == 5 { //Term Of Use
            viewModel.openTermsOfUse()
        }
    }
}

//MARK: - ViewAnimationDelegate

extension SubscriptionVC: ViewAnimationDelegate {
    
    func viewAnimationDidTap(_ sender: ViewAnimation) {
        if sender.tag == 0 { //Monthly
            viewModel.selectedItem = viewModel.items[0]
            contentView.selectedView(index: 0, items: viewModel.items)
            
        } else if sender.tag == 1 { //Annual
            viewModel.selectedItem = viewModel.items[1]
            contentView.selectedView(index: 1, items: viewModel.items)
            
        } else if sender.tag == 2 { //Unlimited
            viewModel.selectedItem = viewModel.items[2]
            contentView.selectedView(index: 2, items: viewModel.items)
        }
    }
}

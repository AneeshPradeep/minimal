//
//  OnboardingVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 24/6/24.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class OnboardingVC: MainVC {
    
    //MARK: - UIView
    let continueBtn = ButtonAnimation()
    let contentView = OnboardingContentView()
    
    //MARK: - Properties
    private var viewModel: OnboardingViewModel!
    
    var currentIndex = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.loadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

//MARK: - Setup Views

extension OnboardingVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        view.clipsToBounds = false
        
        viewModel = OnboardingViewModel(parentVC: self)
        
        let btnW: CGFloat = screenWidth * 0.9
        let btnH: CGFloat = 50.0
        
        let continueGr = createGradient(bounds: CGRect(x: 0.0, y: 0.0, width: btnW, height: btnH))
        let continueColor = convertGradientToColor(gradient: continueGr)
        
        //TODO: - ContinueBtn
        continueBtn.titleLabel?.font = UIFont(name: FontName.montBold, size: 18.0)
        continueBtn.setTitle("CONTINUE".localized(), for: .normal)
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.clipsToBounds = true
        continueBtn.backgroundColor = continueColor
        continueBtn.layer.cornerRadius = btnH/2
        continueBtn.delegate = self
        continueBtn.tag = 0
        view.addSubview(continueBtn)
        continueBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ContentView
        contentView.setupViews(vc: self)
        
        contentView.parentVC = self
        contentView.viewModel = viewModel
        
        contentView.setupDataSourceAndDelegate(dl: contentView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            continueBtn.widthAnchor.constraint(equalToConstant: btnW),
            continueBtn.heightAnchor.constraint(equalToConstant: btnH),
            continueBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(appDL.isIPhoneX ? 0:20)),
        ])
    }
}

//MARK: - ButtonAnimationDelegate

extension OnboardingVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Continue
            currentIndex += 1
            
            if currentIndex == 2 {
                requestIDFA {
                    defaults.set(true, forKey: "firstTime")
                    self.view.window?.rootViewController?.dismiss(animated: true)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                self.contentView.collectionView.setContentOffset(CGPoint(x: screenWidth, y: 0.0), animated: true)
            }
        }
    }
}

//MARK: - AppTrackingTransparency

extension OnboardingVC {
    
    private func requestIDFA(completion: @escaping () -> Void) {
        Task {
            let status = await ATTrackingManager.requestTrackingAuthorization()
            
            switch status {
            case .authorized:
                print("advertisingIdentifier", ASIdentifierManager.shared().advertisingIdentifier)
                break
            case .denied: break
            default: break
            }
            
            completion()
        }
    }
}

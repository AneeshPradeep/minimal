//
//  ShareVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit

class ShareVC: UIViewController {
    
    //MARK: - UIView
    private let blurView = UIVisualEffectView()
    
    let topView = ShareTopView()
    let contentView = ShareContentView()
    
    //MARK: - Properties
    private var originY: CGFloat?
    
    var photo: PhotoModel?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavi()
        
        topView.updateUI(photo: photo)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear - \(type(of: self))")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if originY == nil {
            originY = view.frame.origin.y
        }
    }
}

//MARK: - Setups

extension ShareVC {
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        //TODO: - BlurView
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 42.0
        blurView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TopView
        topView.setupViews(vc: self)
        
        //TODO: - ContentView
        contentView.setupViews(vc: self)
        
        contentView.shareVC = self
        
        contentView.setupDataSourceAndDelegate(dl: contentView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(pan)
    }
    
    private func setupNavi() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

//MARK: - Pan Animation

extension ShareVC {
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        let transition = sender.translation(in: view)
        
        guard transition.y >= 0 else {
            return
        }
        guard let originY = originY else {
            return
        }
        
        switch sender.state {
        case .began, .changed:
            view.frame.origin.y = originY + transition.y
            
            handleDismiss()
            
        case .ended:
            //Nếu vuốt xuống nhanh quá. Thì 'dismiss'
            let velocity = sender.velocity(in: view)
            if velocity.y >= 1300 {
                dismiss(animated: true)
                return
            }
            
            //Ngược lại. Trả về vị trí ban đầu
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = originY
            }
            
            break
            
        default:
            break
        }
    }
    
    private func handleDismiss() {
        if view.frame.origin.y >= screenHeight * 0.8 {
            dismiss(animated: true)
        }
    }
}

//
//  SelectPhotoVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 25/6/24.
//

import UIKit

class SelectPhotoVC: MainVC {
    
    //MARK: - UIView
    let blurView = UIVisualEffectView()
    let topView = SP_TopView()
    let contentView = SP_ContentView()
    
    var contentCV: UICollectionView { return contentView.collectionView }
    
    //MARK: - Properties
    private var originY: CGFloat?
    
    //Left, Center, Right
    lazy var images: [UIImage] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear - \(type(of: self))")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if originY == nil {
            originY = view.frame.origin.y
        }
    }
}

//MARK: - Setup Views

extension SelectPhotoVC {
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        //TODO: - BlurView
        blurView.clipsToBounds = true
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.layer.cornerRadius = 42.0
        blurView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //TODO: - NaviView
        topView.setupViews(vc: self)
        
        //TODO: - ContentView
        contentView.setupViews(vc: self)
        
        contentView.parentVC = self
        
        contentView.setupDataSourceAndDelegate(dl: contentView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(pan)
    }
}

//MARK: - Pan Animation

extension SelectPhotoVC {
    
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

//MARK: - Add Observers

extension SelectPhotoVC {
    
    private func addObservers() {}
}

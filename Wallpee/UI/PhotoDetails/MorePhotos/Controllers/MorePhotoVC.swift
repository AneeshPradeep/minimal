//
//  MorePhotoVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 7/6/24.
//

import UIKit

protocol MorePhotoVCDelegate: AnyObject {
    func selectPhoto(vc: MorePhotoVC, photo: PhotoModel)
}

class MorePhotoVC: MainVC {
    
    //MARK: - UIView
    let blurView = UIVisualEffectView()
    let topView = MP_TopView()
    let contentView = MP_ContentView()
    
    var contentCV: UICollectionView { return contentView.collectionView }
    
    private var viewModel: MorePhotoViewModel!
    
    //MARK: - Properties
    weak var delegate: MorePhotoVCDelegate?
    
    private var newPhotoResultObs: Any?
    
    //Vị trí giới hạn nhỏ nhất cho phép
    private var minY: CGFloat {
        return screenHeight * 0.1
    }
    
    //Giới hạn chiều cao
    private var maxHeight: CGFloat {
        return screenHeight - minY
    }
    
    private var originFrame: CGRect?
    
    //Vị trí hiện tại của UIView
    private var currentFrame: CGRect = .zero
    
    //Chiều cao mặc định của màn hình này
    var defaultHeight: CGFloat = 0.0
    
    //Vị trí theo nội dung
    private var contentY: CGFloat {
        //Chiều cao nội dung
        var contentHeight = CGFloat((viewModel?.photos.count ?? 0) * 100) + defaultHeight
        contentHeight = contentHeight >= maxHeight ? maxHeight : contentHeight
        
        let yPos = contentHeight >= maxHeight ? minY : (screenHeight - contentHeight)
        
        return yPos
    }
    
    //Photo hiện tại. Đang xem từ PhotoDetailVC
    var photo: PhotoModel?
    var photoResult: PhotoResult?
    
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
        removeMyObserver(any: newPhotoResultObs)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if originFrame == nil {
            originFrame = view.frame
        }
    }
}

//MARK: - Setup Views

extension MorePhotoVC {
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        viewModel = MorePhotoViewModel(parentVC: self)
        
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
        
        contentView.morePhotoVC = self
        contentView.viewModel = viewModel
        
        contentView.setupDataSourceAndDelegate(dl: contentView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(pan)
    }
}

//MARK: - Pan Animation

extension MorePhotoVC {
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let transition = sender.translation(in: view)
        let velocity = sender.velocity(in: view).y
        
        guard let originFrame = originFrame else {
            return
        }
        
        switch sender.state {
        case .began:
            if currentFrame == .zero {
                currentFrame = view.frame
            }
            
        case .changed:
            let posY = currentFrame.origin.y + transition.y
            let height = currentFrame.height - transition.y
            
            //Vượt màn hình
            let y = viewModel.photos.count < 0 ? minY : contentY
            if posY <= y {
                print("break")
                break
            }
            
            updateContentSize(yPos: posY, hPos: height)
            
            handleDismiss()
            
        case .ended:
            //Nếu vuốt xuống nhanh quá. Thì 'dismiss'
            if velocity >= 1300 {
                dismiss(animated: true)
                return
            }
            
            //Khi vuốt lên
            if velocity <= 0 && view.frame.origin.y < originFrame.origin.y {
                let y = viewModel.photos.count < 0 ? minY : contentY
                let height = screenHeight - y
                
                UIView.animate(withDuration: 0.3) {
                    self.updateContentSize(yPos: y, hPos: height)
                }
                
                contentCV.isScrollEnabled = true
                
            } else {
                //Khi vuốt xuống. Trả về vị trí ban đầu
                contentCV.isScrollEnabled = false
                
                scrollToTop()
                
                //Vuốt thấp hơn Origin
                if view.frame.origin.y >= originFrame.origin.y {
                    UIView.animate(withDuration: 0.3) {
                        self.updateContentSize(yPos: originFrame.origin.y, hPos: originFrame.height)
                    }
                    
                } else {
                    updateContentSize(yPos: originFrame.origin.y, hPos: originFrame.height)
                }
            }
            
            currentFrame = .zero
            
            break
            
        default:
            break
        }
    }
    
    private func updateContentSize(yPos: CGFloat, hPos: CGFloat) {
        view.frame.origin.y = yPos
        view.frame.size.height = hPos
        preferredContentSize.height = hPos
    }
    
    private func handleDismiss() {
        if view.frame.origin.y >= screenHeight * 0.8 {
            dismiss(animated: true)
        }
    }
    
    private func scrollToTop() {
        DispatchQueue.main.async {
            self.contentCV.setContentOffset(.zero, animated: false)
        }
    }
}

//MARK: - Add Observers

extension MorePhotoVC {
    
    private func addObservers() {
        if photoResult == nil {
            newPhotoResultObs = NotificationCenter.default.addObserver(
                forName: .newPhotoResultKey,
                object: nil,
                queue: .main, using: { notif in
                    if let dict = notif.object as? [String: PhotoResult],
                       let result = dict["result"]
                    {
                        self.photoResult = result
                        self.viewModel.updateData(result: result, hud: nil)
                    }
                })
        }
    }
}

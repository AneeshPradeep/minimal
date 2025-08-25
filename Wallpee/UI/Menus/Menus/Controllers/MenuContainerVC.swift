//
//  MenuContainerVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 9/6/24.
//

import UIKit

protocol MenuContainerVCDelegate: AnyObject {
    func completionAnim(_ isComplete: Bool)
}

class MenuContainerVC: UIViewController {
    
    //MARK: - UIView
    let blurView = UIVisualEffectView()
    
    let sideMenuTVC: MenuTVC
    let centerVC: UINavigationController
    
    private let naviView = UIView()
    private let cancelBtn = ButtonAnimation()
    
    private let logoView = UIView()
    private let logoImageView = UIImageView()
    private let titleLbl = UILabel()
    
    //MARK: - Properties
    weak var delegate: MenuContainerVCDelegate?
    
    static let menuWidth: CGFloat = screenWidth*0.8
    
    private var isOpen = false
    private let animDuration: TimeInterval = 0.33
    
    //MARK: - Initialize
    init(sideMenuTVC: MenuTVC, centerVC: UINavigationController) {
        self.sideMenuTVC = sideMenuTVC
        self.centerVC = centerVC
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

//MARK: - Setups

extension MenuContainerVC {
    
    private func setupViews() {
        view.backgroundColor = .clear
        setNeedsStatusBarAppearanceUpdate()
        
        let naviH = topPadding + 150
        let menuWidth = MenuContainerVC.menuWidth
        
        //TODO: - BlurView
        blurView.frame = CGRect(
            x: -menuWidth,
            y: 0.0,
            width: menuWidth,
            height: screenHeight
        )
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 35.0
        blurView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.addSubview(blurView)
        
        //TODO: - SideMenuTVC
        addChild(sideMenuTVC)
        view.addSubview(sideMenuTVC.view)
        sideMenuTVC.didMove(toParent: self)
        
        centerVC.view.backgroundColor = .clear
        
        //TODO: - NaviView
        naviView.frame = CGRect(
            x: -menuWidth,
            y: 0.0,
            width: menuWidth,
            height: naviH
        )
        naviView.clipsToBounds = true
        naviView.backgroundColor = .clear
        view.addSubview(naviView)
        
        //TODO: - CancelBtn
        let cancelH: CGFloat = 44.0
        
        cancelBtn.frame = CGRect(
            x: 20.0,
            y: statusH+5,
            width: cancelH,
            height: cancelH
        )
        cancelBtn.clipsToBounds = true
        cancelBtn.layer.cornerRadius = cancelH/2
        cancelBtn.setImage(UIImage(named: "icon-cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelBtn.tintColor = .white
        cancelBtn.backgroundColor = UIColor(hex: 0xFFFFFF, alpha: 0.1)
        cancelBtn.delegate = self
        naviView.addSubview(cancelBtn)
        
        //TODO: - LogoView
        let logoH: CGFloat = 100.0
        
        logoView.frame = CGRect(
            x: (menuWidth-logoH)/2,
            y: statusH+5,
            width: logoH,
            height: logoH
        )
        logoView.clipsToBounds = true
        logoView.layer.cornerRadius = logoH/2
        logoView.backgroundColor = .white
        naviView.addSubview(logoView)
        
        logoView.layer.masksToBounds = false
        logoView.layer.shadowColor = UIColor.black.cgColor
        logoView.layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
        logoView.layer.shadowRadius = 3.0
        logoView.layer.shadowOpacity = 0.3
        logoView.layer.shouldRasterize = true
        
        //TODO: - LogoImageView
        logoImageView.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: logoH,
            height: logoH
        )
        logoImageView.clipsToBounds = true
        logoImageView.layer.cornerRadius = logoH/2
        logoImageView.image = UIImage(named: "icon-logo")
        logoImageView.contentMode = .scaleAspectFill
        logoView.addSubview(logoImageView)
        
        //TODO: - TitleLbl
        let titleTxt = "Wallpee"
        let titleFont = UIFont(name: FontName.montExtraBold, size: 25.0)!
        let titleW = titleTxt.estimatedTextRect(fontN: titleFont.fontName, fontS: titleFont.pointSize).width + 10
        
        titleLbl.frame = CGRect(
            x: (menuWidth-titleW)/2,
            y: statusH+5+logoH+5,
            width: titleW,
            height: cancelH
        )
        titleLbl.font = titleFont
        titleLbl.text = titleTxt
        titleLbl.textColor = .white
        titleLbl.textAlignment = .center
        naviView.addSubview(titleLbl)
        
        sideMenuTVC.view.layer.anchorPoint.x = 1.0
        sideMenuTVC.view.frame = CGRect(
            x: -menuWidth,
            y: naviH,
            width: menuWidth,
            height: screenHeight
        )
        
        setMenu(0.0)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(pan)
    }
}

//MARK: - Toggle Menu

extension MenuContainerVC {
    
    func toggleSideMenu() {
        let xPos = floor(sideMenuTVC.view.frame.origin.x/MenuContainerVC.menuWidth)
        let targetProgress: CGFloat = xPos == -1.0 ? 1.0 : 0.0
        
        setAnim(targetProgress)
    }
    
    @objc private func handlePan(_ sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: sender.view!.superview!)
        var progress = translation.x/MenuContainerVC.menuWidth * (isOpen ? 1.0 : -1.0)
        progress = min(max(progress, 0.0), 1.0)
        
        switch sender.state {
        case .began:
            let xPos = floor(sideMenuTVC.view.frame.origin.x/MenuContainerVC.menuWidth)
            self.isOpen = xPos == -1.0 ? true : false
            
            sideMenuTVC.view.layer.shouldRasterize = true
            sideMenuTVC.view.layer.rasterizationScale = UIScreen.current.scale
            
            naviView.layer.shouldRasterize = true
            naviView.layer.rasterizationScale = UIScreen.current.scale
            
        case .changed: 
            setMenu(self.isOpen ? progress : (1 - progress))
            
        case .ended:
            var targetProgress: CGFloat
            if isOpen {
                targetProgress = progress < 0.5 ? 0.0 : 1.0
                
            } else {
                targetProgress = progress < 0.5 ? 1.0 : 0.0
            }
            
            setAnim(targetProgress)
            
        case .cancelled:
            fallthrough
            
        case .failed:
            fallthrough
            
        default: 
            break
        }
    }
}

//MARK: - Animation

extension MenuContainerVC {
    
    private func setAnim(_ percent: CGFloat) {
        UIView.animate(withDuration: animDuration, animations: {
            self.setMenu(percent)
            
        }) { (_) in
            self.naviView.layer.shouldRasterize = false
            self.sideMenuTVC.view.layer.shouldRasterize = false
            
            self.delegate?.completionAnim(percent == 1)
        }
    }
    
    private func setMenu(_ percent: CGFloat) {
        setAlpha(percent, view: blurView, isTrans: true)
        setAlpha(percent, view: sideMenuTVC.view, isTrans: true)
        setAlpha(percent, view: naviView, isTrans: true)
        setAlpha(percent, view: titleLbl, isTrans: false)
        setAlpha(percent, view: cancelBtn, isTrans: false)
    }
    
    private func setAlpha(_ percent: CGFloat, view: UIView, isTrans: Bool) {
        if isTrans {
            view.transform = CGAffineTransform(translationX: MenuContainerVC.menuWidth*percent, y: 0.0)
        }
        
        view.alpha = max(0.2, percent)
    }
}

//MARK: - ButtonAnimationDelegate

extension MenuContainerVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        toggleSideMenu()
        removeEffectFromMenuContainerVC()
    }
}

//MARK: - Create && Remove

func createMenuContainerVC(
    _ navigationController: UINavigationController?,
    menuDL: MenuContainerVCDelegate,
    sideDL: MenuTVCDelegate) -> MenuContainerVC
{
    let side = MenuTVC()
    let menuContainerVC = MenuContainerVC(sideMenuTVC: side, centerVC: navigationController!)
    
    menuContainerVC.view.frame = kWindow.bounds
    menuContainerVC.toggleSideMenu()
    menuContainerVC.delegate = menuDL
    menuContainerVC.sideMenuTVC.delegate = sideDL
    kWindow.addSubview(menuContainerVC.view)
    
    return menuContainerVC
}

func removeMenuContainerVC(with menuContainerVC: MenuContainerVC?) {
    menuContainerVC?.removeFromParent()
    menuContainerVC?.view.removeFromSuperview()
}

func createEffectForMenuContainerVC(target: Any, action: Selector) {
    kWindow.viewWithTag(777999)?.removeFromSuperview()
    
    let bgView = UIView()
    bgView.backgroundColor = .clear
    bgView.frame = CGRect(x: MenuContainerVC.menuWidth, y: 0.0, width: MenuContainerVC.menuWidth, height: screenHeight)
    bgView.tag = 777999
    kWindow.addSubview(bgView)
    
    let tap = UITapGestureRecognizer(target: target, action: action)
    bgView.isUserInteractionEnabled = true
    bgView.addGestureRecognizer(tap)
}

func removeEffectFromMenuContainerVC() {
    kWindow.viewWithTag(777999)?.removeFromSuperview()
}

//
//  ViewController.swift
//  Wallpee
//
//  Created by Thanh Hoang on 3/6/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    //MARK: - UIView
    let exploreVC = ExploreVC()
    let searchVC = SearchVC()
    let favouriteVC = FavouriteVC()
    
    private let barView = UIView()
    private let blurView = UIVisualEffectView()
    private let itemView = UIView()
    
    //MARK: - Properties
    lazy var titles: [String] = [
            "Explore".localized(),
            "Search".localized(),
            "Favorite".localized(),
        ]
    
    //Nhích biểu tượng 0 sang phải && 2 sang trái
    private var imgEdge: CGFloat {
        return 10
    }
    private var itemWidth: CGFloat {
        let edge: CGFloat = 25*2 //Lề trái/phải
        return ((screenWidth/3) - edge - 5*2) + (imgEdge*2)
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            if index == selectedIndex {
                NotificationCenter.default.post(name: .doubleTapKey, object: index)
            }
        }
        
        animationIcon(tabBar: tabBar, item: item)
    }
}

//MARK: - SetupViews

extension TabBarController {
    
    private func setupViews() {
        view.backgroundColor = .white
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = UIImage()
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.clipsToBounds = false
        tabBar.barTintColor = .clear
        tabBar.tintColor = .clear
        tabBar.unselectedItemTintColor = .clear
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.isTranslucent = false
        
        let tabW = tabBar.frame.width
        let tabH = tabBar.frame.height
        
        let edge: CGFloat = 25*2 //Lề trái/phải
        
        let maxW: CGFloat = tabW - edge
        let maxH: CGFloat = 60.0
        
        let posX: CGFloat = (tabW - maxW)/2
        let posY: CGFloat = -(maxH - tabH)
        
        let bounds = CGRect(x: posX, y: posY, width: maxW, height: maxH)
        
        //TODO: - EffectView
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.frame = bounds
        blurView.alpha = 0.9
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = bounds.height/2
        blurView.layer.borderWidth = 1.5
        blurView.layer.borderColor = UIColor.lightGray.cgColor
        
        tabBar.addSubview(blurView)
        
        //TODO: - BarView
        barView.frame = CGRect(x: posX+5, y: posY+5, width: maxW-10, height: maxH-10)
        barView.clipsToBounds = true
        barView.backgroundColor = .clear
        barView.layer.cornerRadius = barView.frame.height/2
        
        tabBar.addSubview(barView)
        
        //TODO: - ItemView
        itemView.frame = CGRect(x: 0.0, y: 0.0, width: itemWidth, height: barView.frame.height)
        itemView.clipsToBounds = true
        itemView.backgroundColor = .white
        itemView.layer.cornerRadius = itemView.frame.height/2
        
        barView.addSubview(itemView)
        
        blurView.isHidden = true
        barView.isHidden = true
        
        //TODO: - ViewControllers
        exploreVC.tabBarItem.image = UIImage(named: "tabBar-explore")?.withRenderingMode(.alwaysOriginal)
        exploreVC.tabBarItem.selectedImage = UIImage(named: "tabBar-exploreFilled")?.withRenderingMode(.alwaysOriginal)
        
        searchVC.tabBarItem.image = UIImage(named: "tabBar-search")?.withRenderingMode(.alwaysOriginal)
        searchVC.tabBarItem.selectedImage = UIImage(named: "tabBar-searchFilled")?.withRenderingMode(.alwaysOriginal)
        
        favouriteVC.tabBarItem.image = UIImage(named: "tabBar-favourite")?.withRenderingMode(.alwaysOriginal)
        favouriteVC.tabBarItem.selectedImage = UIImage(named: "tabBar-favouriteFilled")?.withRenderingMode(.alwaysOriginal)
        
        if defaults.bool(forKey: "firstTime") == false {
            //TODO: - OnboardingVC
            let nextVC = OnboardingVC()
            nextVC.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                self.present(nextVC, animated: false) {
                    self.blurView.isHidden = false
                    self.barView.isHidden = false
                    
                    self.updateTabBar()
                }
            }
            
        } else {
            blurView.isHidden = false
            barView.isHidden = false
            
            updateTabBar()
        }
    }
    
    private func updateTabBar() {
        let naviExplore = NavigationController(rootViewController: exploreVC)
        let naviSearch = NavigationController(rootViewController: searchVC)
        let naviFavourite = NavigationController(rootViewController: favouriteVC)
        
        viewControllers = [naviExplore, naviSearch, naviFavourite]
        
        for i in 0..<tabBar.items!.count {
            let inset: UIEdgeInsets
            
            switch i {
            case 0:
                inset = UIEdgeInsets(top: 0.0, left: imgEdge, bottom: 0.0, right: -imgEdge)
                break
            case 1:
                inset = .zero
                break
            default:
                inset = UIEdgeInsets(top: 0.0, left: -imgEdge, bottom: 0.0, right: imgEdge)
                break
            }
            
            tabBar.items![i].imageInsets = inset
        }
    }
}

//MARK: - Animation

extension TabBarController {
    
    private func getSubview(tabBar: UITabBar, item: UITabBarItem) -> UIView? {
        guard let index = tabBar.items?.firstIndex(of: item) else {
            return nil
        }
        let i: Int
        switch index {
        case 0: i = index + 4; break
        case 1: i = index + 2; break
        default: i = index + 3; break
        }
        
        guard tabBar.subviews.count > i else {
            return nil
        }
        guard let view = tabBar.subviews[i].subviews.compactMap({ $0 }).first else {
            return nil
        }
        
        return view
    }
    
    private func animationIcon(tabBar: UITabBar, item: UITabBarItem) {
        tabBar.selectionIndicatorImage = nil
        
        //Move
        guard let index = tabBar.items?.firstIndex(of: item) else {
            return
        }
        
//        if index == selectedIndex {
//            return
//        }
        
        let space = (barView.frame.width - (itemWidth*3)) / 2
        
        var x: CGFloat = 0.0
        
        switch index {
        case 0:
            x = 0.0
            break
            
        case 1:
            x = (barView.frame.width - itemWidth)/2
            break
            
        case 2:
            x = (itemWidth + space) * 2
            break
            
        default:
            break
        }
        
        UIView.animate(withDuration: 0.25) {
            self.itemView.frame.origin.x = x
            self.view.layoutIfNeeded()
        }
        
        //Animate
        guard let view = getSubview(tabBar: tabBar, item: item) else {
            return
        }
        
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.duration = 0.25
        scaleAnim.fromValue = 0.9
        scaleAnim.toValue = 1.3
        scaleAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scaleAnim.isRemovedOnCompletion = true
        
        view.layer.add(scaleAnim, forKey: "ScaleAnimKey")
    }
}

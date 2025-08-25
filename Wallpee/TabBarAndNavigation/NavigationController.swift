//
//  NavigationController.swift
//  Wallpee
//
//  Created by Thanh Hoang on 4/6/24.
//

import UIKit

class NavigationController: UINavigationController {
    
    //MARK: - Properties
    private var duringPushAnim = false
    
    var darkBarStyle = false
    var barHidden = false
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
        print("\(type(of: self)) deinited 👌🏻")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkBarStyle ? .lightContent : .darkContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return barHidden
    }
}

//MARK: - Setups

extension NavigationController {
    
    func setupViews() {
        delegate = self
        interactivePopGestureRecognizer?.delegate = nil
        
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .white
        
        let titleAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.montBold, size: 18.0)!,
            .foregroundColor: UIColor.black
        ]
        let barNorTitleAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.montBold, size: 17.0)!,
            .foregroundColor: UIColor.black
        ]
        let barDisTitleAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.montBold, size: 17.0)!,
            .foregroundColor: UIColor.darkGray
        ]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = titleAttr
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        let barBtn = UIBarButtonItemAppearance(style: .plain)
        barBtn.normal.titleTextAttributes = barNorTitleAttr
        barBtn.disabled.titleTextAttributes = barDisTitleAttr
        appearance.buttonAppearance = barBtn
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}

//MARK: - UINavigationControllerDelegate

extension NavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipe = navigationController as? NavigationController else {
            return
        }
        
        swipe.duringPushAnim = true
    }
}

//MARK: - UIGestureRecognizerDelegate

extension NavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true
        }
        
        return viewControllers.count > 1 && !duringPushAnim
    }
}

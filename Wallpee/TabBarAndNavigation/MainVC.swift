//
//  MainVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit

class MainVC: UIViewController {
    
    //MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavi()
    }
}

//MARK: - Setup Views

extension MainVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
    }
}

//MARK: - Setup Navi

extension MainVC {
    
    private func setupNavi() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        (navigationController as? NavigationController)?.darkBarStyle = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
}

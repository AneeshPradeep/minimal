//
//  EarnVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 20/6/24.
//

import UIKit

class EarnVC: UIViewController {
    
    //MARK: - UIView
    let naviView = M_NaviView()
    let scrollView = EarnScrollView()
    var contentView: EarnContentView { return scrollView.contentView }
    
    //MARK: - Properties
    static var itemW: CGFloat {
        return (screenWidth - 70) / 4
    }
    static var itemH: CGFloat {
        return itemW * (298/200)
    }
    
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
    }
}

//MARK: - Setups

extension EarnVC {
    
    private func setupViews() {
        //let bgGr = createGradient(bounds: view.bounds)
        //let bgColor = convertGradientToColor(gradient: bgGr)
        
        view.backgroundColor = .white
        
        //TODO: - NaviView
        naviView.setupViews(vc: self)
        naviView.backgroundColor = .clear
        
        naviView.leftBtn.delegate = self
        naviView.leftBtn.tag = 0
        
        //TODO: - ContentView
        scrollView.setupViews(vc: self)
        
        contentView.earnVC = self
        
        contentView.setupDataSourceAndDelegate(dl: contentView)
    }
}

//MARK: - Add Observers

extension EarnVC {
    
    private func addObservers() {
        
    }
}

//MARK: - ButtonAnimationDelegate

extension EarnVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Back
            navigationController?.popViewController(animated: true)
        }
    }
}

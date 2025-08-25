//
//  TermAndConditionVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 20/6/24.
//

import UIKit
import WebKit

class TermAndConditionVC: UIViewController {
    
    //MARK: - Properties
    private let webView = WKWebView()
    
    private let naviView = M_NaviView()
    
    private var hud: HUD?
    
    //MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        hud = HUD.hud(kWindow)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            let fileName = "TermCondition_\(appDL.currentLanguage.code).html"
            
            guard let url = Bundle.main.url(forResource: fileName, withExtension: nil),
                  let data = try? Data(contentsOf: url) else {
                return
            }
            
            let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
            self.webView.load(data, mimeType: "text/html", characterEncodingName: "URF-8", baseURL: baseURL)
            
            self.hud?.removeHUD() {}
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

//MARK: - Setups

extension TermAndConditionVC {
    
    private func setupViews() {
        view.backgroundColor = UIColor(hex: 0xfaeecd)
        
        //TODO: - NaviView
        naviView.setupViews(vc: self)
        
        naviView.leftBtn.delegate = self
        naviView.leftBtn.tag = 0
        
        naviView.titleLbl.text = "T&C".localized()
        
        //TODO: - WebView
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: naviView.bottomAnchor, constant: 20.0),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0),
        ])
    }
}

//MARK: - ButtonAnimationDelegate

extension TermAndConditionVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Back
            navigationController?.popViewController(animated: true)
        }
    }
}

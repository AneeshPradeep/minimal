//
//  PresentationController.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit

class PresentationController: UIPresentationController {
    
    //MARK: - Properties
    private var effectView: UIVisualEffectView!
    private var tapGesture: UITapGestureRecognizer!
    
    private var contentSize: CGSize = .zero
    
    //MARK: - Initializes
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let effect = UIBlurEffect(style: .regular)
        effectView = UIVisualEffectView(effect: effect)
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDidTap))
        
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.isUserInteractionEnabled = true
        effectView.addGestureRecognizer(tapGesture)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let height = containerView!.frame.height
        
        return CGRect(
            x: 0.0,
            y: height * (1 - (contentSize.height/height)),
            width: containerView!.frame.width,
            height: contentSize.height)
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        contentSize = presentedViewController.preferredContentSize
    }
    
    override func presentationTransitionWillBegin() {
        effectView?.alpha = 0.0
        containerView?.addSubview(effectView)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.effectView?.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.effectView?.alpha = 0.0
            
        }, completion: { _ in
            self.effectView?.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.roundCorners(with: [.topLeft, .topRight], radius: appDL.isIPhoneX ? 42:0)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        effectView.frame = containerView!.bounds
    }
    
    @objc private func dismissDidTap() {
        presentedViewController.dismiss(animated: true)
    }
}

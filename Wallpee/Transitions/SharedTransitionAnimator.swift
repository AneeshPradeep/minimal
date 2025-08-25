//
//  SharedTransitionAnimator.swift
//  Wallpee
//
//  Created by Thanh Hoang on 6/6/24.
//

import UIKit

class SharedTransitionAnimator: NSObject {
    
    enum Transition {
        case push
        case pop
    }
    
    struct Context {
        var transitionContext: UIViewControllerContextTransitioning
        var fromFrame: CGRect
        var toFrame: CGRect
        var fromView: UIView
        var toView: UIView
    }
    
    private var context: Context?
    
    private var transition: Transition = .push
    
    //Sử dụng cho Pan
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    /*
     Sử dụng cho Pan
     - finished: true thì pop
     - finished: false, thì cancel
     */
    var finished = false
}

//MARK: - UIViewControllerAnimatedTransitioning

extension SharedTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        prepareViewControllers(from: transitionContext, for: transition)
        
        switch transition {
        case .push:
            pushAnimation(transitionContext: transitionContext)
            
        case .pop:
            popAnimation(transitionContext: transitionContext)
        }
    }
}

//MARK: - Push

extension SharedTransitionAnimator {
    
    private func pushAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let (fromView, fromFrame, toView, toFrame) = setup(with: transitionContext) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let transform: CGAffineTransform = .transform(
            parent: toView.frame,
            soChild: toFrame,
            aspectFills: fromFrame
        )
        toView.transform = transform
        
        toView.viewWithTag(111)?.alpha = 0.0 //Navi
        toView.viewWithTag(222)?.alpha = 0.0 //Bottom
        
        toView.alpha = 0.0
        fromView.alpha = 1.0
        
        UIView.animate(withDuration: 0.25) {
            toView.transform = .identity
            
            toView.alpha = 1.0
            fromView.alpha = 0.0
            
            toView.viewWithTag(111)?.alpha = 1.0 //Navi
            toView.viewWithTag(222)?.alpha = 1.0 //Bottom
            
        } completion: { _ in
            fromView.alpha = 1.0
            
            self.transition = .pop
            
            transitionContext.completeTransition(true)
        }
        
        context = Context(
            transitionContext: transitionContext,
            fromFrame: fromFrame,
            toFrame: toFrame,
            fromView: fromView,
            toView: toView)
    }
}

//MARK: - Pop

extension SharedTransitionAnimator {
    
    private func popAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let (fromView, fromFrame, _, toFrame) = setup(with: transitionContext) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let transform: CGAffineTransform = .transform(
            parent: fromView.frame,
            soChild: fromFrame,
            aspectFills: toFrame
        )
        
        fromView.viewWithTag(111)?.alpha = 0.0 //Navi
        fromView.viewWithTag(222)?.alpha = 0.0 //Bottom
        
        UIView.animate(withDuration: 0.25) {
            fromView.transform = transform
            fromView.alpha = 0.3
            
        } completion: { _ in
            let isCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!isCancelled)
            
            NotificationCenter.default.post(name: .popToKey, object: nil)
        }
    }
}

//MARK: - Pan

extension SharedTransitionAnimator {
    
    func start() {
        guard let context = context else {
            return
        }
        
        context.transitionContext.containerView.insertSubview(context.fromView, belowSubview: context.toView)
    }
    
    func update(_ recognizer: UIPanGestureRecognizer) {
        guard let context = context else {
            return
        }
        
        context.toView.viewWithTag(111)?.alpha = 0.0 //Navi
        context.toView.viewWithTag(222)?.alpha = 0.0 //Bottom
        
        let translation = recognizer.translation(in: kWindow)
        let velocity = recognizer.velocity(in: kWindow)
        
        let progress = translation.x / kWindow.frame.width
        context.transitionContext.updateInteractiveTransition(progress)
        
        var scaleFactor = 1 - progress * 0.4
        scaleFactor = min(max(scaleFactor, 0.6), 1)
        
        finished = (scaleFactor < 0.965) && (velocity.y >= 0)
        
        context.toView.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            .translatedBy(x: translation.x, y: translation.y)
    }
    
    func cancel() {
        guard let context = context else {
            return
        }
        
        context.toView.viewWithTag(111)?.alpha = 1.0 //Navi
        context.toView.viewWithTag(222)?.alpha = 1.0 //Bottom
        
        context.transitionContext.cancelInteractiveTransition()
        
        UIView.animate(withDuration: 0.25) {
            context.toView.transform = .identity
            
        } completion: { _ in
            self.finished = false
            
            context.fromView.removeFromSuperview()
            
            context.transitionContext.completeTransition(true)
        }
    }
    
    func finish(completion: @escaping () -> Void) {
        guard let context = context else {
            return
        }
        
        context.transitionContext.finishInteractiveTransition()
        
        let scaleY = context.fromFrame.height / context.toFrame.height
        
        let offsetX = 0 - (context.fromView.frame.midX - context.fromFrame.midX)
        let offsetY = 0 - (context.fromView.frame.midY - context.fromFrame.midY)
        
        let scaleTransform = CGAffineTransform(scaleX: scaleY, y: scaleY)
        let translationTransform = CGAffineTransform(translationX: offsetX, y: offsetY)
        let transform = scaleTransform.concatenating(translationTransform)
        
        UIView.animate(withDuration: 0.25) {
            context.toView.transform = transform
            context.toView.alpha = 0.3
            
        } completion: { _ in
            self.finished = false
            
            context.transitionContext.completeTransition(true)
            
            NotificationCenter.default.post(name: .popToKey, object: nil)
            
            completion()
        }
    }
}

//MARK: - Helper

extension SharedTransitionAnimator {
    
    private func prepareViewControllers(from context: UIViewControllerContextTransitioning, for transition: Transition) {
        let fromVC = context.viewController(forKey: .from) as? SharedTransitioning
        let toVC = context.viewController(forKey: .to) as? SharedTransitioning
        
        fromVC?.prepare(for: transition)
        toVC?.prepare(for: transition)
    }
    
    private func setup(with context: UIViewControllerContextTransitioning) -> (UIView, CGRect, UIView, CGRect)? {
        guard let toView = context.view(forKey: .to),
              let fromView = context.view(forKey: .from) else {
            return nil
        }
        
        if transition == .push {
            context.containerView.addSubview(toView)
            
        } else {
            context.containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        guard let toFrame = context.sharedFrame(forKey: .to),
              let fromFrame = context.sharedFrame(forKey: .from) else {
            return nil
        }
        
        return (fromView, fromFrame, toView, toFrame)
    }
}

//MARK: - UINavigationControllerDelegate

extension SharedTransitionAnimator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let isFromVC = fromVC is ExploreVC || 
        fromVC is FavouriteVC ||
        fromVC is SearchVC ||
        fromVC is SearchDetailVC ||
        fromVC is DownloadedVC
        
        if isFromVC, toVC is PhotoDetailVC {
            transition = .push
            return self
        }
        
        let isToVC = toVC is ExploreVC || 
        toVC is FavouriteVC ||
        toVC is SearchVC ||
        toVC is SearchDetailVC ||
        toVC is DownloadedVC
        
        if isToVC, fromVC is PhotoDetailVC {
            transition = .pop
            return self
        }
        
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}

//MARK: - UIViewControllerContextTransitioning

extension UIViewControllerContextTransitioning {
    
    func sharedFrame(forKey key: UITransitionContextViewControllerKey) -> CGRect? {
        let viewController = viewController(forKey: key)
        viewController?.view.layoutIfNeeded()
        return (viewController as? SharedTransitioning)?.sharedFrame
    }
}

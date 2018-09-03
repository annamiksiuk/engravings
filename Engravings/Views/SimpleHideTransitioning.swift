//
//  SimpleHideTransitioning.swift
//  Engravings
//
//  Created by Anna Miksiuk on 21.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import UIKit

class SimpleHideTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let presenting: Bool
    var duration: Double = 0.7
    
    init(presenting: Bool) {
        self.presenting = presenting
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let toView = toVC.view,
            let fromView = fromVC.view else { return }
        
        animateTransition(using: transitionContext, fromVC: fromVC, toVC: toVC, fromView: fromView, toView: toView)
        
    }
    
    // MARK: - Private
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning?,
                           fromVC: UIViewController, toVC: UIViewController,
                           fromView: UIView, toView: UIView) {
        
        guard let transitionContext = transitionContext else { return }
        let containerView = transitionContext.containerView
        
        if presenting {
            containerView.addSubview(toView)
            toView.alpha = 0.0
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       animations: {
                        if self.presenting {
                            toView.alpha = 1.0
                        } else {
                            fromView.alpha = 0.0
                        }
        }) { (complete) in
            let success = !transitionContext.transitionWasCancelled
            if !success {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        }
    }
    
}


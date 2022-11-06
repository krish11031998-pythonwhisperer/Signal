//
//  CirclePresentation.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 06/11/2022.
//

import Foundation
import UIKit

fileprivate extension CGRect {
    var minDim: CGFloat { min(width, height) }
}

class CirclePresentation: UIPresentationController {
    
    private var onDismiss: Callback?
    private var originFrame: CGRect
    private lazy var dimmingView: UIView =  {
        let view = UIView()
        view.addBlurView()
        view.layer.opacity = 0
        return view
    }()
    
    init(presentedViewController: UIViewController, presentingViewController: UIViewController?, onDismiss: Callback?, originFrame: CGRect) {
        self.onDismiss = onDismiss
        self.originFrame = originFrame
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    
    override var frameOfPresentedViewInContainerView: CGRect {
        .init(origin: .zero, size: .init(width: .totalWidth, height: .totalHeight))
    }
    
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmingView, at: 0)
        containerView?.setFittingConstraints(childView: dimmingView, insets: .zero)
        dimmingView.layer.opacity = 0
        dimmingView.layer.animate(.fadeIn)
    }
    
    
    override func dismissalTransitionWillBegin() {
        dimmingView.animate(.fadeOut(to: 0)) {
            self.dimmingView.removeFromSuperview()
        }
    }
}

//MARK: - CirclePresentation UIViewControllerTransitioningDelegate

extension CirclePresentation: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
}

//MARK: - CirclePresentation UIViewControllerAnimatedTransitioning

extension CirclePresentation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.3 }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let isPresented = presentedViewController.isBeingPresented
        let key: UITransitionContextViewControllerKey = isPresented ? .to : .from
        
        guard let vc = transitionContext.viewController(forKey: key) else { return }
        
        if isPresented {
            transitionContext.containerView.addSubview(vc.view)
        } else {
            vc.view.removeChildViews()
            vc.view.addSubview(.solidColorView(frame: frameOfPresentedViewInContainerView, backgroundColor: .surfaceBackground))
        }
        
        let presentedFrame = transitionContext.finalFrame(for: vc)
        let dismissedFrame = originFrame
        
        let initialFrame = isPresented ? dismissedFrame : presentedFrame
        let finalFrame = isPresented ? presentedFrame : dismissedFrame
        
        let initialCornerRadius = isPresented ? originFrame.minDim.half : 0
        let finalCornerRadius = isPresented ? 0 : originFrame.minDim.half
        
        let duration = transitionDuration(using: transitionContext)
        
        vc.view.frame = initialFrame
        vc.view.clippedCornerRadius = initialCornerRadius
        UIView.animate(withDuration: duration, delay: 0) {
            vc.view.frame = finalFrame
            vc.view.clippedCornerRadius = finalCornerRadius
        } completion: { isFinished in
            if !isPresented {
                vc.view.removeFromSuperview()
                self.onDismiss?()
            }
            transitionContext.completeTransition(isFinished)
        }
        
    }
    
    
}

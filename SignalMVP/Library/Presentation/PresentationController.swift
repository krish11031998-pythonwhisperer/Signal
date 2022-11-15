//
//  CirclePresentation.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 06/11/2022.
//

import Foundation
import UIKit

//MARK: - PresentationController
class PresentationController: UIPresentationController {
    
    private var onDismiss: Callback?
    public var style: PresentationStyle
    private let addDimmingView: Bool

    private lazy var dimmingView: UIView =  {
        let view = UIView()
        view.addBlurView()
        view.layer.opacity = 0
        return view
    }()
    
    init(style: PresentationStyle, addDimmingView: Bool = true, presentedViewController: UIViewController, presentingViewController: UIViewController?, onDismiss: Callback?) {
        self.addDimmingView = addDimmingView
        self.style = style
        self.onDismiss = onDismiss
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeOnTap)))
    }
    
    
    override var frameOfPresentedViewInContainerView: CGRect { style.frameOfPresentedView }
    
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        guard addDimmingView && style.addDimmingView else { return }
        containerView?.insertSubview(dimmingView, at: 0)
        containerView?.setFittingConstraints(childView: dimmingView, insets: .zero)
        dimmingView.layer.opacity = 0
        dimmingView.layer.animate(.fadeIn())
    }
    
    
    override func dismissalTransitionWillBegin() {
        guard addDimmingView else { return }
        dimmingView.animate(.fadeOut(to: 0)) {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    @objc
    private func closeOnTap() {
        presentedViewController.dismiss(animated: true)
    }
}

//MARK: - CirclePresentation UIViewControllerTransitioningDelegate

extension PresentationController: UIViewControllerTransitioningDelegate {
    
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

extension PresentationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        style.transitionDuration }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let isPresented = presentedViewController.isBeingPresented
        let key: UITransitionContextViewControllerKey = isPresented ? .to : .from
        
        guard let vc = transitionContext.viewController(forKey: key) else { return }
        
        if isPresented {
            transitionContext.containerView.addSubview(vc.view)
        } else {
            if style.removeView {
                vc.view.removeChildViews()
                vc.view.addSubview(.solidColorView(frame: frameOfPresentedViewInContainerView, backgroundColor: .surfaceBackground))
            }
        }
        
        let presentedFrame = transitionContext.finalFrame(for: vc)
        let dismissedFrame = style.originalFrame
        
        let initialFrame = isPresented ? dismissedFrame : presentedFrame
        let finalFrame = isPresented ? presentedFrame : dismissedFrame
        
        let initialCornerRadius = isPresented ? style.cornerRadius : 0
        let finalCornerRadius = isPresented ? 0 : style.cornerRadius
        
        let initialScale = isPresented ? style.initScale : 1
        let finalScale = isPresented ? 1 : style.initScale
        
        let duration = transitionDuration(using: transitionContext)
        
        vc.view.frame = initialFrame
        vc.view.clippedCornerRadius = initialCornerRadius
        vc.view.transform = .init(scaleX: initialScale, y: initialScale)
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut,
                                                                   .layoutSubviews, .overrideInheritedCurve]) {
            vc.view.frame = finalFrame
            vc.view.clippedCornerRadius = finalCornerRadius
            vc.view.transform = .init(scaleX: finalScale, y: finalScale)
        } completion: { isFinished in
            if !isPresented {
                vc.view.removeFromSuperview()
                self.onDismiss?()
            }
            transitionContext.completeTransition(isFinished)
        }
        
    }
    
    
}

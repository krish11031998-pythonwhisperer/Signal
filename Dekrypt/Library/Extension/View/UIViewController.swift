//
//  UIViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/09/2022.
//

import Foundation
import UIKit
import Combine
import Lottie

extension UIViewController {
	
    private static var animatingPropertyKey: UInt8 = 1
    
    private var loadingView: AnimationView? {
        get { return objc_getAssociatedObject(self, &Self.animatingPropertyKey) as? AnimationView }
        set { objc_setAssociatedObject(self, &Self.animatingPropertyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    
    var compressedSize : CGSize {
        let height = view.compressedSize.height.boundTo(lower: 200, higher: .totalHeight) - (view.safeAreaInsets.top + view.safeAreaInsets.bottom)
        let size: CGSize = .init(width: .totalWidth, height: height)
        return size
    }
    
	func setupTransparentNavBar(color: UIColor = .clear, scrollColor: UIColor = .clear) {
		let navbarAppear: UINavigationBarAppearance = .init()
		navbarAppear.configureWithTransparentBackground()
		navbarAppear.backgroundImage = UIImage()
		navbarAppear.backgroundColor = color
		
		self.navigationController?.navigationBar.standardAppearance = navbarAppear
		self.navigationController?.navigationBar.compactAppearance = navbarAppear
		self.navigationController?.navigationBar.scrollEdgeAppearance = navbarAppear
		//self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = scrollColor
	}
	
	func showNavbar() {
		guard let navController = navigationController else { return }
		if navController.isNavigationBarHidden {
			navController.setNavigationBarHidden(false, animated: true)
		}
	}
	
	func hideNavbar() {
		guard let navController = navigationController else { return }
		if !navController.isNavigationBarHidden {
			navController.setNavigationBarHidden(true, animated: true)
		}
	}
	
	static func backButton(_ target: UIViewController) -> UIBarButtonItem {
        let image: UIImage.Catalogue = target.isPresented ? .xMark : .chevronLeft
        let buttonImg = image.image.resized(size: .init(squared: 16))
        let imgView = UIImageView(image: buttonImg.withTintColor(.surfaceBackground))
		imgView.circleFrame = .init(origin: .zero, size: .init(squared: 32))
		imgView.backgroundColor = .surfaceBackgroundInverse
		imgView.contentMode = .center
		let barItem: UIBarButtonItem = .init(image: imgView.snapshot.withRenderingMode(.alwaysOriginal),
											 style: .plain,
											 target: target,
											 action: #selector(target.popViewController))
		return barItem
	}
    
    static func closeButton(_ target: UIViewController) -> UIBarButtonItem {
        let buttonImg = UIImage(systemName: "xmark")?.resized(size: .init(squared: 16)).withTintColor(.surfaceBackground)
        let imgView = UIImageView(image: buttonImg)
        imgView.circleFrame = .init(origin: .zero, size: .init(squared: 32))
        imgView.backgroundColor = .surfaceBackgroundInverse
        imgView.contentMode = .center
        let barItem: UIBarButtonItem = .init(image: imgView.snapshot.withRenderingMode(.alwaysOriginal),
                                             style: .plain,
                                             target: target,
                                             action: #selector(target.popViewController))
        return barItem
    }
	
    var isPresented: Bool {
        guard navigationController?.viewControllers.count == 1 else { return false }
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
	@objc
	func popViewController() {
        if isPresented {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
	}
	
    func standardNavBar(title: RenderableText? = nil,
                        leftBarButton: UIBarButtonItem? = nil,
                        rightBarButton: UIBarButtonItem? = nil,
                        color: UIColor = .surfaceBackground,
                        scrollColor: UIColor = .surfaceBackground) {
		setupTransparentNavBar(color: color, scrollColor: scrollColor)
		navigationItem.titleView = title?.generateLabel
		navigationItem.leftBarButtonItem = leftBarButton ?? Self.backButton(self)
		navigationItem.rightBarButtonItem = rightBarButton
	}
	
    func withNavigationController() -> UINavigationController {
        guard let navVC = self as? UINavigationController else { return .init(rootViewController: self) }
        return navVC
    }
    
    var navBarHeight: CGFloat {
        (navigationController?.navigationBar.frame.height ?? 0) + (navigationController?.additionalSafeAreaInsets.top ?? 0) +
        (navigationController?.additionalSafeAreaInsets.bottom ?? 0)
    }
    
    func pushTo(target: UIViewController) {
        if let nav = navigationController {
            nav.pushViewController(target, animated: true)
        } else {
            self.presentView(style: .sheet(), target: target.withNavigationController(), onDimissal: nil)
        }
    }
    
    func startLoadingAnimation() {
        if loadingView == nil {
            let loadingAnimation = AnimationView(name: "loading")
            loadingAnimation.frame = .init(origin: .zero, size: .init(squared: 40))
            loadingAnimation.loopMode = .loop
            loadingView = loadingAnimation
        }
        
        let loadinViewCard = loadingView ?? .init()
        view.addSubview(loadinViewCard)
        loadinViewCard.center = view.center
        loadingView?.play()
    }
    
    func endLoadingAnimation(completion: Callback? = nil) {
        loadingView?.stop()
        loadingView?.animate(.fadeOut()) {
            self.loadingView?.removeFromSuperview()
            completion?()
        }
    }
}

//MARK: - UIViewController Presentation
extension UIViewController {
    
    func presentView(style: PresentationStyle, addDimmingView: Bool = false, target: UIViewController, onDimissal: Callback?) {
        let presenter = PresentationController(style: style, addDimmingView: addDimmingView, presentedViewController: target, presentingViewController: self, onDismiss: onDimissal)
        target.transitioningDelegate = presenter
        target.modalPresentationStyle = .custom
        present(target, animated: true)
    }
    
}


//MARK: - UIViewController Touches

protocol SwipeListener {
    var panVerticalPoint: CGPoint { get set }
    var direction: CGPoint.Direction { get set }
}

//MARK: - UINavigation View Controller

extension UINavigationController {
    func tabBarItem(_ model: MainTabModel) -> Self {
        tabBarItem = model.tabBarItem
        return self
    }
}

//MARK: - Animate UINavigation

extension UIViewController {
    
    func addScrollObserver() -> AnyCancellable? {
        guard let scroll = view.subviews.first as? UIScrollView,
              let _ = navigationController?.navigationBar
        else { return nil }
        return scroll.publisher(for: \.contentOffset)
            .compactMap {
                (0...20).percent($0.y).boundTo(lower: 0, higher: 1)  == 1
            }
            .removeDuplicates()
            .sink { [weak self] hide in
                if hide {
                    self?.navigationController?.navigationBar.animate(.slide(.up, state: .out, additionalOff: self?.navBarHeight ?? 0))
                } else {
                    self?.navigationController?.navigationBar.animate(.slide(.up, state: .in, additionalOff: self?.navBarHeight ?? 0))
                }
            }
    }
    
    
    
}

//
//  UIViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/09/2022.
//

import Foundation
import UIKit

extension UIViewController {
	
	func setupTransparentNavBar(color: UIColor = .clear, scrollColor: UIColor = .clear) {
		let navbarAppear: UINavigationBarAppearance = .init()
		navbarAppear.configureWithTransparentBackground()
		navbarAppear.backgroundImage = UIImage()
		navbarAppear.backgroundColor = color
		
		self.navigationController?.navigationBar.standardAppearance = navbarAppear
		self.navigationController?.navigationBar.compactAppearance = navbarAppear
		self.navigationController?.navigationBar.scrollEdgeAppearance = navbarAppear
		self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = scrollColor
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
        let buttonImg = UIImage.Catalogue.chevronLeft.image.resized(size: .init(squared: 16))
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
        navigationController?.modalPresentationStyle == .custom || modalPresentationStyle == .custom
    }
    
	@objc
	func popViewController() {
        if isPresented {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
	}
	
	func standardNavBar(title: RenderableText? = nil, leftBarButton: UIBarButtonItem? = nil, rightBarButton: UIBarButtonItem? = nil) {
		setupTransparentNavBar()
		navigationItem.titleView = title?.generateLabel
		navigationItem.leftBarButtonItem = leftBarButton ?? Self.backButton(self)
		navigationItem.rightBarButtonItem = rightBarButton
	}
	
    func withNavigationController() -> UINavigationController {
        guard let navVC = self as? UINavigationController else { return .init(rootViewController: self) }
        return navVC
    }
    
    var navBarHeight: CGFloat {
        (navigationController?.navigationBar.frame.height ?? 0) + (navigationController?.additionalSafeAreaInsets.top ?? 0)
    }
}

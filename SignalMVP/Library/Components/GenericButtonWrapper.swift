//
//  GenericButton.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation
import UIKit


class GenericButtonWrapper: UIView {
	
	private var innerView: UIView?
	private var handler: Callback?
	
	init(innerView: UIView, handler: Callback? = nil) {
		super.init(frame: .zero)
		self.innerView = innerView
		self.handler = handler
		setupView()
		addTapGesture()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func setupView() {
		guard let innerView = innerView else { return }
		addSubview(innerView)
		setFittingConstraints(childView: innerView, insets: .zero)
	}
	
	private func addTapGesture() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		tapGesture.cancelsTouchesInView = true
		addGestureRecognizer(tapGesture)
	}
	
	@objc
	private func handleTap() {
		handler?()
	}
	
}

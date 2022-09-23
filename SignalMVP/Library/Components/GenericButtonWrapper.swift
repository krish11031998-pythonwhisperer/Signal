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
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func setupView() {
		guard let innerView = innerView else { return }
		addSubview(innerView)
		setFittingConstraints(childView: innerView, insets: .zero)
	}
	
	@objc
	private func handleTap() {
		handler?()
	}
	
}

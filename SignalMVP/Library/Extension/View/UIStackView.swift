//
//  UIStackView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import UIKit

extension UIStackView {
	
	func insertAndReplaceArrangedSubview(_ view: UIView, at index: Int) {
		if index > arrangedSubviews.count - 1 {
			addArrangedSubview(view)
		} else {
			let presentView = arrangedSubviews[index]
			presentView.removeFromSuperview()
			insertArrangedSubview(view, at: index)
		}
	}
}

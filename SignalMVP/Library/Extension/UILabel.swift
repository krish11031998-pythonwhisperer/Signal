//
//  UILabel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation
import UIKit

extension UIView {
	
	func blobify(backgroundColor: UIColor = .white.withAlphaComponent(0.2),
				 edgeInset: UIEdgeInsets = .init(vertical: 5, horizontal: 7.5),
				 borderColor: UIColor = .white,
				 borderWidth: CGFloat = 1,
				 cornerRadius: CGFloat = 12) -> UIView {
		let view = embedInView(insets: edgeInset)
		view.backgroundColor = backgroundColor
		view.border(color: borderColor, borderWidth: borderWidth, cornerRadius: cornerRadius)
		return view
	}
	
	func buttonify(handler: Callback?) -> UIView {
		return GenericButtonWrapper(innerView: self, handler: handler)
	}
}


extension Array where Element == String {
	
	func limitTo(to: Int) -> Self {
		count > to ? Array(self[0..<to]) : self
	}
}

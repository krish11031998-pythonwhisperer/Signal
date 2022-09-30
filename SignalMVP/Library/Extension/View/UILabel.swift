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


extension Array {
	
	func limitTo(offset: Int = 0, to: Int, replaceVal: [Self.Element]? = nil) -> Self {
		count >= to ? Array(self[offset..<to]) : replaceVal ?? self
	}
}

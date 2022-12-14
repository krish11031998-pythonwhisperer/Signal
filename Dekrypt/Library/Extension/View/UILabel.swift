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
				 borderColor: UIColor = .clear,
				 borderWidth: CGFloat = 0,
				 cornerRadius: CGFloat = 12) -> UIView {
        let view = embedInView(insets: edgeInset, priority: .needed)
		view.backgroundColor = backgroundColor
		view.border(color: borderColor, borderWidth: borderWidth, cornerRadius: cornerRadius)
		return view
	}
    
    func embedViewInCard(borderColor: UIColor = .clear, borderWidth: CGFloat = 0, cornerRadius: CGFloat = 12) -> UIView {
        let view = blobify(backgroundColor: .surfaceBackground,
                            edgeInset: .init(vertical: 10, horizontal: 12.5),
                            borderColor: borderColor,
                            borderWidth: borderWidth,
                            cornerRadius: cornerRadius)
        return view
    }
}


extension Array {
	
	func limitTo(offset: Int = 0, to: Int, replaceVal: [Self.Element]? = nil) -> Self {
		count >= to ? Array(self[offset..<to]) : replaceVal ?? self
	}
}

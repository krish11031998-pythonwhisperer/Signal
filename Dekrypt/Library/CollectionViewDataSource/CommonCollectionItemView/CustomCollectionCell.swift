//
//  CustomCollectionCell.swift
//  ZeamFinance
//
//  Created by Krishna Venkatramani on 10/10/2022.
//

import Foundation
import UIKit

struct CustomCollectionCellModel: ActionProvider {
	let view: UIView
	let inset: UIEdgeInsets?
	let top: CGFloat?
	let leading: CGFloat?
	let bottom: CGFloat?
	let trailing: CGFloat?
	var action: Callback?
	
	init(view: UIView, inset: UIEdgeInsets? = nil, top: CGFloat? = nil, leading: CGFloat? = nil, bottom: CGFloat? = nil, trailing: CGFloat? = nil, action: Callback? = nil) {
		self.view = view
		self.inset = inset
		self.top = top
		self.leading = leading
		self.bottom = bottom
		self.trailing = trailing
		self.action = action
	}
}



class CustomCollectionCell: ConfigurableCollectionCell {
	
	func configure(with model: CustomCollectionCellModel) {
		contentView.removeChildViews()
		backgroundColor = .black
		contentView.addSubview(model.view)
		if let validInset = model.inset {
			contentView.setFittingConstraints(childView: model.view, insets: validInset)
		} else {
			contentView.setFittingConstraints(childView: model.view,
											  top: model.top,
											  leading: model.leading,
											  trailing: model.trailing,
											  bottom: model.bottom)
		}
		
	}
	
}


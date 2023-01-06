//
//  CustomTableCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 04/10/2022.
//

import Foundation
import UIKit

struct CustomTableCellModel: ActionProvider {
	let view: UIView
	let inset: UIEdgeInsets?
	let top: CGFloat?
	let leading: CGFloat?
	let bottom: CGFloat?
	let trailing: CGFloat?
	let width: CGFloat?
	let height: CGFloat?
	let name: String
	var action: Callback?
	
	init(view: UIView,
		 inset: UIEdgeInsets? = nil,
		 top: CGFloat? = nil,
		 leading: CGFloat? = nil,
		 bottom: CGFloat? = nil,
		 trailing: CGFloat? = nil,
		 width: CGFloat? = nil,
		 height: CGFloat? = nil,
		 name:String = "",
		 action: Callback? = nil) {
		self.view = view
		self.inset = inset
		self.top = top
		self.leading = leading
		self.bottom = bottom
		self.trailing = trailing
		self.width = width
		self.height = height
		self.name = name
		self.action = action
	}
}


class CustomTableCell: ConfigurableCell {
	
	func configure(with model: CustomTableCellModel) {
		contentView.removeChildViews()
		selectionStyle = .none
		backgroundColor = .surfaceBackground
		contentView.addSubview(model.view)
		contentView.setFittingConstraints(childView: model.view,
										  top: model.inset?.top ?? model.top,
										  leading: model.inset?.left ?? model.leading,
										  trailing: model.inset?.right ?? model.trailing,
										  bottom: model.inset?.bottom ?? model.bottom,
										  width: model.width,
										  height: model.height, priority: .needed)
	}
	
	static var cellName: String? {
		return "CustomCell.\(UUID().uuidString)"
	}
	
}

//
//  CollectionSection.swift
//  ZeamFinance
//
//  Created by Krishna Venkatramani on 04/10/2022.
//

import Foundation
import UIKit

class CollectionSection {
	let cell: [CollectionCellProvider]
	let customHeader: UIView?
	let customFooter: UIView?
	let title: String?
	
	init(cell: [CollectionCellProvider],
		 customHeader: UIView? = nil,
		 customFooter: UIView? = nil,
		 title: String? = nil) {
		self.cell = cell
		self.customHeader = customHeader
		self.customFooter = customFooter
		self.title = title
	}
}



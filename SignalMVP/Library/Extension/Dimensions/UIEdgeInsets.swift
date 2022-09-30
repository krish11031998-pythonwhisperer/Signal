//
//  UIEdgeInsets.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 19/09/2022.
//

import Foundation
import UIKit

extension UIEdgeInsets {
	
	init(by: CGFloat) {
		self.init(top: by, left: by, bottom: by, right: by)
	}
	
	init(vertical: CGFloat, horizontal: CGFloat) {
		self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}
}

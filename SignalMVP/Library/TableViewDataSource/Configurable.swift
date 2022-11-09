//
//  ConfigurableCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit

typealias Callback = () -> Void

protocol Configurable {
	associatedtype Model
	func configure(with model: Model)
}

protocol ActionProvider {
	var action: Callback? { get }
    var actionWithFrame: ((CGRect) -> Void)? { get }
}

extension ActionProvider {
    var actionWithFrame: ((CGRect) -> Void)? { nil }
}

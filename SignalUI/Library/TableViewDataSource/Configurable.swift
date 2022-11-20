//
//  ConfigurableCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit

public typealias Callback = () -> Void

public protocol Configurable {
	associatedtype Model
	func configure(with model: Model)
}

public protocol ActionProvider {
	var action: Callback? { get }
}

//
//  Array.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation

public extension Array {
	var emptyOrNil: [Self.Element]? {
		isEmpty ? nil : self
	}
}

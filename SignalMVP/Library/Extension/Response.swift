//
//  Response.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 27/09/2022.
//

import Foundation

typealias Response<T> = (Result<T,Error>) -> Void

extension Result {
	
	var data: Success? {
		switch self {
		case .success(let data):
			return data
		default:
			return nil
		}
	}
	
}

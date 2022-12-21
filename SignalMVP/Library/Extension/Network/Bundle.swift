//
//  Bundle.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation


extension Bundle {
	
	func loadDataFromBundle<T:Codable>(name: String, extensionStr: String) -> Result<T,Error> {
		guard let url = url(forResource: name, withExtension: extensionStr),
			  let data = try? Data(contentsOf: url)
		else {
			return .failure(URLSessionError.invalidUrl)
		}
		
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
			return .failure(URLSessionError.decodeErr)
		}
		
		return .success(decodedData)
	}
}

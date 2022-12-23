//
//  Bundle.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import Combine

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
    
    func loadDataFromBundle<T:Codable>(name: String, extensionStr: String) -> AnyPublisher<T,Error> {
        Just((name, extensionStr))
            .compactMap { url(forResource: $0.0, withExtension: $0.1) }
            .tryMap {
                try Data(contentsOf: $0)
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

//
//  NetworkReqeust.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
 
protocol EndPoint {
	associatedtype CodableModel
	var scheme: String { get }
	var baseUrl: String { get }
	var path: String { get }
	var queryItems: [URLQueryItem] { get }
	var request: URLRequest? { get }
	var header: [String : String]? { get }
	func fetch(completion: @escaping (Result<CodableModel,Error>) -> Void)
}

extension EndPoint {
	
	var header: [String : String]? {
		return nil
	}
	
	var request: URLRequest? {
		var uC = URLComponents()
		uC.scheme = scheme
		uC.host = baseUrl
		uC.path = path
		uC.queryItems = queryItems
		
		guard let url = uC.url  else {
			return nil
		}
		
		var request: URLRequest = .init(url: url)
		request.allHTTPHeaderFields = header
		return request
	}
	
}

protocol CacheSubscript {
	subscript(_ key: String) -> Data? { get set }
}

struct DataCache {
	private let cache: NSCache<NSString,NSData> = { .init() }()

	public static var shared: DataCache = .init()
}

extension DataCache: CacheSubscript {
	
	subscript(key: String) -> Data? {
		get {
			let validKey = key as NSString
			return cache.object(forKey: validKey) as? Data
		}
		
		set {
			let validKey = key as NSString
			if let _ = cache.object(forKey: validKey) {
				cache.removeObject(forKey: validKey)
			}
			
			if let validData = newValue as? NSData {
				cache.setObject(validData, forKey: validKey)
			}
			
		}
	}
}



enum URLSessionError: Error {
	case noData
	case invalidUrl
	case decodeErr
}


extension URLSession {

	static func urlSessionRequest<T: Codable>(request: URLRequest, completion: @escaping (Result<T,Error>) -> Void) {
		
		guard let validUrlStr = request.url?.absoluteString else {
			completion(.failure(URLSessionError.invalidUrl))
			return
		}
		
		if let cachedData = DataCache.shared[validUrlStr] {
			if let deceodedData = try? JSONDecoder().decode(T.self, from: cachedData) {
				completion(.success(deceodedData))
			} else {
				completion(.failure(URLSessionError.decodeErr))
			}
		} else {
			let session = URLSession.shared.dataTask(with: request) { data, resp , err in
				guard let validData = data else {
					completion(.failure(err ?? URLSessionError.noData))
					return
				}
				
				guard let decodedData = try? JSONDecoder().decode(T.self, from: validData) else {
					completion(.failure(URLSessionError.decodeErr))
					return
				}
				
				if let validURLString = request.url?.absoluteString {
					DataCache.shared[validURLString] = validData
				}
				
				completion(.success(decodedData))
			}
			session.resume()
		}
	}
	
}

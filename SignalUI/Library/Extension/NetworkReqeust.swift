//
//  NetworkReqeust.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
 
public protocol EndPoint {
	associatedtype CodableModel
	var scheme: String { get }
	var baseUrl: String { get }
	var path: String { get }
	var queryItems: [URLQueryItem] { get }
	var request: URLRequest? { get }
	var header: [String : String]? { get }
	func fetch(completion: @escaping (Result<CodableModel,Error>) -> Void)
}

public extension EndPoint {
	
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
	subscript(_ request: URLRequest) -> Data? { get }
}


extension URLCache: CacheSubscript {
	
	subscript(request: URLRequest) -> Data? {
		get {
			return URLCache.shared.cachedResponse(for: request)?.data
		}
	}
}

public struct DataCache {
	static var shared: DataCache = .init()
	
	var cache: NSCache<NSURLRequest,NSData> = {
		let cache = NSCache<NSURLRequest,NSData>()
		return cache
	}()
}

extension DataCache: CacheSubscript {
	subscript(request: URLRequest) -> Data? {
		get {
			return cache.object(forKey: request as NSURLRequest) as? Data
		}
		
		set {
			guard let validData = newValue as? NSData else { return }
			cache.setObject(validData, forKey: request as NSURLRequest)
		}
	}
}


public enum URLSessionError: Error {
	case noData
	case invalidUrl
	case decodeErr
}


public extension URLSession {

	static func urlSessionRequest<T: Codable>(request: URLRequest, completion: @escaping (Result<T,Error>) -> Void) {
		print("(DEBUG) Request: \(request.url?.absoluteString)")
		if let cachedData = DataCache.shared[request] {
			if let deceodedData = try? JSONDecoder().decode(T.self, from: cachedData) {
				completion(.success(deceodedData))
			} else {
				completion(.failure(URLSessionError.decodeErr))
			}
		} else {
			let session = URLSession.shared.dataTask(with: request) { data, resp , err in
				guard let validData = data, let validResponse = resp else {
					completion(.failure(err ?? URLSessionError.noData))
					return
				}
				
				guard let decodedData = try? JSONDecoder().decode(T.self, from: validData) else {
					completion(.failure(URLSessionError.decodeErr))
					return
				}
				
				DataCache.shared[request] = validData
				
				completion(.success(decodedData))
			}
			session.resume()
		}
	}
	
}

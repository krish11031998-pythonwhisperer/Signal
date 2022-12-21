//
//  NetworkReqeust.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import Combine
protocol EndPoint {
	var scheme: String { get }
	var baseUrl: String { get }
	var path: String { get }
	var queryItems: [URLQueryItem] { get }
	var request: URLRequest? { get }
	var header: [String : String]? { get }
    func fetch<CodableModel: Codable>() -> Future<CodableModel,Error>
}


extension EndPoint {
	
    var baseUrl: String {
        return "signal.up.railway.app"
    }
    
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
    
    func fetch<CodableModel: Codable>() -> Future<CodableModel, Error> {
        guard let validRequest = request else {
            return Future { $0(.failure(URLSessionError.invalidUrl))}
        }
        return URLSession.urlSessionRequest(request: validRequest)
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

struct DataCache {
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


enum URLSessionError: String, Error {
	case noData
	case invalidUrl
	case decodeErr
}


extension URLSession {

	static func urlSessionRequest<T: Codable>(request: URLRequest, completion: @escaping (Result<T,Error>) -> Void) {
		print("(REQUEST) Request: \(request.url?.absoluteString)")
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
	
//    static var standardDecoder: JSONDecoder {
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        return decoder
//    }
    
    static func urlSessionRequest<T: Codable>(request: URLRequest) -> Future<T,Error> {
        Future { promise in
            print("(REQUEST w Future) Request: \(request.url?.absoluteString)")
            if let cachedData = DataCache.shared[request] {
                if let deceodedData = try? JSONDecoder().decode(T.self, from: cachedData) {
                    promise(.success(deceodedData))
                } else {
                    promise(.failure(URLSessionError.decodeErr))
                }
            } else {
                let session = URLSession.shared.dataTask(with: request) { data, resp , err in
                    guard let validData = data, let validResponse = resp else {
                        promise(.failure(err ?? URLSessionError.noData))
                        return
                    }
                    
                    guard let decodedData = try? JSONDecoder().decode(T.self, from: validData) else {
                        promise(.failure(URLSessionError.decodeErr))
                        return
                    }
                    
                    DataCache.shared[request] = validData
                    
                    promise(.success(decodedData))
                }
                session.resume()
            }
        }
    }
}

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
    var method: String { get }
	var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
	var request: URLRequest? { get }
	var header: [String : String]? { get }
    func execute<CodableModel: Codable>() -> Future<CodableModel,Error>
}


extension EndPoint {
	
    var scheme: String {
        return "https"
    }
    
    var debugBaseUrl: String  {
        return ""
    }
    var baseUrl: String {
        return "signal.up.railway.app"
    }
    
    var method: String {
        return "GET"
    }
    
	var header: [String : String]? {
		return nil
	}
    
    var body: Data? {
        nil
    }
	
	var request: URLRequest? {
		var uC = URLComponents()
		uC.scheme = scheme
		uC.host = baseUrl
		uC.path = path
        uC.queryItems = queryItems.emptyOrNil
		
		guard let url = uC.url  else {
			return nil
		}
		
		var request: URLRequest = .init(url: url)
		request.allHTTPHeaderFields = header
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method
        if let body {
            print("(DEBUG) body: ", String(data: body, encoding: .utf8))
        }
		return request
	}
    
    func execute<CodableModel: Codable>() -> Future<CodableModel, Error> {
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

	
    
    static func urlSessionRequest<T: Codable>(request: URLRequest) -> Future<T,Error> {
        Future { promise in
            print("(REQUEST w Future) Request: \(request.url?.absoluteString)")
            if let cachedData = DataCache.shared[request] {
                if let deceodedData = try? JSONDecoder().decode(T.self, from: cachedData) {
                    print("(DEBUG) returning Cached Response!")
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

//
//  UIImageView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit

enum ImageError: Swift.Error {
	case noImagefromData
}

//MARK: - Catalogue
extension UIImage {
	
	enum Catalogue: String {
		case bullish = "arrow.up.circle"
		case bearish = "arrow.down.circle"
		case `true` = "checkmark.shield"
		case `false` = "xmark.shield"
	}
}

extension UIImage.Catalogue {
	
	var image: UIImage? { .init(systemName: rawValue) }
}

//MARK: - Helpers
extension UIImage {

	func resized(size newSize: CGSize) -> UIImage {
		let renderer = UIGraphicsImageRenderer(size: newSize)
		let img = renderer.image(actions: { _ in draw(in: .init(origin: .zero, size: size))})
		return img
	}
	
	static func download(urlStr: String, completion: @escaping (Result<UIImage,Error>) -> Void) {
		
		if let cachedData = DataCache.shared[urlStr] {
			if let validImage = UIImage(data: cachedData) {
				completion(.success(validImage))
			} else {
				completion(.failure(ImageError.noImagefromData))
			}
		} else {
			guard let url = URL(string: urlStr) else {
				completion(.failure(URLSessionError.invalidUrl))
				return
			}
			let session = URLSession.shared.dataTask(with: url) { data, resp, err in
				guard let validData = data else {
					completion(.failure(err ?? URLSessionError.noData))
					return
				}
				
				guard let validImage = UIImage(data: validData) else {
					completion(.failure(ImageError.noImagefromData))
					return
				}
				
				DataCache.shared[urlStr] = validData
				completion(.success(validImage))
			}
			session.resume()
		}
	}
	
	static func loadImage<T:AnyObject>(url urlString: String, at object: T, path: ReferenceWritableKeyPath<T,UIImage?>, resized: CGSize? = nil) {
		download(urlStr: urlString) { result in
			switch result {
			case .success(let img):
				DispatchQueue.main.async {
					if let size = resized {
						object[keyPath: path] = img.resized(size: size)
					} else {
						object[keyPath: path] = img
					}
					
				}
			case .failure(let err):
				print("(DEBUG) err while loading Image : ",err.localizedDescription)
			}
		}
	}
	
}



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


fileprivate extension String {
	
	var request: URLRequest? {
		if let validURL = URL(string: self) {
			return .init(url: validURL)
		} else {
			return nil
		}
	}
}

//MARK: - Catalogue
extension UIImage {
	
	enum SystemCatalogue: String {
		case bullish = "arrow.up.circle"
		case bearish = "arrow.down.circle"
		case `true` = "checkmark.shield"
		case `false` = "xmark.shield"
	}
}

extension UIImage.SystemCatalogue {
	
	var image: UIImage? { .init(systemName: rawValue) }
}

//MARK: - Helpers
extension UIImage {

	func resized(size newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in self.draw(in: CGRect(origin: .zero, size: newSize)) }
        let newImage = image.withRenderingMode(renderingMode)
        return newImage
	}
    
    func resized(withAspect to: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: to)
        let newSize = resolveWithAspectRatio(newSize: to)
        let newOrigin: CGPoint = .init(x: (to.width - newSize.width).half , y: (to.height - newSize.height).half)
        let img = renderer.image { _ in self.draw(in: .init(origin: newOrigin, size: newSize))}
        return img
    }
    
    func scaleImageToNewSize(newSize: CGSize) -> UIImage {
        let ratio = size.width/size.height
        var scaledSize: CGSize = .zero
        if size.height < size.width {
            scaledSize = .init(width: ratio * newSize.height, height: newSize.height)
        } else {
            scaledSize = .init(width: newSize.width, height: newSize.width/ratio)
        }
        return resized(size: scaledSize)
    }
    
    func resolveWithAspectRatio(newSize: CGSize) -> CGSize {
        
        let ratio = size.width/size.height
        
        if size.width < size.height {
            let newHeight = min(size.height, newSize.height)
            return .init(width: newHeight * ratio, height: newHeight)
            
        } else {
            let newWidth = min(size.width, newSize.width)
            return .init(width: newWidth, height: newWidth/ratio)
        }
    }
	
	static func download(urlStr: String? = nil, request: URLRequest? = nil, completion: @escaping (Result<UIImage,Error>) -> Void) {
		
		let request: URLRequest? =  urlStr?.request ?? request
		
		if let validRequest = request, let cachedData = URLCache.shared[validRequest] {
			if let validImage = UIImage(data: cachedData) {
				completion(.success(validImage))
			} else {
				completion(.failure(ImageError.noImagefromData))
			}
		} else {
			guard let validRequest = request else {
				completion(.failure(URLSessionError.invalidUrl))
				return
			}
			let session = URLSession.shared.dataTask(with: validRequest) { data, resp, err in
				guard let validData = data, let validResp = resp else {
					completion(.failure(err ?? URLSessionError.noData))
					return
				}
				
				guard let validImage = UIImage(data: validData) else {
					completion(.failure(ImageError.noImagefromData))
					return
				}
				
				URLCache.shared.storeCachedResponse(.init(response: validResp, data: validData), for: validRequest)
				completion(.success(validImage))
			}
			session.resume()
		}
	}
	
	func imageView(size: CGSize = .smallestSquare, cornerRadius: CGFloat = .zero) -> UIImageView {
		let view = UIImageView(frame: size.frame)
		view.image = self
		view.contentMode = .scaleAspectFit
		view.clipsToBounds = true
		view.cornerRadius = cornerRadius
		return view
	}
	
	static func solid(color: UIColor, frame: CGSize = .smallestSquare) -> UIImage {
		let view = UIView(frame: .init(origin: .zero, size: frame))
		view.backgroundColor = color
		return view.snapshot
	}
	
	
    static func loadImage<T:AnyObject>(url urlString: String?, at object: T, path: ReferenceWritableKeyPath<T,UIImage?>, resized: CGSize? = nil, resolveWithAspectRatio: Bool = false, scaledAt: Bool = false) {
		download(urlStr: urlString) { result in
			switch result {
			case .success(let img):
				DispatchQueue.main.async {
					if let size = resized {
                        if resolveWithAspectRatio {
                            object[keyPath: path] = img.resized(withAspect: size)
                        } else if scaledAt {
                            object[keyPath: path] = img.scaleImageToNewSize(newSize: size)
                        }else {
                            object[keyPath: path] = img.resized(size: size)
                        }
						
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



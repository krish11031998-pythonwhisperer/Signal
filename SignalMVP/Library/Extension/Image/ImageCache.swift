//
//  ImageCache.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 27/12/2022.
//

import Foundation
import UIKit

protocol ImageCacheSubscript {
    subscript(request: URLRequest) -> UIImage? { get set }
}

//MARK: - ImageCache
class ImageCache {
    
    let dataCache: NSCache<NSURLRequest, UIImage> = {
        let cache = NSCache<NSURLRequest, UIImage>()
        return cache
    }()
    
    static var shared: ImageCache = .init()
    
}

extension ImageCache: ImageCacheSubscript {
    
    subscript(request: URLRequest) -> UIImage? {
        get {
            guard let image = dataCache.object(forKey: request as NSURLRequest) else { return nil }
            return image
        }
        set {
            let nsReq = request as NSURLRequest
            if let _ = dataCache.object(forKey: nsReq) {
                dataCache.removeObject(forKey: nsReq)
            }
            
            if let validImage = newValue {
                dataCache.setObject(validImage, forKey: nsReq)
            }
        }
    }
    
}

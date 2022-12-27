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
    
    lazy var dataCache: DataCache = .init()
    
    static var shared: ImageCache = .init()
    
}

extension ImageCache: ImageCacheSubscript {
    
    subscript(request: URLRequest) -> UIImage? {
        get {
            guard let imgData = dataCache[request] else { return nil }
            return UIImage(data: imgData)
        }
        set {
            dataCache[request] = newValue?.pngData()
        }
    }
    
}

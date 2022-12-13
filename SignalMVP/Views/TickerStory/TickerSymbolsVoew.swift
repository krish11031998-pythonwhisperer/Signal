//
//  TickerSymbolsVoew.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 13/11/2022.
//

import Foundation
import UIKit

@propertyWrapper
struct TickerSymbolView {
    
    var wrappedValue: UIView
    
    init() {
        self.wrappedValue = .init()
    }
    
    public func configTickers(news: Tickers) {
        guard !news.tickers.isEmpty else {
            if !wrappedValue.isHidden {
                wrappedValue.isHidden = true
            }
            return
        }
        wrappedValue.removeChildViews()
        news.tickers.enumerated().forEach {
            let imgView = UIImageView(size: .init(squared: 32), cornerRadius: 16, contentMode: .scaleAspectFit)
            UIImage.loadImage(url: $0.element.logoURL, at: imgView, path: \.image)
            wrappedValue.addSubview(imgView)
            wrappedValue.setFittingConstraints(childView: imgView, top: 0, leading: CGFloat($0.offset * 24), bottom: 0,width: 32, height: 32)
        }
        wrappedValue.isHidden = false
    }

}

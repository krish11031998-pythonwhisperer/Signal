//
//  TickerSymbolsVoew.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 13/11/2022.
//

import Foundation
import UIKit

class TickerSymbolView: UIView {
    public func configTickers(news: Tickers) {
        guard !news.tickers.isEmpty else {
            if !isHidden {
                isHidden = true
            }
            return
        }
        
        removeChildViews()
        news.tickers.enumerated().forEach {
            let imgView = UIImageView(size: .init(squared: 32), cornerRadius: 16, contentMode: .scaleAspectFit)
            UIImage.loadImage(url: $0.element.logoURL, at: imgView, path: \.image)
            addSubview(imgView)
            if $0.offset == news.tickers.count - 1 {
                setFittingConstraints(childView: imgView, top: 0, leading: CGFloat($0.offset * 24), trailing: 0, bottom: 0,width: 32, height: 32)
            } else {
                setFittingConstraints(childView: imgView, top: 0, leading: CGFloat($0.offset * 24), bottom: 0,width: 32, height: 32)
            }
            
        }
        isHidden = false
    }

}

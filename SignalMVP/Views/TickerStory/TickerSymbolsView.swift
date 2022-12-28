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
        configTickers(tickers: news.tickers)
    }
    
    public func configTickers(tickers: [String]) {
        guard !tickers.isEmpty else {
            if !isHidden {
                isHidden = true
            }
            return
        }
        
        removeChildViews()
        tickers.limitTo(to: 3).enumerated().forEach {
            let imgView = UIImageView(size: .init(squared: 32), cornerRadius: 16, contentMode: .scaleAspectFit)
            UIImage.loadImage(url: $0.element.logoURL, at: imgView, path: \.image)
            addSubview(imgView)
            if $0.offset == tickers.count - 1 {
                setFittingConstraints(childView: imgView, top: 0, leading: CGFloat($0.offset * 24), trailing: 0, bottom: 0,width: 32, height: 32)
            } else {
                setFittingConstraints(childView: imgView, top: 0, leading: CGFloat($0.offset * 24), bottom: 0,width: 32, height: 32)
            }
            
        }
        
        if tickers.count > 3 {
            let label = "+\(tickers.count - 3) more".body3Regular().generateLabel
            addSubview(label)
            setFittingConstraints(childView: label, top: 0, leading: 85, trailing: 0, bottom: 0)
        }
        
        isHidden = false
    }

}

//
//  TweetMetrics.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation
import UIKit

enum TweetSentimentMetric: String, CaseIterable{
	case bullish
	case bearish
	case `true`
	case `false`
}

struct TweetSentimentMetricModel {
	let img: UIImage?
	let name: String
}

fileprivate extension UIImage.Catalogue {
	
	init?(metric: TweetSentimentMetric) {
		switch metric {
		case .bullish:
			self.init(rawValue: UIImage.Catalogue.bullish.rawValue)
		case .bearish:
			self.init(rawValue: UIImage.Catalogue.bearish.rawValue)
		case .true:
			self.init(rawValue: UIImage.Catalogue.true.rawValue)
		case .false:
			self.init(rawValue: UIImage.Catalogue.false.rawValue)
		}
	}
}

extension TweetSentimentMetric {
	
	var model: TweetSentimentMetricModel {
		.init(img: UIImage.Catalogue.init(metric: self)?.image, name: rawValue)
	}
	
	var view: UIView {
		let imgView = UIImageView()
		imgView.image = model.img?.withTintColor(.white, renderingMode: .alwaysOriginal)
		imgView.setFrame(.init(squared: 20))
		imgView.clipsToBounds = true
		
		let label = model.name.capitalized.styled(font: .systemFont(ofSize: 12.5, weight: .regular)).generateLabel
		label.textColor = .white
		
		let stack = UIView.HStack(subViews: [imgView, label],spacing: 4)
		
		return stack
	}
}

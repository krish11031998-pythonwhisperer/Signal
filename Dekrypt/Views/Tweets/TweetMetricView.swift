//
//  TweetMetricView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

struct TweetMetricModel {
	let image: UIImage.Catalogue
	let value: Int
}

extension TweetMetricModel {

    var imageView: UIImageView {
        let imageView = UIImageView.standardImageView()
        imageView.image = image.image.resized(withAspect: .init(squared: 12))
        imageView.image?.withTintColor(.appBlack)
        imageView.backgroundColor = .clear
        imageView.contentMode = .center
        return imageView
    }
    
    var label: UILabel {
        let label = "\(value)".styled(font: .systemFont(ofSize: 12, weight: .medium), color: .appBlack).generateLabel
        return label
    }
    
    var view: UIView {
        let stack: UIView = .HStack(subViews: [imageView, label], spacing: 8).blobify(backgroundColor: .appWhite, edgeInset: .init(vertical: 7.5, horizontal: 10))
        stack.addShadow()
        return stack
    }
}

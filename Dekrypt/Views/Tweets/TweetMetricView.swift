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
        imageView.image?.withTintColor(imageView.userInterface == .dark ? .surfaceBackgroundInverse : .surfaceBackground) 
        imageView.backgroundColor = .clear
        imageView.contentMode = .center
        return imageView
    }
    
    var label: UILabel {
        let label = "\(value)".styled(font: .systemFont(ofSize: 12, weight: .medium), color: .textColorInverse).generateLabel
        return label
    }
    
    var view: UIView {
        let stack: UIStackView = .HStack(subViews: [imageView, label], spacing: 8)
        return stack.blobify(backgroundColor: .surfaceBackgroundInverse,
                             edgeInset: .init(vertical: 5, horizontal: 10),
                             borderColor: .clear,
                             borderWidth: 0,
                             cornerRadius: 12)
    }
}

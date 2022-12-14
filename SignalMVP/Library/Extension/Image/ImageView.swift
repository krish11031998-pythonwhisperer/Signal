//
//  ImageView\.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 13/11/2022.
//

import Foundation
import UIKit


extension UIImageView {
    
    static func standardImageView(dimmingForeground: Bool = false) -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray.withAlphaComponent(0.25)
        if dimmingForeground {
            let view = UIView()
            view.backgroundColor = .black.withAlphaComponent(0.2)
            imageView.addSubview(view)
            imageView.setFittingConstraints(childView: view, insets: .zero)
        }
        return imageView
    }
}

//MARK: - Ticker ImageView
@propertyWrapper
struct TickerImageView {
    
    var wrappedValue: UIImageView
    
    init(_ imageView: UIImageView = .init(), size: CGSize = .init(squared: 32)) {
        self.wrappedValue = imageView
        imageView.setFrame(size)
        imageView.clippedCornerRadius = size.smallDim.half
        imageView.backgroundColor = .black.withAlphaComponent(0.2)
    }
}

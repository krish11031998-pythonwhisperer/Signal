//
//  TweetDetailImage.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 30/12/2022.
//

import Foundation
import UIKit

class TweetDetailImage: UIView {
    private lazy var img: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var blurView : UIView = {
        let view = UIView()
        view.addBlurView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        [backgroundImage, blurView, img].forEach {
            addSubview($0)
            setFittingConstraints(childView: $0, insets: .zero)
        }
        clipsToBounds = true
    }
    
    public func configureView(url: String, cornerRadius: CGFloat) {
        UIImage.loadImage(url: url, at: img, path: \.image)
        UIImage.loadImage(url: url, at: backgroundImage, path: \.image)
        self.cornerRadius = cornerRadius
    }
    
}

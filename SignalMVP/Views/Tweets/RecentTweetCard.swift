//
//  RecentTweetCard.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 19/11/2022.
//

import Foundation
import UIKit

class RecentTweetCard: ConfigurableCollectionCell {
    
    //MARK: - Properties
    private var tweetModel: TweetCellModel?
    private lazy var userImage: UIImageView = {
        let img: UIImageView = .init()
        img.circleFrame = .init(origin: .zero, size: .init(squared: 24))
        img.border(color: .blue, borderWidth: 1, cornerRadius: 12)
        return img
    }()
    private lazy var userName: UILabel = { .init() }()
    private lazy var tweetLogo: UIImageView = { .init(image: .Catalogue.twitter.image.resized(size: .init(squared: 24)).withTintColor(.appBlue, renderingMode: .alwaysOriginal)) }()
    private lazy var tweet: UILabel = { .init() }()
    
    //MARK: - Overridden Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Protected Methods
    
    private func setupView() {
        
        userImage.setFrame(.init(squared: 24))
        tweetLogo.setFrame(.init(squared: 24))
        tweet.numberOfLines = 0
        
        let userInfo = [userImage, userName, tweetLogo].embedInHStack(alignment: .center, spacing: 8)
        let mainStack: UIStackView = [userInfo, tweet, .spacer()].embedInVStack(spacing: 12)
        
        contentView.addSubview(mainStack)
        contentView.setFittingConstraints(childView: mainStack, insets: .init(by: 7.5))
        contentView.backgroundColor = .surfaceBackgroundInverse
        contentView.clippedCornerRadius = 12
    }
    
    //MARK: - Exposed Methods
    
    func configure(with model: TweetCellModel) {
        UIImage.loadImage(url: model.user?.profileImageUrl, at: userImage, path: \.image, resized: .init(squared: 24), resolveWithAspectRatio: true)
        model.user?.name.body3Medium(color: .textColorInverse).render(target: userName)
        model.model?.text.body2Medium(color: .textColorInverse).render(target: tweet)
    }
}

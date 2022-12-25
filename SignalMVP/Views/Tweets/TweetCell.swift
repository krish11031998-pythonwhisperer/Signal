//
//  TweetCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit

fileprivate extension TweetOpinion {
	var metricModels: [TweetMetricModel] {
		[.init(image: .like, value: bullish),
		 .init(image: .comments, value: bearish)
		]
	}
}

fileprivate extension TweetReaction {
	var metricModels: [TweetMetricModel] {
		[.init(image: .tweetShare, value: trustedNews),
		 .init(image: .retweet, value: fakeNews)
		]
	}
}


fileprivate extension RoundedCardAppearance {
    
    static let authorCardAppearance: RoundedCardAppearance = .init(backgroundColor: .clear,
                                                                   cornerRadius: 0,
                                                                   insets: .zero,
                                                                   iterSpacing: 8,
                                                                   lineSpacing: 4)
    
}

class TweetCell: ConfigurableCell {
	
    private lazy var tweetAuthorView: RoundedCardView = { .init(appearance: .authorCardAppearance) }()
	private lazy var bodyLabel: UILabel = { .init() }()
    private var imgView: UIImageView = { return .standardImageView(dimmingForeground: false) }()
	private var metrics: [UIView] = []
	private lazy var imageHeight: NSLayoutConstraint = {
		let constraint = imgView.heightAnchor.constraint(equalToConstant: 200)
		constraint.priority = .needed
		return constraint
	}()
	private lazy var metricStack: UIStackView = {
		let metricStack = UIView.HStack(spacing: 12)
		metricStack.alignment = .leading
		return metricStack
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCell()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func styleCell() {
		selectedBackgroundView = UIView()
		selectedBackgroundView?.backgroundColor = .clear
		backgroundColor = .surfaceBackground
	}
	
	private func setupCell() {

		let bodyStack = UIView.VStack(subViews: [tweetAuthorView, bodyLabel, imgView, metricStack], spacing: 8)
		bodyStack.setCustomSpacing(12, after: tweetAuthorView)
		bodyStack.setCustomSpacing(12, after: bodyLabel)

		imageHeight.isActive = true
        imgView.clippedCornerRadius = 16
        
        let card = bodyStack.blobify(backgroundColor: .surfaceBackground, edgeInset: .tweetCellInsets, borderColor: .clear, cornerRadius: 12)
        card.addShadow()
        
		contentView.addSubview(card)
		contentView.setFittingConstraints(childView: card, insets: .init(by: 10))
	
		gestureRecognizers?.forEach { gesture in
			print("(DEBUG) gesture : ",gesture)
		}
		
		styleCell()
	}
	
	func configure(with model: TweetCellModel) {
		model.model?.text.body2Regular(color: .gray).render(target: bodyLabel)
		bodyLabel.numberOfLines = 0
		bodyLabel.textAlignment = .left
		
        tweetAuthorView.configureView(with: .init(title: model.user?.name.body2Medium(),
                                                  subTitle: model.user?.username.body3Medium(color: .gray),
                                                  leadingView: .image(url:  model.user?.profileImageUrl,
                                                                      size: .init(squared: 32),
                                                                      cornerRadius: 16)))
        

		if let media = model.media?.first,
		   let photoUrl = media.url ?? media.previewImageUrl {
			let height = (CGFloat.totalWidth - 32) * CGFloat(media.height)/CGFloat(media.width)
			imageHeight.constant = height
			UIImage.loadImage(url: photoUrl, at: imgView, path: \.image, resolveWithAspectRatio: true)
			imgView.isHidden = false
		} else {
			imgView.isHidden = true
		}
		
		let metrics = (model.model?.opinions?.metricModels ?? []) + (model.model?.reactions?.metricModels ?? [])
		if !metrics.isEmpty {
			metricStack.removeChildViews()
            metrics
                .forEach { metricStack.addArrangedSubview($0.view) }
            metricStack.addArrangedSubview(.spacer())
		}
		
		
	}
}

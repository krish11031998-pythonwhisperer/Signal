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
		[.init(image: .bullish, value: bullish),
		 .init(image: .bearish, value: bearish)
		]
	}
}

fileprivate extension TweetReaction {
	var metricModels: [TweetMetricModel] {
		[.init(image: .true, value: trustedNews),
		 .init(image: .false, value: fakeNews)
		]
	}
}

class TweetCell: ConfigurableCell {
	
	private lazy var authorLabel: UILabel = { .init() }()
	private lazy var timestampLabel: UILabel = { .init() }()
	private lazy var bodyLabel: UILabel = { .init() }()
	private var imgView: UIImageView = {
		let imgView = UIImageView()
		imgView.backgroundColor = .gray.withAlphaComponent(0.25)
		imgView.cornerRadius = 10
		imgView.clipsToBounds = true
		imgView.contentMode = .scaleAspectFill
		return imgView
	}()
	private lazy var authorImageView: UIImageView = { .init() }()
	private var metrics: [UIView] = []
	private lazy var imageHeight: NSLayoutConstraint = {
		let constraint = imgView.heightAnchor.constraint(equalToConstant: 200)
		constraint.priority = .needed
		return constraint
	}()
	private lazy var metricStack: UIStackView = {
		let metricStack = UIView.HStack(spacing: 5)
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
		
		let headerStack: UIStackView = .init(arrangedSubviews: [authorLabel, .spacer(), timestampLabel])
		headerStack.spacing = 8
		let divider = UIView.divider()
		let bodyStack = UIView.VStack(subViews: [headerStack, bodyLabel, imgView, metricStack, divider], spacing: 8)
		bodyStack.setCustomSpacing(12, after: headerStack)
		bodyStack.setCustomSpacing(12, after: bodyLabel)
		bodyStack.setCustomSpacing(16, after: divider)

		let mainStack = UIView.HStack(subViews: [authorImageView, bodyStack], spacing: 12, alignment: .top)
		authorImageView.circleFrame = .init(origin: .zero, size: .init(squared: 48))
		authorImageView.setFrame(.init(squared: 48))
		authorImageView.backgroundColor = .gray.withAlphaComponent(0.15)
		authorImageView.contentMode = .scaleAspectFill
		imageHeight.isActive = true
		contentView.addSubview(mainStack)
		contentView.setFittingConstraints(childView: mainStack, insets: .init(vertical: 10, horizontal: 16))
	
		gestureRecognizers?.forEach { gesture in
			print("(DEBUG) gesture : ",gesture)
		}
		
		styleCell()
	}
	
	func configure(with model: TweetCellModel) {
		model.model?.text.body2Regular(color: .gray).render(target: bodyLabel)
		bodyLabel.numberOfLines = 0
		bodyLabel.textAlignment = .left
		
		model.user?.username.body2Medium().render(target: authorLabel)
		authorLabel.setHeight(height: authorLabel.compressedSize.height, priority: .required)

		if let authorImage = model.user?.profileImageUrl {
			UIImage.loadImage(url: authorImage, at: authorImageView, path: \.image, resized: .init(squared: 48))
		}

		if let media = model.media?.first,
		   let photoUrl = media.url ?? media.previewImageUrl {
			let height = (CGFloat.totalWidth - 32) * CGFloat(media.height)/CGFloat(media.width)
			imageHeight.constant = height
			UIImage.loadImage(url: photoUrl, at: imgView, path: \.image)
			imgView.isHidden = false
		} else {
			imgView.isHidden = true
		}
		
		let metrics = (model.model?.opinions?.metricModels ?? []) + (model.model?.reactions?.metricModels ?? [])
		if !metrics.isEmpty {
			metricStack.removeChildViews()
			metrics
				.forEach { model in
					let view = TweetMetricView()
					view.configureView(model: model)
					metricStack.addArrangedSubview(view)
				}
			metricStack.addArrangedSubview(.spacer())
		}
		
		
	}
	
	
}

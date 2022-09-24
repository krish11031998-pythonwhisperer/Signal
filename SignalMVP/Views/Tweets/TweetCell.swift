//
//  TweetCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit

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
	
	private lazy var metricStack: UIStackView = {
		let metricStack = UIView.HStack(spacing: 5)
		metricStack.distribution = .fill
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
		backgroundColor = .clear
	}
	
	private func setupCell() {
		
		let headerStack: UIStackView = .init(arrangedSubviews: [authorLabel, .spacer(), timestampLabel])
		headerStack.spacing = 8

		let bodyStack = UIView.VStack(subViews: [headerStack, bodyLabel, imgView, metricStack], spacing: 8)
		bodyStack.setCustomSpacing(12, after: headerStack)
		
		let constraint = imgView.heightAnchor.constraint(equalToConstant: 200)
		constraint.priority = .defaultHigh
		constraint.isActive = true
		
		let mainStack = UIView.HStack(subViews: [authorImageView, bodyStack], spacing: 12, alignment: .top)
		
		contentView.addSubview(mainStack)
		contentView.setFittingConstraints(childView: mainStack, insets: .init(vertical: 10, horizontal: 16))
		
		let divider = UIView()
		divider.backgroundColor = .gray.withAlphaComponent(0.5)
		divider.setHeight(height: 0.5, priority: .required)
		let dividerEmbed = divider.embedInView(insets: .init(vertical: 8, horizontal: 0))
		contentView.addSubview(dividerEmbed)
		contentView.setFittingConstraints(childView: dividerEmbed, leading: 16, trailing: 16, bottom: 0)
		
		styleCell()
	}
	
	func configure(with model: TweetCellModel) {
		model.model?.text.styled(font: .systemFont(ofSize: 14, weight: .regular), color: .gray).render(target: bodyLabel)
		bodyLabel.numberOfLines = 0
		bodyLabel.textAlignment = .left

		model.user?.username.styled(font: .systemFont(ofSize: 14, weight: .medium), color: .white).render(target: authorLabel)
	
		authorImageView.cornerFrame = .init(origin: .zero, size: .init(squared: 48))
		authorImageView.setFrame(.init(squared: 48))
		authorImageView.backgroundColor = .gray.withAlphaComponent(0.15)
		if let authorImage = model.user?.profileImageUrl {
			UIImage.loadImage(url: authorImage, at: authorImageView, path: \.image, resized: .init(squared: 48))
		}
		
		if let media = model.media?.first,
		   let photoUrl = media.url ?? media.previewImageUrl {
			UIImage.loadImage(url: photoUrl, at: imgView, path: \.image)
			imgView.isHidden = false
			let constraint = imgView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
			constraint.priority = .defaultHigh
			constraint.isActive = true
		} else {
			imgView.isHidden = true
		}
		
		metricStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

		[TweetMetricModel(image: .bullish, value: Int.random(in: 0...50)),
		 TweetMetricModel(image: .bearish, value: Int.random(in: 0...50)),
		 TweetMetricModel(image: .true, value: Int.random(in: 0...50)),
		 TweetMetricModel(image: .false, value: Int.random(in: 0...50))]
			.forEach { model in
				let view = TweetMetricView()
				view.configureView(model: model)
				metricStack.addArrangedSubview(view)
			}
		metricStack.addArrangedSubview(.spacer())
	}
	
	
}

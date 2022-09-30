//
//  VideoCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import UIKit

class VideoCell: ConfigurableCell {
//MARK: - Properties
	private lazy var img: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		view.clipsToBounds = true
		return view
	}()
	private lazy var bgImg: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFill
		view.clipsToBounds = true
		return view
	}()
	private lazy var videoLabel: UILabel = { .init() }()
	private lazy var authorLabel: UILabel = { .init() }()
	private lazy var videoInfoStack: UIStackView = { .VStack(subViews: [videoLabel, .spacer(), authorLabel], spacing: 6) }()

//MARK: - Overriden Methods
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}

//MARK: - Protected Methods

	private func setupView() {
		let mainStack: UIStackView = .VStack(spacing: 0)

		videoInfoStack.clipsToBounds = true
		
		let infoView = videoInfoStack.embedInView(insets: .init(by: 12))
		infoView.clipsToBounds = true
		
		let videoimageView = UIView()
		videoimageView.addSubview(bgImg)
		bgImg.addBlurView()
		videoimageView.addSubview(img)
		
		[bgImg, img].forEach {
			videoimageView.addSubview($0)
			videoimageView.setFittingConstraints(childView: $0, insets: .zero)
		}
		
		[videoimageView, infoView].forEach(mainStack.addArrangedSubview(_:))

		videoLabel.numberOfLines = 3
		videoimageView.setHeight(height: 150, priority: .required)
		mainStack.setHeight(height: 250, priority: .required)
		mainStack.cornerRadius = 12
		mainStack.addBlurView()
		mainStack.clipsToBounds = true
		
		contentView.addSubview(mainStack)
		contentView.setFittingConstraints(childView: mainStack, insets: .init(vertical: 10, horizontal: 16))
		selectionStyle = .none
		backgroundColor = .clear
	}
	
//MARK: - Exposed Methods
	
	func configure(with model: VideoModel) {
		UIImage.loadImage(url: model.imageUrl, at: img, path: \.image)
		UIImage.loadImage(url: model.imageUrl, at: bgImg, path: \.image)
		model.title.body1Medium().render(target: videoLabel)
		model.sourceName.bodySmallRegular(color: .gray).render(target: authorLabel)
		authorLabel.setFrame(height: authorLabel.compressedSize.height)
	}
	
}

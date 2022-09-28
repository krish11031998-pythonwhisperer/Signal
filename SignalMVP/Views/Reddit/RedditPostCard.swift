//
//  RedditPostCard.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation
import UIKit

class RedditPostCard : ConfigurableCell {
	
	private lazy var authorLabel: UILabel = { .init() }()
	private lazy var subReddit: UILabel = { .init() }()
	private lazy var postImageView: UIImageView = {
		let imgView = UIImageView()
		imgView.cornerRadius = 10
		imgView.clipsToBounds = true
		imgView.contentMode = .scaleAspectFill
		return imgView
	}()
	
	private lazy var postTitle: UILabel = { .init() }()
	private lazy var postBody: UILabel = { .init() }()
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}
	
	
	private func setupView() {
		let stack = UIView.VStack(subViews: [authorLabel, subReddit, postImageView, postTitle, postBody], spacing: 10)
		
		stack.setCustomSpacing(5, after: authorLabel)
		stack.setCustomSpacing(16, after: subReddit)
		
		postImageView.isHidden = true
		postBody.isHidden = true
		
		postImageView.setHeight(height: 200, priority: .init(999))
		
		let divider = UIView()
		divider.backgroundColor = .gray
		stack.addArrangedSubview(divider.embedInView(insets: .init(top: 10, left: 0, bottom: 0, right: 0)))
		divider.setHeight(height: 0.5, priority: .init(999))
		
		selectionStyle = .none
		backgroundColor = .surfaceBackground
		contentView.addSubview(stack)
		contentView.setFittingConstraints(childView: stack, insets: .init(vertical: 10, horizontal: 16))
	}
	
	private func resetCell() {
		postImageView.image = nil
		postImageView.isHidden = true
		postBody.isHidden = true
	}
	
	func configure(with model: RedditPostModel) {
		resetCell()
		
		model.author.body2Regular().render(target: authorLabel)
		authorLabel.numberOfLines = 1
		
		model.subredditNamePrefixed.bodySmallRegular(color: .gray).render(target: subReddit)
		subReddit.numberOfLines = 1
		
		model.title.heading4().render(target: postTitle)
		postTitle.numberOfLines = 0
		
		if let text = model.selftext {
			text.body3Regular().render(target: postBody)
			postBody.isHidden = false
			postBody.numberOfLines = 0
		}
		
		if model.url.contains("png") {
			UIImage.loadImage(url: model.url, at: postImageView, path: \.image)
			postImageView.isHidden = false
		}
	}
}

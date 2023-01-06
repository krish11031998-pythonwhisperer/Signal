//
//  RedditPostCard.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation
import UIKit

extension Notification.Name {
	static let updateTableView: Self = .init("updateTableView")
}

class RedditPostCard : ConfigurableCell {
	private static var showMoreId: String = ""
	private lazy var authorLabel: UILabel = { .init() }()
	private lazy var subReddit: UILabel = { .init() }()
	private lazy var postImageView: UIImageView = {
		let imgView = UIImageView()
		imgView.cornerRadius = 10
		imgView.clipsToBounds = true
		imgView.contentMode = .scaleAspectFill
		return imgView
	}()
	private lazy var showMoreLabel: UIView = {
		let label = "Show More".bodySmallRegular().generateLabel
		return label.blobify()
	}()
	private lazy var postTitle: UILabel = { .init() }()
	private lazy var postBody: UILabel = { .init() }()
	private var model: RedditPostModel? = nil
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}
	
	private func setupView() {
		let stack = UIView.VStack(subViews: [authorLabel, subReddit, postImageView, postTitle, postBody, showMoreLabel], spacing: 10, alignment: .leading)
		
		stack.setCustomSpacing(5, after: authorLabel)
		stack.setCustomSpacing(16, after: subReddit)
		
		postImageView.isHidden = true
		postBody.isHidden = true
		showMoreLabel.isHidden = true
		postImageView.setHeight(height: 200, priority: .init(999))
		
		let divider = UIView()
		divider.backgroundColor = .gray
		stack.addArrangedSubview(divider.embedInView(insets: .init(top: 10, left: 0, bottom: 0, right: 0)))
		divider.setHeight(height: 0.5, priority: .init(999))
		stack.setFittingConstraints(childView: divider, leading: 0, trailing: 0)
		
		showMoreHandler()
		
		selectionStyle = .none
		backgroundColor = .surfaceBackground
		contentView.addSubview(stack)
		contentView.setFittingConstraints(childView: stack, top: 10, leading: 16, trailing: 16, bottom: 10, priority: .needed)
	}
	
	private func resetCell() {
		postImageView.image = nil
		postImageView.isHidden = true
		postBody.isHidden = true
	}
	
	func configure(with model: RedditPostModel) {
		resetCell()
		self.model = model
		model.author.body2Regular().render(target: authorLabel)
		authorLabel.numberOfLines = 1
		
		model.subredditNamePrefixed.bodySmallRegular(color: .gray).render(target: subReddit)
		subReddit.numberOfLines = 1
		
		model.title.heading4().render(target: postTitle)
		postTitle.numberOfLines = 0
		
		if let text = model.selftext, !text.isEmpty {
			text.body3Regular().render(target: postBody)
			postBody.isHidden = false
			showMoreLabel.isHidden = false
			postBody.numberOfLines = selectedCard(model) ? 0 : 3
		}
		
		if model.url.contains("png") {
			UIImage.loadImage(url: model.url, at: postImageView, path: \.image)
			postImageView.isHidden = false
		}
	}
	
	func showMoreHandler() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		tapGesture.cancelsTouchesInView = true
		showMoreLabel.addGestureRecognizer(tapGesture)
	}

	@objc
	func handleTap() {
		Self.showMoreId = model?.id ?? ""
		postBody.numberOfLines = postBody.numberOfLines == 0 ? 3 : 0
		NotificationCenter.default.post(name: .updateTableView, object: nil)
	}
}


extension RedditPostCard {
	private func selectedCard(_ reddit: RedditPostModel) -> Bool {
		Self.showMoreId == reddit.id
	}
}

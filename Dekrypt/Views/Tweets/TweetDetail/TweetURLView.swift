//
//  TweetURLView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 02/10/2022.
//

import Foundation
import UIKit

class TweetURLView: UIControl {

//MARK: - Properties
	private lazy var titleLabel: UILabel = { .init() }()
	private lazy var descriptionLabel: UILabel = { .init() }()
	
	private lazy var imgView: UIImageView = {
		let imgView = UIImageView()
		imgView.clipsToBounds = true
		imgView.contentMode = .scaleAspectFill
		return imgView
	}()

//MARK: - Overriden Methods
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
//MARK: - Protected Methods

	func setupView() {
		let bodyStack = UIStackView.VStack(subViews: [titleLabel, descriptionLabel],spacing: 8)
			.embedInView(insets: .init(vertical: 12, horizontal: 12))
		let stack = UIStackView.VStack(subViews: [imgView, bodyStack], spacing: 0)
		imgView.isHidden = true
		titleLabel.numberOfLines = 0
		descriptionLabel.numberOfLines = 3
		stack.clipsToBounds = true
		stack.border(color: .surfaceBackgroundInverse, borderWidth: 1, cornerRadius: 14)
	
		addSubview(stack)
		setFittingConstraints(childView: stack, insets: .zero)
	}
	
//MARK: - Exposed Methods
	
	func configureView(_ model: TweetURL) {
		if let imgURL = model.images?.first {
			imgView.setHeight(height: 145, priority: .required)
			imgView.isHidden = false
			UIImage.loadImage(url: imgURL.url, at: imgView, path: \.image)
		}
		
		guard model.title != nil || model.description != nil else {
			subviews.forEach { $0.isHidden = true }
			return
		}
		model.title?.body1Medium().render(target: titleLabel)
		model.description?.body3Regular(color: .gray).render(target: descriptionLabel)

	}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendActions(for: .touchUpInside)
    }
	
}

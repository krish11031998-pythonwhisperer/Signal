//
//  TweetMetricView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

struct TweetMetricModel {
	let image: UIImage.SystemCatalogue
	let value: Int
}


class TweetMetricView: UIView {
	
	
	private lazy var imgView: UIImageView = { .init(frame: .init(origin: .zero, size: .init(squared: 20))) }()
	private lazy var metricValLabel: UILabel = { .init() }()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	
	private func setupView() {
		let stack = UIView.HStack(subViews: [imgView, metricValLabel], spacing: 4)
		stack.alignment = .center
		addSubview(stack)
		setFittingConstraints(childView: stack, insets: .init(vertical: 10, horizontal: 8))
	}
	
	
	public func configureView(model: TweetMetricModel) {
		
		if let img = model.image.image {
			imgView.image = img.withTintColor(.gray, renderingMode: .alwaysOriginal)
			imgView.setFrame(width: 20)
		}
		
		"\(model.value)".styled(font: .systemFont(ofSize: 14, weight: .regular), color: .white).render(target: metricValLabel)
	}
	
}

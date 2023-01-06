//
//  SentimentTextLable.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 27/09/2022.
//

import Foundation
import UIKit


class SentimentTextLabel: UIView {
	
	private lazy var label: UILabel = { .init() }()
	private lazy var indicator: UIView = {
		let view = UIView()
		view.setFrame(.init(squared: 10))
		view.circleFrame = .init(origin: .zero, size: .init(squared: 10))
		view.backgroundColor = .gray
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
		let stack: UIStackView = .HStack(subViews: [indicator, label], spacing: 8, alignment: .center)
		addSubview(stack)
		setFittingConstraints(childView: stack, insets: .zero)
	}
	
	public func configureIndicator(label: String, color: UIColor) {
		label.bodySmallRegular().render(target: self.label)
		indicator.backgroundColor = color
	}
	
}

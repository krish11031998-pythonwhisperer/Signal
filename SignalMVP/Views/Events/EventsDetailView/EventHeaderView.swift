//
//  EventHeaderView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 26/09/2022.
//

import Foundation
import UIKit

class EventDetailViewHeader: UIView {
	
//MARK: - Properties

	private lazy var mainNews: EventView = { .init(largeCard: true) }()
	private lazy var otherNews: UIStackView = { .init() }()
	
//MARK: - Constructors
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
//MARK: - Protected Methods
	
	private func setupView() {
		let stack: UIStackView = .VStack(subViews: [mainNews,otherNews],spacing: 10)
		mainNews.setHeight(height: 245, priority: .required)
		otherNews.setHeight(height: 245, priority: .required)
		addSubview(stack)
		setFittingConstraints(childView: stack, top: 0, bottom: 0)
		setFittingConstraints(childView: stack, leading: 16, trailing: 16, priority: .init(999))
	}
	
//MARK: - Exposed Methods
	
	public func configureHeader(_ model: EventModel) {
		if let firstNews = model.news.first {
			mainNews.configureView(model: firstNews)
			mainNews.isHidden = false
		}
		
		if model.news.count >= 3 {
			let otherViews: [UIView] = Array(model.news[1..<3]).compactMap {
				let view = EventView()
				view.configureView(model: $0)
				return view
			}
			otherNews.arrangedSubviews.forEach { $0.removeFromSuperview() }
			otherViews.forEach(otherNews.addArrangedSubview(_:))
			otherNews.spacing = 8
			otherNews.distribution = .fillEqually
			otherNews.isHidden = false
		}

	}
}

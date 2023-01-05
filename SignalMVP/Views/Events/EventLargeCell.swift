//
//  EventSingleCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit
import Combine

class EventLargeCell: ConfigurableCell {
	
//MARK: - Properties
	private lazy var eventTitle: UILabel = { .init() }()
    private lazy var imgView: UIImageView = { .standardImageView(dimmingForeground: false) }()
	private lazy var newsArticleCount: UILabel = { .init() }()
    private lazy var tickersView: TickerSymbolView = { .init() }()
    private var cancellable: AnyCancellable?
    private var viewlayout: Bool = false
	
//MARK: - Overriden
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
		styleCell()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupViews()
		styleCell()
	}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupDimmingLayer()
    }
	
//MARK: - Protected Methods
	
	private func setupViews() {
        contentView.addSubview(imgView)
        contentView.setFittingConstraints(childView: imgView, top: 10, leading: 10, trailing: 10, bottom: 10, height: (.totalHeight * 0.3).rounded(.down))
        imgView.clippedCornerRadius = 16
        eventTitle.overrideUserInterfaceStyle = .dark
        let bottomStack: UIStackView = .HStack(subViews: [newsArticleCount, .spacer(), tickersView], spacing: 10, alignment: .center)
        bottomStack.setHeight(height: 32)
        let infoStack: UIStackView = .VStack(subViews: [.spacer(), eventTitle, bottomStack],spacing: 10)
        contentView.addSubview(infoStack)
        contentView.setFittingConstraints(childView: infoStack, insets: .init(by: 20))
	}
    
    private func setupDimmingLayer() {
        imgView.layoutIfNeeded()
        imgView.addShadow()
        let gradient: CAGradientLayer = .init()
        gradient.colors = [UIColor.clear, UIColor.clear, UIColor.black.withAlphaComponent(0.5), UIColor.black].compactMap { $0.cgColor }
        gradient.name = "Gradient"
        if let _ = imgView.layer.sublayers?.filter({ $0.name == "Gradient" }).first {
            return
        }
        imgView.layer.addSublayer(gradient)
        gradient.frame = self.imgView.bounds
    }
	
	private func styleCell() {
		selectionStyle = .none
		backgroundColor = .surfaceBackground
	}
	
	
//MARK: - Exposed Methods
	func configure(with model: EventCellModel) {

		model.model.eventName.heading5().render(target: eventTitle)
		eventTitle.numberOfLines = 0

		if let firstImgURL = model.model.news?.first?.imageUrl {
			cancellable = UIImage.loadImage(url: firstImgURL, at: imgView, path: \.image)
		}

		"\(model.model.news?.count ?? 0) News Articles".body2Regular(color: .gray).render(target: newsArticleCount)
        
        tickersView.configTickers(news: model.model)
	}
    
    override func prepareForReuse() {
        cancellable?.cancel()
        viewlayout = false
    }
}

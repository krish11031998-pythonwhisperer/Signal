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
    
//MARK: - Protected Methods
	
	private func setupViews() {
        contentView.addSubview(imgView)
        contentView.setFittingConstraints(childView: imgView, top: 10, leading: 10, trailing: 10, bottom: 10, height: (.totalHeight * 0.3).rounded(.down))
        imgView.clippedCornerRadius = 16
        let bottomStack: UIView = .HStack(subViews: [newsArticleCount, .spacer(), tickersView], spacing: 10, alignment: .center)
        bottomStack.overrideUserInterfaceStyle = .light
        bottomStack.setHeight(height: 32)
        var infoStack: UIView = .VStack(subViews: [eventTitle, bottomStack],spacing: 10)
        infoStack.overrideUserInterfaceStyle = .light
        infoStack = infoStack.blobify(backgroundColor: userInterface == .light ? .surfaceBackground : .surfaceBackgroundInverse,
                                      edgeInset: .init(by: 10),
                                      borderColor: .clear,
                                      borderWidth: 0,
                                      cornerRadius: 12)
        
        let holderStack = UIStackView.VStack(subViews: [.spacer(), infoStack], spacing: 10)
        contentView.addSubview(holderStack)
        contentView.setFittingConstraints(childView: holderStack, insets: .init(by: 20))
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

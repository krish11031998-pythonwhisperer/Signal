//
//  EventSpaceCell.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 08/01/2023.
//

import Foundation
import UIKit
import Combine

class EventSpaceView: UIView {
    
    private lazy var timeStamp: UILabel = { .init() }()
    private lazy var eventTitle: UILabel = { .init() }()
    private lazy var eventDescription: UILabel = { .init() }()
    private lazy var articleNumber: UILabel = { .init() }()
    private lazy var tickers: TickerSymbolView = { .init() }()
    private lazy var mainStack: UIStackView =  { .VStack(subViews:[timeStamp, eventTitle, eventDescription, articleNumber, .spacer(), tickers], spacing: 6, alignment: .leading) }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupView() {
        addSubview(mainStack)
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.directionalLayoutMargins = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
        setFittingConstraints(childView: mainStack, insets: .zero)
        eventTitle.numberOfLines = 0
        eventDescription.numberOfLines = 0
        eventTitle.setContentHuggingPriority(.init(249), for: .vertical)
        eventTitle.setContentCompressionResistancePriority(.init(749), for: .vertical)
        eventDescription.setContentHuggingPriority(.init(248), for: .vertical)
        eventDescription.setContentCompressionResistancePriority(.init(748), for: .vertical)
        cornerRadius = 12
        backgroundColor = .appIndigo
        addShadow()
        eventDescription.isHidden = true
        mainStack.setCustomSpacing(12, after: articleNumber)
    }
    
    func configureView(event: EventModel) {
        event.date.timestamp.body3Medium(color: .gray).render(target: timeStamp)
        if let count = event.newsItem {
            "\(count) articles".body3Regular(color: .gray).render(target: articleNumber)
        }
        event.eventName.heading4(color: .white).render(target: eventTitle)
        if let description = event.eventText {
            description.body2Medium(color: .white.withAlphaComponent(0.85))
                .render(target: eventDescription)
            eventDescription.isHidden = false
        }
        
        tickers.configTickers(news: event)
    }
}


//MARK: - EventSpaceTableCell
class EventSpaceTableCell: ConfigurableCell {
    
    private lazy var view: EventSpaceView = { .init() }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(view)
        contentView.setFittingConstraints(childView: view, insets: .init(by: 10))
        selectionStyle = .none
        backgroundColor = .surfaceBackground
    }
    
    
    func configure(with model: EventCellModel) {
        view.configureView(event: model.model)
    }
    
}

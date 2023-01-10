//
//  EventSmallCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 05/01/2023.
//

import Foundation
import UIKit

class EventSmallCell: ConfigurableCell {
    
    private lazy var eventTitle: UILabel = { .init() }()
    private lazy var numberOfArticles: UILabel =  { .init() }()
    private lazy var tickerView: TickerSymbolView = { .init() }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let bottomStack = UIStackView.HStack(subViews: [numberOfArticles, .spacer(), tickerView], spacing: 10, alignment: .bottom)
        let mainStack = UIStackView.VStack(subViews: [eventTitle, bottomStack], spacing: 20)
        
        eventTitle.numberOfLines = 0
        
        let card = mainStack.blobify(backgroundColor: .surfaceBackground, edgeInset: .init(by: 10), borderColor: .clear, cornerRadius: 12)
        
        addSubview(card)
        card.addShadow()
        setFittingConstraints(childView: card, insets: .init(by: 10))
        selectionStyle = .none
        backgroundColor = .surfaceBackground
    }
    
    func configure(with model: EventCellModel) {
        model.model.eventName.body2Medium().render(target: eventTitle)
        "\(model.model.news?.count ?? model.model.newsItem ?? 0) News Articles".body3Regular(color: .gray).render(target: numberOfArticles)
        
        guard let tickers = model.model.tickers else { return }
        tickerView.isHidden = tickers.isEmpty
        tickerView.configTickers(news: model.model)        
    }
    
}

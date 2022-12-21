//
//  CuratedEventCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 12/11/2022.
//

import Foundation
import UIKit

class CustomCuratedCell: ConfigurableCollectionCell {
    
    private var imageView: UIImageView = { .standardImageView(dimmingForeground: true) }()
    private lazy var headlineLabel: UILabel = { .init() }()
    private lazy var tickers: UIView = { .init() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        
        let cardStack = UIStackView.VStack(spacing: 10, alignment: .leading)
        [.spacer(),headlineLabel, tickers].addToView(cardStack)
        tickers.isHidden = true
        [imageView, cardStack].addToView(contentView)
        
        headlineLabel.numberOfLines = 3
        
        contentView.setFittingConstraints(childView: imageView, insets: .zero)
        contentView.setFittingConstraints(childView: cardStack, insets: .init(by: 10))
        contentView.clippedCornerRadius = 12
        
    }
    
    private func configTickers(model: EventModel) {
        guard !model.tickers.isEmpty else { return }
        tickers.removeChildViews()
        model.tickers.enumerated().forEach {
            
            @TickerImageView(size: .init(squared: 24)) var imgView;
            UIImage.loadImage(url: $0.element.logoURL, at: imgView, path: \.image)
            tickers.addSubview(imgView)
            tickers.setFittingConstraints(childView: imgView, top: 0, leading: CGFloat($0.offset * 16), bottom: 0)
        }
        tickers.isHidden = false
    }
    
    func configure(with model: EventCellModel) {
        let event = model.model
        imageView.image = nil
        UIImage.loadImage(url: event.news.first?.imageUrl, at: imageView, path: \.image)
        event.eventName.body1Bold(color: .white).render(target: headlineLabel)
        configTickers(model: event)
    }
}

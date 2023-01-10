//
//  CuratedEventCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 12/11/2022.
//

import Foundation
import UIKit
import Combine

class CustomCuratedCell: ConfigurableCollectionCell {
    
//    private var imageView: UIImageView = { .standardImageView(dimmingForeground: true) }()
    private lazy var headlineLabel: UILabel = { .init() }()
    private lazy var tickers: TickerSymbolView = { .init() }()
//    private var infoView: UIView!
    private var bag: Set<AnyCancellable> = .init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        let cardStack = UIStackView.VStack(subViews: [headlineLabel, .spacer(), tickers], spacing: 10, alignment: .leading)
        headlineLabel.numberOfLines = 0
        
        contentView.addSubview(cardStack)
        contentView.cornerRadius = 12
        contentView.setFittingConstraints(childView: cardStack, insets: .init(by: 10))
        contentView.backgroundColor = .surfaceBackground
        contentView.addShadow()
    }
    
    private func configTickers(model: EventModel) {
        guard let tickers = model.tickers, tickers.isEmpty else { return }
        self.tickers.removeChildViews()
        tickers.enumerated().forEach {
            
            @TickerImageView(size: .init(squared: 24)) var imgView;
            UIImage.loadImage(url: $0.element.logoURL, at: imgView, path: \.image).store(in: &bag)
            self.tickers.addSubview(imgView)
            self.tickers.setFittingConstraints(childView: imgView, top: 0, leading: CGFloat($0.offset * 16), bottom: 0)
        }
        self.tickers.isHidden = false
    }
    
    func configure(with model: EventCellModel) {
        let event = model.model
        event.eventName.body1Bold().render(target: headlineLabel)
        tickers.configTickers(tickers: model.model.tickers ?? [])
    }
    
    override func prepareForReuse() {
        bag.forEach { $0.cancel() }
    }
}

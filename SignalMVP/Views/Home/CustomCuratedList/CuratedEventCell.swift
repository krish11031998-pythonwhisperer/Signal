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
    
    private var imageView: UIImageView = { .standardImageView(dimmingForeground: true) }()
    private lazy var headlineLabel: UILabel = { .init() }()
    private lazy var tickers: UIView = { .init() }()
    private var infoView: UIView!
    private var bag: Set<AnyCancellable> = .init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        infoView?.setHeight(height: frame.height * 0.4)
    }
    
    private func setupView() {
        overrideUserInterfaceStyle = .dark
        let cardStack = UIStackView.VStack(spacing: 10)
        infoView = UIStackView.VStack(subViews: [headlineLabel, .spacer(), tickers], spacing: 10, alignment: .leading)
            .blobify(backgroundColor: .surfaceBackgroundInverse,
                     edgeInset: .init(vertical: 10, horizontal: 12.5),
                     borderColor: .clear,
                     borderWidth: 1,
                     cornerRadius: 12)
        [.spacer(),infoView].addToView(cardStack)
        tickers.isHidden = true
        [imageView, cardStack].addToView(contentView)
        
        headlineLabel.numberOfLines = 0
        
        contentView.setFittingConstraints(childView: imageView, insets: .zero)
        contentView.setFittingConstraints(childView: cardStack, insets: .init(by: 10))
        contentView.clippedCornerRadius = 12
    }
    
    private func configTickers(model: EventModel) {
        guard !model.tickers.isEmpty else { return }
        tickers.removeChildViews()
        model.tickers.enumerated().forEach {
            
            @TickerImageView(size: .init(squared: 24)) var imgView;
            UIImage.loadImage(url: $0.element.logoURL, at: imgView, path: \.image).store(in: &bag)
            tickers.addSubview(imgView)
            tickers.setFittingConstraints(childView: imgView, top: 0, leading: CGFloat($0.offset * 16), bottom: 0)
        }
        tickers.isHidden = false
    }
    
    func configure(with model: EventCellModel) {
        let event = model.model
        imageView.image = nil
        UIImage.loadImage(url: event.news?.first?.imageUrl, at: imageView, path: \.image).store(in: &bag)
        event.eventName.body2Medium(color: .textColorInverse).render(target: headlineLabel)
        configTickers(model: event)
    }
    
    override func prepareForReuse() {
        bag.forEach { $0.cancel() }
    }
}

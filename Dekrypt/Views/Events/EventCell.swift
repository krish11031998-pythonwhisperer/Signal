//
//  EventCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit
import Combine

struct EventNewsModel {
    let model: EventModel
    let selectedNews: PassthroughSubject<NewsModel?, Never>
}

class EventCell: ConfigurableCell {

//MARK: - Properties
	private lazy var mainNews: NewsEventView = { .init(largeCard: true) }()
	private lazy var otherNews: UIStackView = { .init() }()
    private var bag: Set<AnyCancellable> = .init()
//MARK: - Constructors
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
		styleCell()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
		styleCell()
	}
	
	private func setupView() {
		let stack = UIView.VStack(subViews: [mainNews, otherNews], spacing: 12, alignment: .leading)
		stack.setCustomSpacing(4, after: otherNews)
		contentView.addSubview(stack)
		contentView.setFittingConstraints(childView: stack, insets: .init(vertical: 10, horizontal: 8))
		mainNews.isHidden = true
		otherNews.isHidden = true
	}
	
	private func styleCell() {
		backgroundColor = .clear
		selectionStyle = .none
	}
	
	func configure(with model: EventNewsModel) {
        guard let news = model.model.news else { return }
		if let firstNews = news.first {
			mainNews.configureView(model: firstNews)
            mainNews.publisher(for: .touchUpInside)
                .sink { [weak self] _ in
                    guard let self else { return }
                    self.mainNews.animate(.bouncy)
                    model.selectedNews.send(firstNews)
                }
                .store(in: &bag)
			mainNews.isHidden = false
		}
		
		if news.count >= 3 {
			let otherViews: [UIView] = Array(news[1..<3]).compactMap { news in
				let view = NewsEventView()
				view.configureView(model: news)
                view.publisher(for: .touchUpInside)
                    .sink { _ in
                        view.animate(.bouncy)
                        model.selectedNews.send(news)
                    }
                    .store(in: &bag)
				return view
			}
            otherNews.removeChildViews()
			otherViews.addToView(otherNews)
			otherNews.spacing = 8
			otherNews.distribution = .fillEqually
			otherNews.isHidden = false
		}
	}
}


class NewsEventView: UIControl  {
	
	private var news: NewsModel?
	private lazy var imageView: UIImageView = { .init() }()
	private lazy var authorTitle: UILabel = { .init() }()
	private lazy var newsTitle: UILabel = { .init() }()
    private var tickersView: TickerSymbolView = { .init() }()
    private var bag: Set<AnyCancellable> = .init()
	private let largeCard: Bool
    private var tapped: Bool = false
	init(largeCard: Bool = false) {
		self.largeCard = largeCard
		super.init(frame: .zero)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		self.largeCard = false
		super.init(coder: coder)
		setupView()
	}
	
	var height: CGFloat { largeCard ? (CGFloat.totalWidth - 32) * 0.7 : 140 }
	
	private func setupView() {
        let blobLabel = authorTitle.blobify(backgroundColor: .surfaceBackground, edgeInset: .init(vertical: 8, horizontal: 12), borderColor: .clear, borderWidth: 0)
        let infoStack = UIView.VStack(subViews: [newsTitle, .spacer(), blobLabel, tickersView],spacing: 8, alignment: .leading)
        let bgView = UIView()
        bgView.backgroundColor = .black.withAlphaComponent(0.5)
        
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		authorTitle.numberOfLines = 1
        newsTitle.numberOfLines = 4
		
        [imageView, bgView, infoStack].addToView(self)
        
        imageView.fillSuperview()
        bgView.fillSuperview()
        infoStack.fillSuperview(inset: .init(by: 16))
        
        setHeight(height: largeCard ? 375 : 275, priority: .needed)
		clipsToBounds = true
		cornerRadius = 16
	}
	
	public func configureView(model: NewsModel, addTapGesture: Bool = true) {
		
		news = model
		
		UIImage.loadImage(url: model.imageUrl, at: imageView, path: \.image)
            .store(in: &bag)
		
        model.sourceName.body3Medium(color: .gray).render(target: authorTitle)
        model.title.body1Bold(color: .white).render(target: newsTitle)
		
        guard let tickers = model.tickers else { return }
        tickersView.isHidden = tickers.isEmpty
		if let validNews = news, !tickers.isEmpty {
            tickersView.configTickers(news: validNews)
        }
	}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesMoved(touches, with: event)
        print(#function)
        tapped = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        if tapped {
            self.sendActions(for: .touchUpInside)
            self.tapped = false
        }
    }
}


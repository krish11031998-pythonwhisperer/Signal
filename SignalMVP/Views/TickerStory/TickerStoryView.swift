//
//  TickerStoryView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 12/11/2022.
//

import Foundation
import UIKit
import Combine
//MARK: - Defination

class TickerStoryView: UIViewController {
    
    //MARK: - Properties
    private var newsForTicker: [NewsModel] = []
    private var idx: Int = -1 { didSet { loadWithNews() } }
    private var bag: Set<AnyCancellable> = .init()
    private lazy var mainImageView: UIImageView = { .standardImageView() }()
    private lazy var mainLabel: UILabel = { .init() }()
    private lazy var mainDescriptionLabel: UILabel = { .init() }()
    private lazy var timerStack: UIStackView = { .HStack(spacing: 6) }()
    private lazy var tickerInfo: UIStackView = { .HStack(spacing: 10, alignment: .center) }()
    private lazy var headerStack: UIStackView = { .VStack(subViews: [timerStack, tickerInfo], spacing: 32) }()
    private lazy var tickers: TickerSymbolView = { .init() }()
    private var imgCancellable: AnyCancellable?
    private let mention: MentionTickerModel
    private lazy var swipeUp: UIView = {
        let chevronImage = UIImage.Catalogue.arrowUp.image.withTintColor(.textColor, renderingMode: .alwaysOriginal).imageView(size: .init(squared: 16), cornerRadius: 0)
        chevronImage.animate(.shakeUpDown(duration: 1))
        let viewMore = "View More".bodySmallRegular().generateLabel
        let view: UIStackView = .VStack(subViews: [chevronImage, viewMore], spacing: 5, alignment: .center)
        return view
    }()
    private lazy var stack: UIStackView = {
        let stack: UIStackView = .VStack(subViews:[headerStack, .spacer(), mainLabel, mainDescriptionLabel, .HStack(subViews: [tickers, .spacer()], spacing: 10, alignment: .center), swipeUp],spacing: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(vertical: 24, horizontal: 20)
        return stack
    }()
    
    private lazy var dimmingLayer: CALayer = { self.view.gradient(color: .gradientColor, direction: .down) }()
    
    private lazy var leftTapDimmingView: CALayer = { self.view.gradient(color: .lightGradientColor, direction: .left) }()
    
    private lazy var rightTapDimmingView: CALayer = { self.view.gradient(color: .lightGradientColor, direction: .right) }()
    
    private var panVerticalPoint: CGPoint = .zero
    private var onDismiss: Bool = false
    private var direction: CGPoint.Direction = .none
    
    //MARK: - Overriden Methods
    init(mention: MentionTickerModel) {
        self.mention = mention
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchStory()
        hideNavbar()
    }
    
    //MARK: - Protected Methods
    private func setupView() {
        view.overrideUserInterfaceStyle = .dark
        let container = UIView()
        view.backgroundColor = .black
        view.addSubview(container)
        view.setFittingConstraints(childView: container, insets: CGFloat.safeAreaInsets)
        
        [mainImageView, stack].addToView(container)
        
        container.subviews.forEach {
            container.setFittingConstraints(childView: $0, insets: .zero)
        }
        
        [dimmingLayer, leftTapDimmingView, rightTapDimmingView].forEach(mainImageView.layer.addSublayer(_:))
        leftTapDimmingView.opacity = 0
        rightTapDimmingView.opacity = 0
        
        container.clippedCornerRadius = 24
        mainLabel.numberOfLines = 3
        mainDescriptionLabel.numberOfLines = 2
        
        setupTickerInfo()
        stack.alpha = 0
    }
    
    private func setupTimer() {
        let count = newsForTicker.count
        timerStack.distribution = .fillEqually
        timerStack.removeChildViews()
        Array(repeating: 0, count: count).enumerated().forEach { _ in
            let timerBlob = UIView()
            timerBlob.backgroundColor = .black.withAlphaComponent(0.5)
            timerBlob.setHeight(height: 4, priority: .required)
            timerBlob.clippedCornerRadius = 2
            timerStack.addArrangedSubview(timerBlob)
        }
    }
    
    private func setupTickerInfo() {
        let tickerImage = UIImageView()
        imgCancellable = UIImage.loadImage(url: mention.ticker.logoURL, at: tickerImage, path: \.image)
        tickerImage.setFrame(.init(squared: 32))
        let tickerName = mention.ticker.body1Bold().generateLabel
        let closeButton = UIImage.Catalogue.xMark.buttonView.buttonify(bouncyEffect: false) {
            self.popViewController()
        }
        [tickerImage, tickerName, .spacer(), closeButton].addToView(tickerInfo)
    }
    
    
    private func fetchStory() {
        let ticker = mention.ticker
        TickerService
            .shared
            .fetchStory(ticker: ticker, refresh: false)
            .compactMap { $0.data }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                if let err = $0.err?.localizedDescription {
                    print("(ERROR) err: ", err)
                }
            }, receiveValue: { [weak self] model in
                guard let self else { return }
                self.updateView(model)
            })
            .store(in: &bag)

    }
    
    private func updateView(_ model: StoryModel) {
        if let news = model.news {
            newsForTicker.append(contentsOf: news)
        }
        
        if let video = model.video {
            newsForTicker.append(contentsOf: video)
        }
        
        if !newsForTicker.isEmpty {
            newsForTicker = newsForTicker.sorted(by: {(Date.convertStringToDate($0.date) ?? .init()) < (Date.convertStringToDate($1.date) ?? .init())})
            idx = 0
            stack.animate(.fadeIn())
        }
    }
    
    
    private func loadWithNews() {
        guard idx >= 0, idx < newsForTicker.count else { return }
        let news = newsForTicker[idx]
        if imgCancellable != nil {
            imgCancellable?.cancel()
        }
        imgCancellable = UIImage.loadImage(url: news.imageUrl, at: mainImageView, path: \.image)
        setupTimer()
        timerStack.arrangedSubviews.enumerated().forEach { $0.element.backgroundColor = $0.offset <= idx ? .white : .black.withAlphaComponent(0.5) }
        news.title.heading2().render(target: mainLabel)
        news.text.body2Regular().render(target: mainDescriptionLabel)
        tickers.configTickers(news: news)
        if news.type == "Video" {
            mainImageView.contentMode = .scaleAspectFit
        } else {
            mainImageView.contentMode = .scaleAspectFill
        }
    }
    
    private func showNews() {
        let target = NewsDetailView(news: newsForTicker[idx]).withNavigationController()
        presentView(style: .sheet(size: .init(width: .totalWidth, height: .totalHeight)), addDimmingView: false, target: target) {
            self.direction = .none
            self.panVerticalPoint = .zero
        }
    }
}


// MARK: - StoryInteraction
extension TickerStoryView {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard direction == .none else {
            if direction == .top {
                showNews()
            } else {
                direction = .none
                panVerticalPoint = .zero
            }
            return
        }

        guard let latestTouch = touches.first else { return }
        let point = latestTouch.location(in: view)
        if point.x < .totalWidth * 0.45 {
            leftTapDimmingView.animate(.fadeIn(duration: 0.1), removeAfterCompletion: true) {
                self.idx -= 1
            }
        } else if point.x > .totalWidth * 0.55 {
            rightTapDimmingView.animate(.fadeIn(duration: 0.1), removeAfterCompletion: true) {
                self.idx += 1
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let latestTouch = touches.first else { return }
        let point = latestTouch.location(in: view)
        guard panVerticalPoint != .zero else {
            panVerticalPoint = point
            return
        }
        
        guard
            (point.y.magnitude - panVerticalPoint.y.magnitude).magnitude > 20,
            direction == .none
        else { return }
        direction =  CGPoint.swipeDirection(point, panVerticalPoint)
    }
}

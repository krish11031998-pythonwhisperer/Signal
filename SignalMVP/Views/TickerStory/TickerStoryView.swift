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
    private lazy var mainImageView: UIImageView = { .init() }()
    private lazy var mainLabel: UILabel = { .init() }()
    private lazy var mainDescriptionLabel: UILabel = { .init() }()
    private lazy var timerStack: UIStackView = { .HStack(spacing: 6) }()
    private lazy var tickerInfo: UIStackView = { .HStack(spacing: 10, alignment: .center) }()
    private lazy var headerStack: UIStackView = { .VStack(subViews: [timerStack, tickerInfo], spacing: 32) }()
    private lazy var tickers: UIView = { .init() }()
    private let mention: MentionModel
    private lazy var swipeUp: UIView = {
        let chevronImage = UIImage.Catalogue.arrowUp.image.withTintColor(.textColor, renderingMode: .alwaysOriginal).imageView(size: .init(squared: 16), cornerRadius: 0)
        chevronImage.animate(.slideUpDown(duration: 1))
        let viewMore = "View More".bodySmallRegular().generateLabel
        let view: UIStackView = .VStack(subViews: [chevronImage, viewMore], spacing: 5, alignment: .center)
        return view
    }()
    private lazy var stack: UIStackView = {
        let stack: UIStackView = .VStack(subViews:[headerStack, .spacer(), mainLabel, mainDescriptionLabel, tickers, swipeUp],spacing: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(vertical: 24, horizontal: 20)
        return stack
    }()
    
    private lazy var dimmingLayer: CALayer = {
        let gradient: CAGradientLayer = .init()
        gradient.colors = [UIColor.clear, UIColor.black.withAlphaComponent(0.75), UIColor.black].compactMap { $0.cgColor }
        view.layer.addSublayer(gradient)
        gradient.frame = self.view.bounds
        return gradient
    }()
    
    private lazy var leftTapDimmingView: CALayer = {
        let bounds = self.view.bounds
        let gradient: CAGradientLayer = .init()
        gradient.colors = [UIColor.black.withAlphaComponent(0.5), UIColor.clear].compactMap { $0.cgColor }
        gradient.frame = self.view.bounds
        gradient.startPoint = .zero
        gradient.endPoint = .init(x: 1, y: 0)
        return gradient
    }()
    
    private lazy var rightTapDimmingView: CALayer = {
        let bounds = self.view.bounds
        let gradient: CAGradientLayer = .init()
        gradient.colors = [UIColor.black.withAlphaComponent(0.5), UIColor.clear].compactMap { $0.cgColor }
        gradient.frame = bounds
        gradient.endPoint = .zero
        gradient.startPoint = .init(x: 1, y: 0)
        return gradient
    }()
    
    private var panVerticalPoint: CGPoint = .zero
    private var onDismiss: Bool = false
    private var direction: CGPoint.Direction = .none
    
    //MARK: - Overriden Methods
    init(mention: MentionModel) {
        self.mention = mention
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchNews()
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
    }
    
    private func fetchNews() {
        let ticker = mention.ticker
        StubNewsService.shared
            .fetchNews(tickers: ticker)
            .compactMap { $0.data }
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                case .failure(let err):
                    print("(DEBUG) err:", err)
                default: break
                }
            } receiveValue: {[weak self] in
                self?.newsForTicker = $0
                self?.idx = $0.isEmpty ? -1 : 0
            }
            .store(in: &bag)

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
        UIImage.loadImage(url: mention.ticker.logoURL, at: tickerImage, path: \.image)
        
        tickerImage.setFrame(.init(squared: 32))
        
        let tickerName = mention.ticker.body1Bold().generateLabel
        
        let buttonImg = UIImage(systemName: "xmark")?.resized(size: .init(squared: 16))
        let imgView = UIImageView(image: buttonImg)
        imgView.circleFrame = .init(origin: .zero, size: .init(squared: 32))
        imgView.backgroundColor = .surfaceBackgroundInverse
        imgView.contentMode = .center
        imgView.setFrame(.init(squared: 32))
        let closeButton = imgView.buttonify {
            self.popViewController()
        }
        
        [tickerImage, tickerName, .spacer(), closeButton].addToView(tickerInfo)
    }
    
    private func configTickers(model: NewsModel) {
        guard !model.tickers.isEmpty else {
            if !tickers.isHidden {
                tickers.isHidden = true
            }
            return
        }
        tickers.removeChildViews()
        model.tickers.enumerated().forEach {
            let imgView = UIImageView(size: .init(squared: 32), cornerRadius: 16, contentMode: .scaleAspectFit)
            UIImage.loadImage(url: $0.element.logoURL, at: imgView, path: \.image)
            tickers.addSubview(imgView)
            tickers.setFittingConstraints(childView: imgView, top: 0, leading: CGFloat($0.offset * 24), bottom: 0,width: 32, height: 32)
        }
        tickers.isHidden = false
    }

    
    private func loadWithNews() {
        guard idx >= 0, idx < newsForTicker.count else { return }
        let news = newsForTicker[idx]
        UIImage.loadImage(url: news.imageUrl, at: mainImageView, path: \.image)
        mainImageView.contentMode = .scaleAspectFill
        setupTimer()
        timerStack.arrangedSubviews.enumerated().forEach { $0.element.backgroundColor = $0.offset <= idx ? .white : .black.withAlphaComponent(0.5) }
        news.title.heading2().render(target: mainLabel)
        news.text.body2Regular().render(target: mainDescriptionLabel)
        configTickers(model: news)
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
            leftTapDimmingView.animate(.fadeIn(duration: 0.1)) {
                self.leftTapDimmingView.animate(.fadeOut(to: 0, duration: 0.05))
            }
            idx -= 1
        } else if point.x > .totalWidth * 0.55 {
            rightTapDimmingView.animate(.fadeIn(duration: 0.05)) {
                self.rightTapDimmingView.animate(.fadeOut(to: 0, duration: 0.05))
            }
            idx += 1
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

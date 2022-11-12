//
//  TickerStoryView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 12/11/2022.
//

import Foundation
import UIKit

//MARK: - Defination
fileprivate extension CGPoint {
    
    enum Direction: String {
        case left, right, top, bottom, none
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    var maxMagnitude: CGFloat { max(abs(x), abs(y)) }

    static func minDimDiff(_ a: CGPoint, _ b: CGPoint) -> Direction {
        let diff = a - b
        switch diff.maxMagnitude {
        case abs(diff.x):
            return diff.x < 0 ? .right : .left
        case abs(diff.y):
            return diff.y < 0 ? .top : .bottom
        default:
            return .none
        }
    }
    
}


class TicketStoryView: UIViewController {
    
    //MARK: - Properties
    private var newsForTicker: [NewsModel] = []
    private var idx: Int = -1 {
        didSet { loadWithNews() }
    }
    private lazy var mainImageView: UIImageView = { .init() }()
    private lazy var mainLabel: UILabel = { .init() }()
    private lazy var mainDescriptionLabel: UILabel = { .init() }()
    private lazy var timerStack: UIStackView = { .HStack(spacing: 6) }()
    private lazy var tickerInfo: UIStackView = { .HStack(spacing: 10, alignment: .center) }()
    private lazy var headerStack: UIStackView = { .VStack(subViews: [timerStack, tickerInfo], spacing: 32) }()
    private lazy var tickers: UIView = { .init() }()
    private lazy var stack: UIStackView = {
        let headerView = headerStack
        let title = self.mainLabel
        let description = mainDescriptionLabel
        let tickersView = tickers
        
        let stack: UIStackView = .VStack(subViews:[headerView, .spacer(), title, description, tickersView],spacing: 10)
        
        stack.isLayoutMarginsRelativeArrangement = true
        
        stack.layoutMargins = .init(vertical: 24, horizontal: 20)
        
        return stack
    }()
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    private var panVerticalPoint: CGPoint = .zero
    private var onDismiss: Bool = false
    private var direction: CGPoint.Direction = .none
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchNews()
        hideNavbar()
    }
    
    //MARK: - Protected Methods
    private func setupView() {
        let container = UIView()
        view.addSubview(container)
        view.setFittingConstraints(childView: container, insets: CGFloat.safeAreaInsets)
        
        [mainImageView, dimmingView, stack].addToView(container)
        container.setFittingConstraints(childView: mainImageView, insets: .zero)
        container.setFittingConstraints(childView: stack, insets: .zero)
        container.setFittingConstraints(childView: dimmingView, insets: .zero)
        
        mainImageView.backgroundColor = .gray
        container.clippedCornerRadius = 24
        mainLabel.numberOfLines = 3
        mainDescriptionLabel.numberOfLines = 2
        
        setupTickerInfo()
    }
    
    private func fetchNews() {
        guard let ticker = MentionStorage.selectedMention?.ticker else { return }
        StubNewsService.shared.fetchNews(tickers: ticker) { [weak self] result in
            guard let news = result.data?.data else { return }
            self?.newsForTicker = news
            asyncMain {
                self?.idx = news.isEmpty ? -1 : 0
            }
        }
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
        guard let mention = MentionStorage.selectedMention else { return }
        let tickerImage = UIImageView()
        UIImage.loadImage(url: mention.ticker.logoURL, at: tickerImage, path: \.image)
        
        tickerImage.setFrame(.init(squared: 32))
        
        let tickerName = mention.ticker.body1Bold().generateLabel
        
        let buttonImg = UIImage(systemName: "xmark")?.resized(to: .init(squared: 16))
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
}


// MARK: - StoryInteraction
extension TicketStoryView {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard direction == .none else {
            direction = .none
            panVerticalPoint = .zero
            print("(DEBUG) resetting")
            return
        }

        guard let latestTouch = touches.first else { return }
        let point = latestTouch.location(in: view)
        print("(DEBUG) touchesEnded : ", point)
        if point.x < .totalWidth * 0.35 {
            idx -= 1
        } else if point.x > .totalWidth * 0.65 {
            idx += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let latestTouch = touches.first else { return }
        let point = latestTouch.location(in: view)
        direction =  CGPoint.minDimDiff(point, panVerticalPoint)
        print("(DEBUG) direction : ", direction.rawValue)
        panVerticalPoint = point
    }
        
}

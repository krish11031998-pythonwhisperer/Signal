//
//  TweetDetailView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation
import UIKit
import Combine

//MARK: - TweetDetailView

class TweetDetailView: UIViewController {
    
    private let tweet: TweetModel?
    private var bag: Set<AnyCancellable> = .init()
	private lazy var profileHeader: ImageHeadSubHeaderView = { .init() }()
	private lazy var bodyLabel: UILabel = { .init() }()
	private lazy var imgView: TweetDetailImage = { .init() }()
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.backgroundColor = .clear
		scrollView.clipsToBounds = true
		scrollView.showsVerticalScrollIndicator = true
		return scrollView
	}()
	private var selectedMetric: TweetSentimentMetric?
	private lazy var tweetURLView: TweetURLView = { .init() }()
	private lazy var metricStack: TweetMetricsView = { .init() }()
    private lazy var mentionTickers: TickerSymbolView = { .init() }()
    private lazy var mentionedTickers: UIView = {
        return .VStack(subViews: ["Mentions".body2Medium(color: .gray).generateLabel,
                                  mentionTickers], spacing: 8, alignment: .leading)
    }()
    
	private var observer: NSKeyValueObservation?
	
    init(tweet: TweetModel) {
        self.tweet = tweet
        super.init(nibName: nil, bundle: nil)
    }
    
    init(tweet model: TweetCellModel) {
        self.tweet = model.model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		configureViews()
        bind()
	}
	
	
	private func setupViews() {
		view.backgroundColor = .surfaceBackground
		view.addSubview(scrollView)
		view.setFittingConstraints(childView: scrollView, insets: .zero)
		standardNavBar()
		let stack = UIView.VStack(subViews: [profileHeader, bodyLabel, mentionedTickers, imgView, tweetURLView], spacing: 12, alignment: .fill)
		stack.setCustomSpacing(20, after: profileHeader)
		stack.setCustomSpacing(20, after: imgView)
		imgView.isHidden = true
		tweetURLView.isHidden = true
		scrollView.addSubview(stack)
        //stack.addArrangedSubview(metricView)
		scrollView.setFittingConstraints(childView: stack, insets: .init(vertical: 10, horizontal: 16))
		stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
		
	}
    
	func configureViews() {
        tweet?.text?.styled(font: .light, color: .textColor, size: 25).render(target: bodyLabel)
		bodyLabel.numberOfLines = 0
		
		profileHeader.configure(config: .init(title: tweet?.user?.username,
                                              imgUrl: tweet?.user?.profileImageUrl,
                                              imgSize: .init(squared: 48)), radius: 24)

		if let url = tweet?.media?.first?.url ?? tweet?.media?.first?.previewImageUrl {
			imgView.configureView(url: url , cornerRadius: 10)
			imgView.setHeight(height: 350, priority: .required)
			imgView.isHidden = false
		}
        
        if let tags = tweet?.tickers {
            print("(DEBUG) tags :", tags)
            mentionedTickers.isHidden = tags.isEmpty
            mentionTickers.configTickers(tickers: tags)
        }
        
		
		if let url = tweet?.urls?.first {
			print("(DEBUG) tweetId: ", tweet?.id)
			tweetURLView.configureView(url)
			tweetURLView.isHidden = false
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
	}
    
    private func bind() {
        tweetURLView.publisher(for: .touchUpInside)
            .sink {[weak self] _ in
                guard let self,
                      let media = self.tweet?.urls?.first
                else { return }
                print("(DEBUG) media: ", media.url)
                let webPage = WebPageView(url: media.url, title: media.title ?? "").withNavigationController()
                self.presentView(style: .sheet(), target: webPage, onDimissal: nil)
            }
            .store(in: &bag)
    }
}

//MARK: - Metrics

extension TweetDetailView {
    
    private var metricView: UIView {
//        let header = "Metrics".heading2().generateLabel
//        let stack = UIStackView.VStack(subViews: [header], spacing: 20)
//        ["Bullish", "Bearish", "LOL", "Like", "Dislike"].forEach {
//            stack.addArrangedSubview(MetricRow(type: $0))
//        }
//        let metric = stack.blobify(backgroundColor: .surfaceBackground,
//                                   edgeInset: .init(vertical: 10, horizontal: 12.5),
//                                   borderColor: .clear,
//                                   borderWidth: 0,
//                                   cornerRadius: 12)
//        metric.addShadow()
//        return metric
        return NewTweetMetricView(reaction: tweet?.reactions)
    }
    
}

//MARK: - MetricRow
class MetricRow: UIView {
    private lazy var miniLabel: UILabel = { .init() }()
    private lazy var label: UILabel = { .init() }()
    private lazy var emojiView: UIImageView = { .standardImageView(frame: .init(origin: .zero, size: .init(squared: 24)), circleFrame: true) }()
    private let typeLabel: String
    private let selectedMetric: PassthroughSubject<String, Never>
    
    init(type: String, selectedMetric: PassthroughSubject<String, Never>) {
        self.typeLabel = type
        self.selectedMetric = selectedMetric
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        emojiView.backgroundColor = .surfaceBackground
        emojiView.addShadow()
        miniLabel.alpha = 0
        let emojiButton = emojiView.buttonify { [weak self] in
            guard let self else { return }
            self.selectedMetric.send(self.typeLabel)
        }
        
        let stack = UIStackView.HStack(subViews: [emojiButton, label, .spacer()], spacing: 12, alignment: .center)
        let mainStack = UIStackView.VStack(subViews: [miniLabel, stack], spacing: 12, alignment: .leading)

        
        addSubview(mainStack)
        setFittingConstraints(childView: mainStack, insets: .zero)
        typeLabel.body3Medium().render(target: miniLabel)
        typeLabel.body1Medium().render(target: label)
        backgroundColor = .blue
    }
    
    func animate(value to: CGFloat) {
        label.animate(.fadeOut()) {
            self.label.isHidden = false
            self.emojiView.animate(.transformX(to: self.emojiView.frame.midX + to * (self.frame.width - self.emojiView.frame.width * 1.5)))
            self.miniLabel.animate(.fadeIn())
        }
    }
    
}

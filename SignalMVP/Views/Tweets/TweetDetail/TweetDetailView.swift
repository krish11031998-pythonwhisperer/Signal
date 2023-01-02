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
    private lazy var profileHeader: RoundedCardView = { .init(appearance: .init(backgroundColor: .surfaceBackground, cornerRadius: 0, insets: .zero, iterSpacing: 12, lineSpacing: 8)) }()
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
        if UserDefaultStoreKey.loggedIn.value() == true  {
            stack.addArrangedSubview(NewTweetMetricView(reaction: tweet?.reactions))
        }
		scrollView.setFittingConstraints(childView: stack, insets: .init(vertical: 10, horizontal: 16))
		stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
		
	}
    
	func configureViews() {
        tweet?.text?.styled(font: .regular, color: .textColor, size: 20).render(target: bodyLabel)
		bodyLabel.numberOfLines = 0
		
        profileHeader.configureView(with: .init(title: tweet?.user?.name.body2Medium(),
                                                subTitle: tweet?.user?.username.body3Medium(color: .gray),
                                                leadingView: .image(url: tweet?.user?.profileImageUrl,
                                                                    size: .init(squared: 48),
                                                                    cornerRadius: 24,
                                                                    bordered: false)))?.forEach{  bag.insert($0) }

        if let tags = tweet?.tickers {
            print("(DEBUG) tags :", tags)
            mentionedTickers.isHidden = tags.isEmpty
            mentionTickers.configTickers(tickers: tags)
        }
        
		
        if let url = tweet?.urls?.first, url.images != nil {
			tweetURLView.configureView(url)
			tweetURLView.isHidden = false
        } else if let imageUrl = tweet?.media?.first?.previewImageUrl {
            imgView.configureView(url: imageUrl , cornerRadius: 10)
            imgView.setHeight(height: 350, priority: .required)
            imgView.isHidden = false
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
        return NewTweetMetricView(reaction: tweet?.reactions)
    }
    
}

//MARK: - MetricRow
class MetricRow: UIView {
    private lazy var miniLabel: UILabel = { .init() }()
    private lazy var label: UILabel = { .init() }()
    private lazy var emojiView: UILabel = { .init() }()
    private lazy var progressBar: ProgressBar = { .init(bgColor: .clear, fillColor: .surfaceBackgroundInverse, borderWidth: 1) }()
    private let type: MetricType
    private let selectedMetric: PassthroughSubject<String, Never>
    
    init(type: MetricType, selectedMetric: PassthroughSubject<String, Never>) {
        self.type = type
        self.selectedMetric = selectedMetric
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        emojiView.setFrame(.init(squared: 25))
        emojiView.backgroundColor = .surfaceBackgroundInverse
        emojiView.clippedCornerRadius = 12.5
        emojiView.addShadow()
        emojiView.textAlignment = .center
        
        miniLabel.alpha = 0
  
        let emojiButton = emojiView.buttonify { [weak self] in
            guard let self else { return }
            self.selectedMetric.send(self.type.rawValue)
        }
        
        let stackWithProgressView: UIView = .init()
        let stack = UIStackView.HStack(subViews: [emojiButton, label], spacing: 12, alignment: .center)
        [progressBar,stack].addToView(stackWithProgressView)
        [progressBar,stack].forEach { stackWithProgressView.setFittingConstraints(childView: $0, insets: .zero) }
        let mainStack = UIStackView.VStack(subViews: [miniLabel, stackWithProgressView], spacing: 12, alignment: .leading)

        mainStack.setFittingConstraints(childView: stackWithProgressView, leading: 0, trailing: 0, height: 25)
        
        addSubview(mainStack)
        setFittingConstraints(childView: mainStack, insets: .zero)
        type.rawValue.body3Medium().render(target: miniLabel)
        type.rawValue.body1Medium().render(target: label)
        
        miniLabel.isHidden = true
        type.imgStr.styled(font: .medium, color: .textColor, size: 10).render(target: emojiView)
        progressBar.alpha = 0
        
    }
    
    func animate(value to: CGFloat) {
        label.animate(.fadeOut())
        progressBar.animate(.fadeIn()) {
            self.miniLabel.isHidden = false
            self.label.isHidden = false
            self.miniLabel.animate(.fadeIn())
            guard to > 0.1 else { return }
            self.emojiView.animate(.transformX(to: to * self.frame.width - self.emojiView.frame.width, duration: 0.5))
            self.progressBar.setProgress(progress: to)
            UIView.animate(withDuration: 0.15) {
                self.layoutIfNeeded()
            }
        }
    }
    
}



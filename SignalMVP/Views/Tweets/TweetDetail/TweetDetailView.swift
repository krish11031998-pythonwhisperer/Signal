//
//  TweetDetailView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation
import UIKit

fileprivate class TweetDetailImage: UIView {
	
	private lazy var img: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFit
		image.clipsToBounds = true
		return image
	}()
	
	private lazy var backgroundImage: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFill
		image.clipsToBounds = true
		return image
	}()
	
	private lazy var blurView : UIView = {
		let view = UIView()
		view.addBlurView()
		return view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}
	
	private func setupView() {
		[backgroundImage, blurView, img].forEach {
			addSubview($0)
			setFittingConstraints(childView: $0, insets: .zero)
		}
		clipsToBounds = true
	}
	
	public func configureView(url: String, cornerRadius: CGFloat) {
		UIImage.loadImage(url: url, at: img, path: \.image)
		UIImage.loadImage(url: url, at: backgroundImage, path: \.image)
		self.cornerRadius = cornerRadius
	}
	
}

//MARK: - TweetDetailView

class TweetDetailView: UIViewController {
    
    private let tweet: TweetCellModel
    
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
	private var observer: NSKeyValueObservation?
	
    init(tweet: TweetCellModel) {
        self.tweet = tweet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		configureViews()
		observer = scrollView.observe(\.contentOffset, changeHandler: { [weak self] scrollView, _ in
			self?.scrollObserver(scrollView)
		})
	}
	
	
	private func setupViews() {
		view.backgroundColor = .surfaceBackground
		view.addSubview(scrollView)
		view.setFittingConstraints(childView: scrollView, insets: .zero)
		standardNavBar()
		let stack = UIView.VStack(subViews: [profileHeader, bodyLabel, imgView,tweetURLView], spacing: 12, alignment: .fill)
		stack.setCustomSpacing(20, after: profileHeader)
		stack.setCustomSpacing(20, after: imgView)
		imgView.isHidden = true
		tweetURLView.isHidden = true
		scrollView.addSubview(stack)
		scrollView.setFittingConstraints(childView: stack, insets: .init(vertical: 10, horizontal: 16))
		stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
		
	}
	
	func configureViews() {
        tweet.model?.text.styled(font: .light, color: .textColor, size: 25).render(target: bodyLabel)
		bodyLabel.numberOfLines = 0
		
		profileHeader.configure(config: .init(title: tweet.user?.username,
											  imgUrl: tweet.user?.profileImageUrl,
											  imgSize: .init(squared: 48)), radius: 24)

		if let url = tweet.media?.first?.url ?? tweet.media?.first?.previewImageUrl {
			imgView.configureView(url: url , cornerRadius: 10)
			imgView.setHeight(height: 350, priority: .required)
			imgView.isHidden = false
		}
		
		if let url = tweet.model?.urls?.first {
			print("(DEBUG) tweetId: ", tweet.model?.id)
			tweetURLView.configureView(url)
			tweetURLView.isHidden = false
		}
		
	}
	
	private func scrollObserver(_ scrollView: UIScrollView) {
		guard let leftNavbar = navigationItem.leftBarButtonItem else { return }
		let factor: CGFloat = (0...20).percent(scrollView.contentOffset.y).boundTo()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
	}
}

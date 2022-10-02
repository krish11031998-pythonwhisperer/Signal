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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		configureViews()
	}
	
	
	private func setupViews() {
		view.backgroundColor = .surfaceBackground
		view.addSubview(scrollView)
		view.setFittingConstraints(childView: scrollView, insets: .zero)

		let stack = UIView.VStack(subViews: [profileHeader, bodyLabel, imgView,tweetURLView], spacing: 12, alignment: .fill)
		stack.setCustomSpacing(20, after: profileHeader)
		stack.setCustomSpacing(20, after: imgView)
		imgView.isHidden = true
		tweetURLView.isHidden = true
		scrollView.addSubview(stack)
		scrollView.setFittingConstraints(childView: stack, insets: .init(vertical: 10, horizontal: 16))
		stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
		
//		stack.addArrangedSubview(metricStack)
	}
	
	func configureViews() {
		guard let validTweet = TweetStorage.selectedTweet else { return }
	
		validTweet.model?.text.styled(font: .light, color: .textColor, size: 25).render(target: bodyLabel)
		bodyLabel.numberOfLines = 0
		
		profileHeader.configure(config: .init(title: validTweet.user?.username,
											  imgUrl: validTweet.user?.profileImageUrl,
											  imgSize: .init(squared: 48)), radius: 24)

		if let url = validTweet.media?.first?.url ?? validTweet.media?.first?.previewImageUrl {
			imgView.configureView(url: url , cornerRadius: 10)
			imgView.setHeight(height: 350, priority: .required)
			imgView.isHidden = false
		}
		
		if let url = validTweet.model?.urls?.first {
			print("(DEBUG) tweetId: ", validTweet.model?.id)
			tweetURLView.configureView(url)
			tweetURLView.isHidden = false
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
	}
}

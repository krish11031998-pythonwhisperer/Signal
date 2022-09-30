//
//  NewsDetailViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/09/2022.
//

import Foundation
import UIKit


extension NewsModel {
	
	func tickersBlob(width: CGFloat) -> UIView {
		let views: UIView = .flexibleStack(subViews: tickers.compactMap { $0.generateLabel.blobify() })
		return views.embedInView(insets: .init(vertical: 5, horizontal: 5))
	}
}

class NewsDetailViewController: UIViewController {
	
//MARK: - Properties
	
	private var scrollObserver: NSKeyValueObservation?
	
	private lazy var imageView: UIImageView = {
		let view = UIImageView(frame: .init(origin: .zero, size: .init(width: .totalWidth, height: 300)))
		view.contentMode = .scaleAspectFill
		view.clipsToBounds = true
		view.cornerRadius = 10
		view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
		return view
	}()
	
	private lazy var tableView: UITableView = { .init(frame: .zero, style: .grouped) }()
	
//MARK: - Overriden
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupNavBar()
		addObservers()
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
		setupTransparentNavBar()
	}
	
//MARK: - Protected Methods
	
	private func setupViews() {
		view.backgroundColor = .surfaceBackground
		view.addSubview(imageView)
		updateImage()
		
		view.addSubview(tableView)
		tableView.backgroundColor = .surfaceBackground
		view.setFittingConstraints(childView: tableView, insets: .init(top: 0, left: 0, bottom: 0, right: 0))
		tableHeaderView()
	}
	
	private func tableHeaderView() {
		guard let validNews = NewsStorage.selectedNews else { return }
		let stack = UIView.VStack(spacing: 8)
		
		let titleLabel = validNews.title.heading1().generateLabel
		let authorLabel = validNews.sourceName.body1Medium(color: .gray).generateLabel
		let blankView = UIView.emptyViewWithColor(color: .clear, height: 300)
		let bodyLabel = validNews.text.body1Regular(color: .white).generateLabel
		let tickers = validNews.tickersBlob(width: .totalWidth - 32)
		
		bodyLabel.numberOfLines = 0
		titleLabel.numberOfLines = 0
		
		[blankView, titleLabel, authorLabel, tickers, bodyLabel].forEach(stack.addArrangedSubview(_:))
		stack.setCustomSpacing(16, after: authorLabel)
		stack.clipsToBounds = true
		
		stack.setWidth(width: .totalWidth - 32, priority: .required)
		
		let headerView = stack.embedInView(insets: .init(vertical: 10, horizontal: 16))
		headerView.setFrame(width: .totalWidth, height: headerView.compressedSize.height)
		
		tableView.tableHeaderView = headerView
		tableView.backgroundColor = .clear
		
		tableView.contentInsetAdjustmentBehavior = .never
	}
	
	private func setupNavBar() {
		let img = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .medium))?
				.withTintColor(.white, renderingMode: .alwaysOriginal)
		let imgView = UIImageView(image: img?.resized(size: .init(squared: 10)))
		imgView.backgroundColor = .black
		imgView.contentMode = .center
		imgView.cornerFrame = .init(origin: .zero, size: .init(squared: 32))
		navigationItem.leftBarButtonItem = .init(title: nil,
												 image: imgView.snapshot.withRenderingMode(.alwaysOriginal),
												 target: self,
												 action: #selector(popVC))
	}
	
	
	private func updateImage() {
		guard let img = NewsStorage.selectedNews?.imageUrl else { return }
		UIImage.loadImage(url: img, at: imageView, path: \.image)
	}
	
	private func addObservers() {
		scrollObserver = tableView.observe(\.contentOffset) { [weak self] tableView, _ in
			self?.updateOnScroll(tableView)
		}
	}

	@objc
	private func popVC() {
		navigationController?.popViewController(animated: true)
	}
	
	@objc
	private func updateOnScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset
		let percent:CGFloat = 1 - (0...imageView.compressedSize.height.half).percent(offset.y).boundTo()
		guard !percent.isNaN else { return }
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
			self.imageView.transform = .init(scaleX: percent, y: percent)
		}
	}
}

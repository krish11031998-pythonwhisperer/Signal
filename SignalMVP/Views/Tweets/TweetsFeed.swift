//
//  TweetsFeed.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit


class TweetFeedViewController: UIViewController {
	
//	private var observer: NSKeyValueObservation?
	private var yOff: CGFloat = .leastNormalMagnitude
	private var tableViewInitialContentOffset: CGFloat?
	private lazy var viewModel: TweetFeedViewModel = {
		let model = TweetFeedViewModel()
		model.view = self
		return model
	}()
	
	private lazy var tableView: UITableView = {
		let tableView: UITableView = .init(frame: .zero, style: .grouped)
		tableView.showsVerticalScrollIndicator = false
		return tableView
	}()
	private var isScrolling: NSKeyValueObservation?
	private var scrollObserver: NSKeyValueObservation?
	
//MARK: - Overriden Methods
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupNavbar()
		viewModel.fetchTweets()
		addObservers()
		
	}
	
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		print("(DEBUG) viewDidLayoutSubViews is called!")
	}
	
//MARK: - Protected Methods

	private func setupViews() {
		view.addSubview(tableView)
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		view.setFittingConstraints(childView: tableView, insets: .zero)
		scrollObserver = tableView.observe(\.contentOffset){[weak self] scrollView, _ in
//			print("(DEBUG) offset has changed!")
			self?.setupScrollObserver(scrollView)
		}
	}
	
	private func setupScrollObserver(_ scrollView: UITableView) {
		guard scrollView.contentSize.height > .totalHeight,
			  scrollView.contentOffset.y >=  scrollView.contentSize.height - scrollView.frame.height,
			  !viewModel.loading else { return }
		self.viewModel.fetchNextPage()
	}
	
	private func setupNavbar() {
		self.navigationItem.title = "Tweets"
		setupTransparentNavBar()
	}
	
	private func addObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(showTweet), name: .showTweet, object: nil)
	}
	
	@objc
	private func showTweet() {
		navigationController?.pushViewController(TweetDetailView(), animated: true)
	}
	
	private func scrollViewUpdate(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset
		if self.yOff == .zero {
			self.yOff = offset.y
		}
		guard offset.y != yOff, let navBar = navigationController?.navigationBar else { return }
		let off = (self.yOff...0).percent(offset.y).boundTo()
		let navbarHeight: CGFloat = navBar.frame.height + navBar.frame.minY
		UIView.animate(withDuration: 0.25) {
			navBar.transform = .init(translationX: 0, y: -CGFloat(off) * navbarHeight)
		}
	}
}

//extension TweetFeedViewController: UITableViewDataSource {
//
//	func numberOfSections(in tableView: UITableView) -> Int { 1 }
//
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		viewModel.tweets?.count ?? 0
//	}
//
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as? TweetCell,
//			  let model = viewModel.tweets?[indexPath.row] else { return .init() }
//		cell.configure(with: model)
//		return cell
//	}
//
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		guard let model = viewModel.tweets?[indexPath.row] else { return }
//		TweetStorage.selectedTweet = model
//	}
//
//}
//
//extension TweetFeedViewController: UITableViewDelegate {
//
//	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		if scrollView.contentOffset.y >= scrollView.contentSize.height - 200 - scrollView.frame.height && !viewModel.loading {
//			self.viewModel.fetchNextPage()
//		}
//	}
//
//}


extension TweetFeedViewController: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
//		tableView.reloadData()
	}
}

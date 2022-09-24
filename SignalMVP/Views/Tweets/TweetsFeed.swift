//
//  TweetsFeed.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit


class TweetFeedViewController: UIViewController {
	
	private var observer: NSKeyValueObservation?
	private var yOff: CGFloat = .zero
	private lazy var viewModel: TweetFeedViewModel = {
		let model = TweetFeedViewModel()
		model.view = self
		return model
	}()
	
	private lazy var tableView: UITableView = { .init(frame: .zero, style: .grouped) }()
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
	
//MARK: - Protected Methods

	private func setupViews() {
		view.addSubview(tableView)
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		view.setFittingConstraints(childView: tableView, insets: .zero)
		observer = tableView.observe(\.contentOffset) { [weak self] tableView, _ in
			self?.scrollViewUpdate(tableView)
		}
		scrollObserver = tableView.observe(\.contentOffset, changeHandler: { [weak self] table, _ in self?.onTableViewScroll(table) })
	}
	
	private func setupNavbar() {
		self.navigationItem.title = "Tweets"
		setupTransparentNavBar()
	}
	
	private func onTableViewScroll(_ scrollView: UITableView) {
		//print("(DEBUG) table : ",scrollView.contentOffset)
		
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


extension TweetFeedViewController: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
	}
}

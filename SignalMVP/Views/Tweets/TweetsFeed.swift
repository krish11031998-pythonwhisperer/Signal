//
//  TweetsFeed.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit


class TweetFeedViewController: UIViewController {
	
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
		
		scrollObserver = tableView.observe(\.contentOffset, changeHandler: { [weak self] table, _ in self?.onTableViewScroll(table) })
	}
	
	private func setupNavbar() {
		self.navigationItem.title = "Tweets"
		
		let navbarAppear: UINavigationBarAppearance = .init()
		navbarAppear.configureWithTransparentBackground()
		navbarAppear.backgroundImage = UIImage()
		navbarAppear.backgroundColor = UIColor.blue
		
		self.navigationController?.navigationBar.standardAppearance = navbarAppear
		self.navigationController?.navigationBar.compactAppearance = navbarAppear
		self.navigationController?.navigationBar.scrollEdgeAppearance = navbarAppear
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
}


extension TweetFeedViewController: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
	}
}

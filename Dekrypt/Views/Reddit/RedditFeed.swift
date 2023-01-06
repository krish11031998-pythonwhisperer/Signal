//
//  RedditFeed.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation
import UIKit

class RedditFeedViewController: UIViewController {
	
//MARK: - Properties
	private var observer: NSKeyValueObservation?
	private var yOff: CGFloat = .zero
	
	private lazy var tableView: UITableView = {
		let table = UITableView(frame: .zero, style: .grouped)
		table.separatorStyle = .none
		table.backgroundColor = .clear
		return table
	}()
	
	private lazy var viewModel: RedditViewModel = {
		let model = RedditViewModel()
		model.view = self
		return model
	}()

//MARK: - Constructors
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavBar()
		setupView()
		viewModel.fetchRedditPosts()
		addObservers()
	}

//MARK: - Protected Methods
	
	private func setupView() {
		view.addSubview(tableView)
		view.setFittingConstraints(childView: tableView, insets: .zero)
		view.backgroundColor = .surfaceBackground
	}
	
	private func setupNavBar() {
		self.navigationItem.title = "Reddit"
		setupTransparentNavBar(color: .clear)
	}
	
	private func scrollViewUpdate(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset
		if self.yOff == .zero {
			self.yOff = offset.y
		}
		guard offset.y != yOff, let navBar = navigationController?.navigationBar else { return }
		let off = (self.yOff...0).percent(offset.y).boundTo()
		let navbarHeight: CGFloat = navBar.frame.height + navBar.frame.minY
		UIView.animate(withDuration: 0.1) {
			navBar.transform = .init(translationX: 0, y: -CGFloat(off) * navbarHeight)
		}
	}
	
	private func addObservers() {
		observer = tableView.observe(\.contentOffset) { [weak self] tableView, _ in
			self?.scrollViewUpdate(tableView)
		}
		NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: .updateTableView, object: nil)
	}
	
	@objc
	private func updateTableView() {
		UIView.animate(withDuration: 0.3) {
			self.tableView.performBatchUpdates(nil)
		}
	}
}

extension RedditFeedViewController: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
	}
}

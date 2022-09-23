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
	}

//MARK: - Protected Methods
	
	private func setupView() {
		view.addSubview(tableView)
		view.setFittingConstraints(childView: tableView, insets: .zero)
		view.backgroundColor = .clear
	}
	
	private func setupNavBar() {
		self.navigationItem.title = "Reddit"
		
		let navbarAppear: UINavigationBarAppearance = .init()
		navbarAppear.configureWithTransparentBackground()
		navbarAppear.backgroundImage = UIImage()
		navbarAppear.backgroundColor = UIColor.orange
		
		self.navigationController?.navigationBar.standardAppearance = navbarAppear
		self.navigationController?.navigationBar.compactAppearance = navbarAppear
		self.navigationController?.navigationBar.scrollEdgeAppearance = navbarAppear
	}
}

extension RedditFeedViewController: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
	}
}

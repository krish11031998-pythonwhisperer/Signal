//
//  EventsFeed.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

class EventsFeedViewController: UIViewController {
	
	private lazy var tableView: UITableView = {
		let table: UITableView = .init(frame: .zero, style: .grouped)
		table.backgroundColor = .clear
		table.separatorStyle = .none
		return table
	}()
	
	private lazy var viewModel: EventViewModel = {
		let model = EventViewModel()
		model.view = self
		return model
	}()
	
	//MARK: - Overriden Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		viewModel.fetchEvents()
		setupNavBar()
	}
	
	//MARK: - Protected Methods
	
	private func setupView() {
		view.addSubview(tableView)
		view.setFittingConstraints(childView: tableView, insets: .zero)
	}
	
	private func setupNavBar() {
		self.navigationItem.title = "Events"
		
		let navbarAppear: UINavigationBarAppearance = .init()
		navbarAppear.configureWithTransparentBackground()
		navbarAppear.backgroundImage = UIImage()
		navbarAppear.backgroundColor = UIColor.green
		
		self.navigationController?.navigationBar.standardAppearance = navbarAppear
		self.navigationController?.navigationBar.compactAppearance = navbarAppear
		self.navigationController?.navigationBar.scrollEdgeAppearance = navbarAppear
	}
}

//MARK: - AnyTableView

extension EventsFeedViewController: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
	}
}

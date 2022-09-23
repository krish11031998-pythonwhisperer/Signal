//
//  NewsViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit


class NewsViewController: UIViewController {
	
	private lazy var tableView: UITableView = { .init(frame: .zero, style: .grouped) }()
	
	private lazy var viewModel: NewsViewModel = {
		let model = NewsViewModel()
		model.view = self
		return model
	}()
	
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
		viewModel.fetchNews()
	}

	//MARK: - ProtectedMethods
	
	private func setupViews(){
		view.backgroundColor = .clear
		view.addSubview(tableView)
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		view.setFittingConstraints(childView: tableView, insets: .zero)
	}
	
	private func setupNavbar() {
		self.navigationItem.title = "News"
		
		let navbarAppear: UINavigationBarAppearance = .init()
		navbarAppear.configureWithTransparentBackground()
		navbarAppear.backgroundImage = UIImage()
		navbarAppear.backgroundColor = UIColor.red
		
		self.navigationController?.navigationBar.standardAppearance = navbarAppear
		self.navigationController?.navigationBar.compactAppearance = navbarAppear
		self.navigationController?.navigationBar.scrollEdgeAppearance = navbarAppear
	}
}


//MARK: - AnyView

extension NewsViewController: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
	}
}

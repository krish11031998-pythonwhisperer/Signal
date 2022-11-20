//
//  NewsViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

class NewsFeed: UIViewController {
	
	private lazy var tableView: UITableView = { .init(frame: .zero, style: .grouped) }()
//	private var observer: NSKeyValueObservation?
//	private var yOff: CGFloat = .zero
	
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
		setupObservers()
	}

	//MARK: - ProtectedMethods
	
	private func setupViews(){
		view.backgroundColor = .surfaceBackground
		view.addSubview(tableView)
		tableView.backgroundColor = .surfaceBackground
		tableView.separatorStyle = .none
		view.setFittingConstraints(childView: tableView, insets: .zero)
	}
	
	private func setupNavbar() {
		self.navigationItem.title = "News"
		setupTransparentNavBar()
	}
	
	private func setupObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(pushToNewsDetail), name: .showNews, object: nil)
	}
	
	@objc
	private func pushToNewsDetail() {
        guard let news = NewsStorage.selectedNews else { return }
        navigationController?.pushViewController(TickerStoryDetailView(news: news), animated: true)
	}
    
}


//MARK: - AnyView

extension NewsFeed: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
	}
}

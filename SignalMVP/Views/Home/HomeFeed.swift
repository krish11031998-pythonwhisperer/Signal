//
//  HomeFeed.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import UIKit

class HomeFeed: UIViewController {
	
//MARK: - Properties
	
	private lazy var tableView: UITableView = {
		let table: UITableView = .init(frame: .zero, style: .grouped)
		table.separatorStyle = .none
		return table
	}()

	private lazy var viewModel: HomeViewModel = {
		let model = HomeViewModel()
		model.view = self
		return model
	}()
	
//MARK: - Overriden Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		viewModel.fetchHomePageData()
		setupTransparentNavBar()
        addObservers()
	}
	
//MARK: - ProtectedMethods
	
	private func setupViews() {
		view.addSubview(tableView)
		view.setFittingConstraints(childView: tableView, insets: .zero)
		view.backgroundColor = .surfaceBackground
		tableView.backgroundColor = .clear
	}

//MARK: - Notification
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showMention), name: .showMention, object: nil)
    }
    
    @objc
    private func showMention() {
        navigationController?.pushViewController(TopMentionDetailView(), animated: true)
    }
	
}

//MARK: - AnyTable

extension HomeFeed: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
	}
}

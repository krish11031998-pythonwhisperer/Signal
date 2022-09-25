//
//  EventDetailView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 26/09/2022.
//

import Foundation
import UIKit

class EventDetailView: UIViewController {

//MARK: - Properties
	private lazy var tableView: UITableView = {
		let table = UITableView(frame: .zero, style: .grouped)
		table.separatorStyle = .none
		return table
	}()
	
//MARK: - Overriden Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
	}
	
//MARK: - Protected Methods
	
	private func setupView() {
		view.addSubview(tableView)
		view.setFittingConstraints(childView: tableView, insets: .zero)
		//setupTableHeaderView()
		tableView.reloadData(buildDataSource())
	}
	
	private func buildDataSource() -> TableViewDataSource {
		.init(sections: [section].compactMap { $0 })
	}
	
	private var section: TableSection? {
		guard let validEvent = EventStorage.selectedEvent else { return nil }
		return .init(rows: (validEvent.news[0...]).compactMap { TableRow<NewsCell>(.init(model: $0)) })
	}
	
	private func setupTableHeaderView() {
		guard let validEvent = EventStorage.selectedEvent else { return }
		let headerView =  EventDetailViewHeader(frame: .init(origin: .zero, size: .init(width: .totalWidth, height: 500)))
		headerView.configureHeader(validEvent)
//		headerView.setFrame(.init(width: .totalWidth, height: 500))
		tableView.tableHeaderView = headerView
	}
	
	
}

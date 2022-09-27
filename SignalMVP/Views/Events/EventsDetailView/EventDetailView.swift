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
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		EventStorage.selectedEvent = nil
	}
	
//MARK: - Protected Methods
	
	private func setupView() {
		view.addSubview(tableView)
		view.setFittingConstraints(childView: tableView, insets: .zero)
		setupTableHeaderView()
		tableView.reloadData(buildDataSource())
		setupObserver()
	}
	
	private func buildDataSource() -> TableViewDataSource {
		.init(sections: [heroSection, section].compactMap { $0 })
	}
	
	private var heroSection: TableSection? {
		guard let validEvent = EventStorage.selectedEvent else { return nil }
		var mainEvent = EventModel(date: validEvent.date, eventId: validEvent.eventId, eventName: validEvent.eventName, news: validEvent.news.limitTo(to: 3), tickers: [])
		return .init(rows: [TableRow<EventCell>(mainEvent)])
	}
	
	private var section: TableSection? {
		guard let validEvent = EventStorage.selectedEvent, validEvent.news.count > 3 else { return nil }
		return .init(rows: (validEvent.news[3...]).compactMap {news in TableRow<NewsCell>(.init(model: news, action: {
			NewsStorage.selectedNews = news
		})) })
	}
	
	private func setupTableHeaderView() {
		guard let validEvent = EventStorage.selectedEvent else { return }
		let headerView =  EventDetailViewHeader()
		headerView.configureHeader(validEvent)
		headerView.setFrame(.init(width: .totalWidth, height: headerView.compressedSize.height))
		tableView.tableHeaderView = headerView
		tableView.tableHeaderView?.setFrame(.init(width: .totalWidth, height: headerView.compressedSize.height))
	}
	
	private func setupObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(showNews), name: .showNews, object: nil)
	}
	
	@objc
	private func showNews() {
		navigationController?.pushViewController(NewsDetailViewController(), animated: true)
	}
	
	
}

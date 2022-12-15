//
//  EventsFeed.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

struct EventCellModel: ActionProvider {
	let model: EventModel
	var action: Callback?
}

class EventsFeedViewController: UIViewController {
	
	private var yOff: CGFloat = .zero
	
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
		setupObservers()
	}
	
	//MARK: - Protected Methods
	
	private func setupView() {
		view.addSubview(tableView)
		tableView.backgroundColor = .surfaceBackground
		view.backgroundColor = .surfaceBackground
		view.setFittingConstraints(childView: tableView, insets: .zero)
	}
	
	private func setupNavBar() {
        standardNavBar(leftBarButton: .init(customView: "Events".heading2().generateLabel))
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
	
	private func setupObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(showEventDetail), name: .showEvent, object: nil)
	}
	
	@objc
	private func showEventDetail() {
		navigationController?.pushViewController(EventDetailView(), animated: true)
	}
}

//MARK: - AnyTableView

extension EventsFeedViewController: AnyTableView {
	
	func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
		tableView.reloadData(dataSource)
	}
}

//
//  EventViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

class EventViewModel {
	
	var view: AnyTableView?
	var events: [EventModel]?
	
	
	public func fetchEvents() {
		StubEventService.shared.fetchEvents(query: []) { [weak self] result in
			switch result {
			case .success(let events):
				self?.events = Array(events.data.values)
				if let validDataSource = self?.buildDataSource() {
					DispatchQueue.main.async {
						self?.view?.reloadTableWithDataSource(validDataSource)
					}
				}
			case .failure(let err):
				print("(Error) err : ", err.localizedDescription)
			}
		}
	}
	
	
	private var EventsSingleSection: TableSection? {
		guard let events = self.events else {
			return nil
		}

		let label = UILabel()
		"Events (with single news Img Only)".styled(font: .systemFont(ofSize: 25, weight: .bold), color: .red).render(target: label)
		label.numberOfLines = 2
		
		
		return .init(rows: Set(events).compactMap { TableRow<EventSingleCell>($0) }, customHeader: label.embedInView(insets: .init(vertical: 10, horizontal: 16)))
	}
	
	private var EventsSection: TableSection? {
		guard let events = self.events else {
			return nil
		}
		
		let label = UILabel()
		"Events (with three news)".styled(font: .systemFont(ofSize: 25, weight: .bold), color: .red).render(target: label)
		
		return .init(rows: Set(events).compactMap { TableRow<EventCell>($0) }, customHeader: label.embedInView(insets: .init(vertical: 10, horizontal: 16)))
	}
	
	private func buildDataSource() -> TableViewDataSource {
		.init(sections: [EventsSection, EventsSingleSection].compactMap { $0 } )
	}
	
}

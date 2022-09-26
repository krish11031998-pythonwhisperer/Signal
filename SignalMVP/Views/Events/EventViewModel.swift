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
	
	
	private var EventsSection: TableSection? {
		guard let events = self.events else {
			return nil
		}
		
		let label = UILabel()
		"Events (with three news)".styled(font: .systemFont(ofSize: 25, weight: .bold), color: .white).render(target: label)
		
		return .init(rows: Set(events).compactMap {model in  TableRow<EventSingleCell>(.init(model: model, action: {
			print("(DEBUG) Clicked on Event")
			EventStorage.selectedEvent = model
		})) })
	}
	
	private func buildDataSource() -> TableViewDataSource {
		.init(sections: [EventsSection].compactMap { $0 } )
	}
	
}

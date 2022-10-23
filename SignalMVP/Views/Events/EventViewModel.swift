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
        StubEventService
			.shared
			.fetchEvents { [weak self] result in
                if let events = result.data?.data {
                    self?.events = events
                    asyncMain {
                        guard let validDataSource = self?.buildDataSource() else { return }
                        self?.view?.reloadTableWithDataSource(validDataSource)
                    }
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
			EventStorage.selectedEvent = model
		})) })
	}
	
	private func buildDataSource() -> TableViewDataSource {
		.init(sections: [EventsSection].compactMap { $0 } )
	}
	
}

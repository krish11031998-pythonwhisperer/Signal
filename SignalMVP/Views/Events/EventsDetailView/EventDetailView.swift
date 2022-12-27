//
//  EventDetailView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 26/09/2022.
//

import Foundation
import UIKit
import Combine

class EventDetailView: UIViewController {


//MARK: - Properties
	private lazy var tableView: UITableView = {
		let table = UITableView(frame: .zero, style: .grouped)
		table.separatorStyle = .none
		return table
	}()
    private var eventModel: EventModel?
    private var selectedNews: CurrentValueSubject<NewsModel?, Never> = .init(nil)
    private var bag: Set<AnyCancellable> = .init()
    
    init(eventModel: EventModel? = nil) {
        self.eventModel = eventModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.eventModel = nil
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Overriden Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
        bind()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
        setupTransparentNavBar(color: .surfaceBackground, scrollColor: .surfaceBackground)
	}
	
//MARK: - Protected Methods
	
	private func setupView() {
		view.addSubview(tableView)
		tableView.backgroundColor = .surfaceBackground
		view.backgroundColor = .surfaceBackground
		view.setFittingConstraints(childView: tableView, insets: .zero)
		tableView.reloadData(buildDataSource())
        standardNavBar(color: .clear, scrollColor: .clear)
	}
	
	private func buildDataSource() -> TableViewDataSource {
		.init(sections: [headerView, heroSection, section].compactMap { $0 })
	}
	
	private var headerView: TableSection? {
		guard let validEvent = eventModel else { return nil }
		return .init(rows: [TableRow<EventDetailViewHeader>(validEvent)])
	}
	
	private var heroSection: TableSection? {
		guard let validEvent = eventModel else { return nil }
		let mainEvent = EventModel(date: validEvent.date, eventId: validEvent.eventId, eventName: validEvent.eventName, news: validEvent.news.limitTo(to: 3), tickers: [])
        let model = EventNewsModel(model: mainEvent, selectedNews: selectedNews)
		return .init(rows: [TableRow<EventCell>(model)])
	}
	
	private var section: TableSection? {
		guard let validEvent = eventModel, validEvent.news.count > 3 else { return nil }
		return .init(rows: (validEvent.news[3...]).compactMap { news in
            let model: NewsCellModel = .init(model: news) {
                self.selectedNews.send(news)
            }
            return TableRow<NewsCell>(model)
        })
	}
    
    private func bind() {
        selectedNews
            .compactMap { $0 }
            .sink { [weak self] in
                guard let self else { return }
                self.navigationController?.pushViewController(NewsDetailView(news: $0), animated: true)
            }
            .store(in: &bag)
    }
	
}

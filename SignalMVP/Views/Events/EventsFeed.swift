//
//  EventsFeed.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit
import Combine
struct EventCellModel: ActionProvider {
	let model: EventModel
	var action: Callback?
}

class EventsFeedViewController: SearchViewController {
	
	private var yOff: CGFloat = .zero
    private let isChildPage: Bool
    private lazy var tableView: UITableView = { .standardTableView() }()
    private let refreshControl: UIRefreshControl = { .init() }()
    private var viewModel: EventFeedViewModel = .init()
//    private var bag: Set<AnyCancellable> = .init()
	//MARK: - Overriden Methods
	
    init(isChildPage: Bool = false) {
        self.isChildPage = isChildPage
        super.init(resultController: NewsSearchResultController.self)
    }
    
    required init?(coder: NSCoder) {
        self.isChildPage = false
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupNavBar()
		setupObservers()
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTransparentNavBar(color: .surfaceBackground, scrollColor: .surfaceBackground)
    }
	
	//MARK: - Protected Methods

	private func setupView() {
        tableView.refreshControl = refreshControl
		view.addSubview(tableView)
		tableView.backgroundColor = .surfaceBackground
		view.backgroundColor = .surfaceBackground
        view.setFittingConstraints(childView: tableView, insets: .init(top: 0, left: 0, bottom: .safeAreaInsets.bottom, right: 0))
	}
	
	private func setupNavBar() {
        if !self.isChildPage {
            standardNavBar(leftBarButton: .init(customView: "Events".heading2().generateLabel), color: .surfaceBackground)
        } else {
            standardNavBar(title: "Events".heading2())
        }
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
        
        viewModel.selectedEvent
            .sink { [weak self] in
                self?.navigationController?.pushViewController(EventDetailView(eventModel: $0), animated: true)
            }
            .store(in: &bag)
        
        let searchParam = searchText.eraseToAnyPublisher().share().makeConnectable()
        
        let refreshControl = refreshControl
            .publisher(for: .valueChanged)
            .withLatestFrom(searchParam)
            .map { _, search in search }
            .eraseToAnyPublisher()
        
        let output = viewModel.transform(input: .init(searchParam: searchParam,
                                                      refresh: refreshControl,
                                                      nextPage: tableView.nextPage.share()))
        
        output.tableSection
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self]  _ in
                self?.refreshControl.endRefreshing()
            })
            .sink(receiveCompletion: {
                print("(ERROR) err: ", $0.err?.localizedDescription)
            }, receiveValue: { [weak self] section in
                self?.tableView.reloadData(.init(sections: [section]), animation: .fade)
            })
            .store(in: &bag)
        
        searchParam
            .removeDuplicates()
            .sink { [weak self] in
                guard let self else {return}
                guard let search = $0, !search.isEmpty else {
                    self.tableView.animateHeaderView = nil
                    return
                }
                let headerView = self.accessoryDisplay(search: search)
                self.tableView.animateHeaderView = headerView
            }
            .store(in: &bag)
        
        searchParam.connect().store(in: &bag)
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
